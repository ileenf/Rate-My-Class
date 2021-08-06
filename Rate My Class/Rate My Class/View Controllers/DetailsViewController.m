//
//  DetailsViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import "DetailsViewController.h"
#import "ComposeViewController.h"
#import "ReviewModel.h"
#import "ReviewCell.h"
#import "Parse/Parse.h"
#import "NaturalLanguage/NaturalLanguage.h"
#import "DateTools.h"

static float lengthCalculationFactor = 25;
static float maxLengthScore = 2000;
static float maxToneScore = 2000;
static float maxContentScore = 2000;
static float lengthWeight = 0.3;
static float qualityWeight = 0.3;
static float toneAndContentWeight = 0.4;
static float maximumCountOfNeighboringWords = 3;

@interface DetailsViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *classCode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *overallRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallDifficultyLabel;
@property (nonatomic, strong) NSDictionary *userToLikesMapping;
@property float result;

@end

@implementation DetailsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.classCode.text = self.classObj.classCode;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];

    [self enableRefreshing];
    [self loadReviews];
}

- (void)didSubmitReview:(ReviewModel *)newReview {
    NSMutableArray *reviews = [NSMutableArray arrayWithArray:self.reviews];
    [reviews insertObject:newReview atIndex:0];
    self.reviews = [self sortReviewsFromHighToLowQuality:reviews withUserToLikesMapping:self.userToLikesMapping];
    
    [self.tableView reloadData];
    
    [self createConfettiParticles];
    
    NSDecimalNumber *averageRating =  [self calculateAverageRating];
    NSDecimalNumber *averageDifficulty = [self calculateAverageDifficulty];
    
    self.classObj.overallRating = [NSString stringWithFormat:@"%@", averageRating];
    self.classObj.overallDifficulty = [NSString stringWithFormat:@"%@", averageDifficulty];
    [self.classObj saveInBackground];
}

- (NSDecimalNumber *)calculateAverageRating {
    NSDecimalNumber *numberOfReviews = (NSDecimalNumber *)[NSDecimalNumber numberWithInteger:self.reviews.count];
    NSDecimalNumber *totalRating = [NSDecimalNumber zero];
    
    for (ReviewModel *review in self.reviews) {
        NSDecimalNumber *reviewRating = [NSDecimalNumber decimalNumberWithString:review.rating];
        totalRating = [totalRating decimalNumberByAdding:reviewRating];
    }
    NSDecimalNumber *averageRating = [totalRating decimalNumberByDividingBy:numberOfReviews];
    NSDecimalNumber *averageRatingRounded = [self roundDecimal:averageRating];
    
    return averageRatingRounded;
}

- (NSDecimalNumber *)calculateAverageDifficulty {
    NSDecimalNumber *numberOfReviews = (NSDecimalNumber *)[NSDecimalNumber numberWithInteger:self.reviews.count];
    NSDecimalNumber *totalDifficulty = [NSDecimalNumber zero];
    
    for (ReviewModel *review in self.reviews) {
        NSDecimalNumber *reviewDifficulty = [NSDecimalNumber decimalNumberWithString:review.difficulty];
        totalDifficulty = [totalDifficulty decimalNumberByAdding:reviewDifficulty];
    }
    NSDecimalNumber *averageDifficulty = [totalDifficulty decimalNumberByDividingBy:numberOfReviews];
    NSDecimalNumber *averageDifficultyRounded = [self roundDecimal:averageDifficulty];
    
    return averageDifficultyRounded;
}

- (NSDecimalNumber *)roundDecimal:(NSDecimalNumber *)amount {
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                              scale:2
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    
    NSDecimalNumber *roundedNumber = [amount decimalNumberByRoundingAccordingToBehavior:behavior];
    return roundedNumber;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSIndexPath *tapLocation = self.tableView.indexPathForSelectedRow;
        ReviewCell *cell = [self.tableView cellForRowAtIndexPath:tapLocation];
        
        if (![cell.review.usersLiked containsObject:[PFUser currentUser].username]){
            
            int value = [cell.review.likeCount intValue];
            cell.review.likeCount = [NSNumber numberWithInt:value + 1];
            
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", cell.review.likeCount];
            
            [cell.review addObject:[PFUser currentUser].username forKey:@"usersLiked"];
            [cell.likeIcon setSelected: YES];
            [cell.review saveInBackground];
        } 
    }
}

