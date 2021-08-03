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

@interface DetailsViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *classCode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *overallRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallDifficultyLabel;

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
    self.reviews = reviews;
    
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
    [query whereKey:@"classObject" equalTo:self.classObj];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable reviews, NSError * _Nullable error) {
        if (error == nil){
            self.reviews = [self sortReviewsFromHighToLowQuality:reviews];
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
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

- (NSArray *)sortReviewsFromHighToLowQuality:(NSArray *)reviewsArray {
    NSArray *sortedByQuality = [reviewsArray sortedArrayUsingComparator:^NSComparisonResult(ReviewModel *review1, ReviewModel *review2) {
        NSDecimalNumber *reviewScore1 = [self calculateLengthQuality:review1];
        NSDecimalNumber *reviewScore2 = [self calculateLengthQuality:review2];
        
        return [reviewScore2 compare:reviewScore1];
    }];
    
    return sortedByQuality;
}

- (NSDecimalNumber *)calculateLengthQuality:(ReviewModel *)review {
    NSDecimalNumber *score = [NSDecimalNumber zero];
    NSInteger length = [review.comment length];
    NSDecimalNumber *ten = (NSDecimalNumber *)[NSDecimalNumber numberWithInteger:10];
    NSDecimalNumber *factorDecimal = (NSDecimalNumber *)[NSDecimalNumber numberWithInteger:25];
    
    // highest quality range 200 - 400 characters
    if (length >= 200 && length <= 400) {
        score = [score decimalNumberByAdding:ten];
    } else if (length < 200) {
        NSDecimalNumber *lengthDecimal = (NSDecimalNumber *)[NSDecimalNumber numberWithInteger:length];
        NSDecimalNumber *value = [lengthDecimal decimalNumberByDividingBy:factorDecimal];
        score = [score decimalNumberByAdding:value];
    } else if (length <= 600) {
        NSDecimalNumber *lengthDecimal2 = (NSDecimalNumber *)[NSDecimalNumber numberWithInteger:length-400];
        NSDecimalNumber *value = [lengthDecimal2 decimalNumberByDividingBy:factorDecimal];
        score = [score decimalNumberByAdding:value];
    }
    
    return score;
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