- (void)enableRefreshing {
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(loadReviews) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)loadReviews {
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    [query includeKey:@"classObject"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable reviews, NSError * _Nullable error) {
        if (error == nil){
            NSArray *currClassReviews = [self getCurrentClassReviews:reviews];
            self.userToLikesMapping = [self createUserToLikesMapping:reviews];
            
            self.reviews = [self sortReviewsFromHighToLowQuality:currClassReviews withUserToLikesMapping:self.userToLikesMapping];
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}
    
- (NSArray *)getCurrentClassReviews:(NSArray *)allReviews {
    NSMutableArray *reviews = [NSMutableArray array];
    
    for (ReviewModel *review in allReviews) {
        if ([review.classObject.classCode isEqualToString:self.classObj.classCode]) {
            [reviews addObject:review];
        }
    }
    return (NSArray *)reviews;
}
    
- (NSDictionary *)createUserToLikesMapping:(NSArray *)allReviews {
    NSMutableDictionary *userToLikesMapping = [NSMutableDictionary dictionary];
    for (ReviewModel *review in allReviews) {
        NSDecimalNumber *likeCount = [NSDecimalNumber decimalNumberWithDecimal:[review.likeCount decimalValue]];
        
        if ([userToLikesMapping objectForKey:review.author.username]) {
            NSNumber *currLikes = [userToLikesMapping objectForKey:review.author.username];
            NSDecimalNumber *currLikesDecimal = [NSDecimalNumber decimalNumberWithDecimal:[currLikes decimalValue]];
            currLikesDecimal = [currLikesDecimal decimalNumberByAdding:likeCount];
            [userToLikesMapping setObject:currLikesDecimal forKey:review.author.username];
        } else {
            [userToLikesMapping setObject:likeCount forKey:review.author.username];
        }
    }
    return (NSDictionary *)userToLikesMapping;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    ReviewModel *review = self.reviews[indexPath.row];

    cell.review = review;
        
    self.overallRatingLabel.text = [NSString stringWithFormat:@"%@", self.classObj.overallRating];
    self.overallDifficultyLabel.text = [NSString stringWithFormat:@"%@", self.classObj.overallDifficulty];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

- (void)createConfettiParticles {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CAEmitterLayer *confettiEmitter = [CAEmitterLayer layer];
    [confettiEmitter setFrame:CGRectMake(20, 20, screenWidth, screenHeight)];
    [confettiEmitter setEmitterPosition:CGPointMake(self.view.center.x, -50)];
    [confettiEmitter setEmitterShape:kCAEmitterLayerLine];
    [confettiEmitter setEmitterSize:CGSizeMake(self.view.frame.size.width, 1)];
    
    CAEmitterCell *confetti1 = [self makeConfettiEmitterCell:@"confetti1"];
    CAEmitterCell *confetti2 = [self makeConfettiEmitterCell:@"confetti2"];
    CAEmitterCell *confetti3 = [self makeConfettiEmitterCell:@"confetti3"];
    CAEmitterCell *confetti4 = [self makeConfettiEmitterCell:@"confetti4"];
    
    NSArray *confettiArray = [NSArray arrayWithObjects:confetti1, confetti2, confetti3, confetti4, nil];
    [confettiEmitter setEmitterCells:confettiArray];
    [self.view.layer addSublayer:confettiEmitter];
    
    [self performSelector:@selector(endConfettiEmitting:) withObject:confettiEmitter afterDelay:0.5];
}

- (CAEmitterCell *)makeConfettiEmitterCell:(NSString *)imageName {
    UIImage *confettiImage = [UIImage imageNamed:imageName];
    CAEmitterCell *confettiCell = [CAEmitterCell emitterCell];
    [confettiCell setContentsScale:8];
    [confettiCell setBirthRate:3];
    [confettiCell setLifetime:10];
    [confettiCell setVelocity:30];
    [confettiCell setEmissionLongitude:(CGFloat)M_PI];
    [confettiCell setEmissionRange:(CGFloat)M_PI/2];
    
    [confettiCell setContents:(id)confettiImage.CGImage];
    
    return confettiCell;
}

- (void)endConfettiEmitting:(CAEmitterLayer *)emitterLayer {
    [emitterLayer setBirthRate:0];
}

- (NSArray *)sortReviewsFromHighToLowQuality:(NSArray *)reviewsArray withUserToLikesMapping:(NSDictionary *)userToLikesMapping {
    if (reviewsArray.count >= 1) {
        ReviewModel *firstReview = reviewsArray[reviewsArray.count - 1];
        NSArray *sortedByQuality = [reviewsArray sortedArrayUsingComparator:^NSComparisonResult(ReviewModel *review1, ReviewModel *review2) {
            NSDecimalNumber *reviewScore1 = [NSDecimalNumber zero];
            NSDecimalNumber *reviewScore2 = [NSDecimalNumber zero];
            
            NSString *one = review1.comment;
            NSString *two = review2.comment;
            
            NSDecimalNumber *lengthScore1 = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:[self calculateLengthQuality:review1]];
            NSDecimalNumber *lengthScore2 = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:[self calculateLengthQuality:review2]];
            
            reviewScore1 = [reviewScore1 decimalNumberByAdding:lengthScore1];
            reviewScore2 = [reviewScore2 decimalNumberByAdding:lengthScore2];
            
            float qualityScore1 = [self calculateAverageQuality:review1 withFirstReview:firstReview withUserLikesMapping:userToLikesMapping];
            float qualityScore2 = [self calculateAverageQuality:review2 withFirstReview:firstReview withUserLikesMapping:userToLikesMapping];
            
            NSDecimalNumber *qualityScoreDecimal1 = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:qualityScore1];
            NSDecimalNumber *qualityScoreDecimal2 = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:qualityScore2];

            reviewScore1 = [reviewScore1 decimalNumberByAdding:qualityScoreDecimal1];
            reviewScore2 = [reviewScore2 decimalNumberByAdding:qualityScoreDecimal2];
            
            float toneContentScore1 = [self calculateToneAndContentQuality:review1.comment];
            float toneContentScore2 = [self calculateToneAndContentQuality:review2.comment];
            
            reviewScore1 = [reviewScore1 decimalNumberByAdding:(NSDecimalNumber *)[NSDecimalNumber numberWithFloat:toneContentScore1]];
            reviewScore2 = [reviewScore2 decimalNumberByAdding:(NSDecimalNumber *)[NSDecimalNumber numberWithFloat:toneContentScore2]];
            
            return [reviewScore2 compare:reviewScore1];
        }];
    
        return sortedByQuality;
    }
    
    return [NSArray array];
}

- (float)calculateLengthQuality:(ReviewModel *)review {
    /*
    highest quality range is 200 - 400 characters.
    The further the deviation from 200/400, the lower
    quality it is.
    */
    
    float score = 0;
    NSInteger length = [review.comment length];
    
    if (length >= 200 && length <= 400) {
        score += maxLengthScore;
    } else if (length < 200) {
        float scaledLength = length * (maxLengthScore / 10);
        score += (scaledLength / lengthCalculationFactor);
    } else if (length <= 600) {
        float scaledLength = (600 - length) * (maxLengthScore / 10);
        score += scaledLength / lengthCalculationFactor;
    }
    
    score = score * lengthWeight;
    return score;
}

- (float)calculateAverageQuality:(ReviewModel *)review withFirstReview:(ReviewModel *)firstReview withUserLikesMapping:(NSDictionary *)userLikesMapping{
    /*
    Calculates the review quality based on review like count, how long ago in minutes the review was posted, and the review author's like history.
    */

    float points = [review.likeCount floatValue] * 10;
    float totalAuthorLikes = [[userLikesMapping objectForKey:review.author.username] floatValue];
    float commentPositionValue = (points * totalAuthorLikes / 3) + (points / 10);
    
    float minAgoCurrReview = [self getTimeAgoReview:review];
    float minAgoFirstReview = [self getTimeAgoReview:firstReview];

    float timingVar = ((minAgoFirstReview/10 + minAgoCurrReview)/3) + (fabsf(minAgoCurrReview - minAgoFirstReview));
    float result = timingVar * commentPositionValue * 1.5;
    result = result * qualityWeight;
    
    return result;
}

- (float)getTimeAgoReview:(ReviewModel *)review {
    /*
    Getting the time ago review was created in hours.
    */
    
    NSDate *date = review.createdAt;
    NSInteger hoursAgoInt = [date hoursAgo];
    NSDecimalNumber *value = (NSDecimalNumber *)[NSDecimalNumber numberWithInteger:hoursAgoInt];
    float hoursAgoFloat = [value floatValue];
    
    return hoursAgoFloat;
}

- (float)calculateToneAndContentQuality:(NSString *)reviewComment {
    float toneScore = [self calculateToneQuality:reviewComment];
    float contentScore = [self calculateContentQuality:reviewComment];
    
    return (toneScore + 2 * contentScore) * toneAndContentWeight;
}

- (float)calculateToneQuality:(NSString *)reviewComment {
    /*
     Sentiment Analysis
     */
    NLTagger *taggerObj = [NLTagger alloc];
    NSArray *tagSchemes =[NSArray arrayWithObjects:NLTagSchemeTokenType, NLTagSchemeSentimentScore, nil];
    NLTagger *tagger = [taggerObj initWithTagSchemes:tagSchemes];
    [tagger setString:reviewComment];
    
    NSString *sentiment = [tagger tagAtIndex:0
                                        unit:NLTokenUnitParagraph
                                      scheme:NLTagSchemeSentimentScore
                                  tokenRange:nil];
    
    float sentimentValue = [sentiment floatValue];
    float toneScore = 0;
    
    if (sentimentValue >= -0.25) {
        toneScore += maxToneScore;
    } else if (sentimentValue < -0.25) {
        float scaledScore = (1 - fabsf(sentimentValue)) * maxToneScore;
        toneScore += scaledScore;
    } else {
        float scaledScore = (1 - sentimentValue) * maxToneScore;
        toneScore += scaledScore;
    }
    
    return toneScore;
}

- (float)calculateContentQuality:(NSString *)reviewComment {
    
    NSArray *allKeywords = [self getArrayOfKeywords];
    float numberOfKeywords = [self getNumberOfKeywrodsInReview:reviewComment withKeywordsArray:allKeywords];
    
    float ratio = 1 / (maximumCountOfNeighboringWords + 1);
    float scoreRatio = numberOfKeywords / allKeywords.count;
    float contentScore = 0;
    
    if (scoreRatio >= ratio) {
        contentScore += maxContentScore;
    } else {
        float scaledScore = scoreRatio * maxContentScore;
        contentScore += scaledScore;
    }
    
    return contentScore;
}

- (NSArray *)getArrayOfKeywords {
    /*
     Word embedding
     */
    NSMutableArray *allKeywords = [NSMutableArray array];
    NSArray *keywords = [NSArray arrayWithObjects:@"learn", @"grade", @"discussion", @"professor", @"quiz", @"participate", @"lesson", @"lecture", nil];
    
    for (NSString *word in keywords){
        NLEmbedding *embedding = [NLEmbedding wordEmbeddingForLanguage:@"en"];

        NSMutableArray *wordsArray = (NSMutableArray *)[embedding neighborsForString:word
                                                                        maximumCount:maximumCountOfNeighboringWords
                                                                        distanceType:NLDistanceTypeCosine];
        [wordsArray addObject:word];
        [allKeywords addObjectsFromArray:wordsArray];
    }
    
    return (NSArray *)allKeywords;
}

- (float)getNumberOfKeywrodsInReview:(NSString *)reviewComment withKeywordsArray:(NSArray *)allKeywords {
    /*
     Lemmatization
     */
    __block float numberOfKeywords = 0;
    
    NSRange range = NSMakeRange(0, [reviewComment length]);
    
    NLTagger *taggerObj = [NLTagger alloc];
    NSArray *tagSchemes =[NSArray arrayWithObjects:NLTagSchemeLemma, nil];
    NLTagger *tagger = [taggerObj initWithTagSchemes:tagSchemes];
    [tagger setString:reviewComment];
    
    [tagger enumerateTagsInRange:range
                            unit:NLTokenUnitWord
                          scheme:NLTagSchemeLemma
                         options:NLTaggerOmitWhitespace
                      usingBlock:^(NLTag  _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if (tag == nil) {
            tag = [reviewComment substringWithRange:tokenRange];
        }
        tag = [tag stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
        if (![tag isEqualToString:@""]) {
            if ([allKeywords containsObject:tag]) {
                numberOfKeywords += 1;
            }
        }
    }];
    
    return numberOfKeywords;
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ComposeSegue"]) {
        ComposeViewController *composeViewController = [segue destinationViewController];
        composeViewController.classObj = self.classObj;
        composeViewController.delegate = self;
    }
}

@end
