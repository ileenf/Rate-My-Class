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


@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *classCode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *reviews;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSDecimalNumber *ratingTotal;
@property (nonatomic, strong) NSDecimalNumber *numberOfReviews;
@property (nonatomic, strong) NSDecimalNumber *averageRating;
@property (nonatomic, strong) NSDecimalNumber *difficultyTotal;
@property (nonatomic, strong) NSDecimalNumber *averageDifficulty;
@property (weak, nonatomic) IBOutlet UILabel *overallRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallDifficultyLabel;

@end

@implementation DetailsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 170;
    self.classCode.text = self.classObj.code;
    
    NSLog(@"setting default values");
    
    self.ratingTotal = [[NSDecimalNumber alloc] initWithDouble:0.0];
    self.numberOfReviews = [[NSDecimalNumber alloc] initWithDouble:0.0];
    self.averageRating = [[NSDecimalNumber alloc] initWithDouble:0.0];;
    self.difficultyTotal = [[NSDecimalNumber alloc] initWithDouble:0.0];
    self.averageDifficulty = [[NSDecimalNumber alloc] initWithDouble:0.0];

    [self enableRefreshing];
    [self loadReviews];
}

-(void)enableRefreshing {
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(loadReviews) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ComposeSegue"]) {
        ComposeViewController *composeViewController = [segue destinationViewController];
        composeViewController.classCode = self.classCode.text;
    }
}

-(void)loadReviews {
    PFQuery * query = [PFQuery queryWithClassName:@"Review"];
    [query whereKey:@"code" equalTo:self.classCode.text];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil){
            self.reviews = objects;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    ReviewModel *review = self.reviews[indexPath.row];
    cell.ratingLabel.text = review.rating;
    cell.difficultyLabel.text = review.difficulty;
    cell.commentsLabel.text = review.comment;
    
    self.numberOfReviews = [self.numberOfReviews decimalNumberByAdding: [[NSDecimalNumber alloc] initWithFloat:1]];
    
    [self calculateAverageRating: review.rating];
    [self calculateAverageDifficulty:review.difficulty];
    
    self.averageRating = [self roundDecimal:self.averageRating];
    self.averageDifficulty = [self roundDecimal:self.averageDifficulty];
    
    self.overallRatingLabel.text = [NSString stringWithFormat:@"%@", self.averageRating];
    self.overallDifficultyLabel.text = [NSString stringWithFormat:@"%@", self.averageDifficulty];

    NSString *string = [NSString stringWithFormat:@"%@", self.averageRating];
    [self.delegate sendOverallRating: string path:self.nextPath];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

-(void)calculateAverageRating: (NSString *)reviewRating {
    NSDecimalNumber *rating = [NSDecimalNumber decimalNumberWithString:reviewRating];
    self.ratingTotal = [self.ratingTotal decimalNumberByAdding: rating];
    self.averageRating = [self.ratingTotal decimalNumberByDividingBy:(NSDecimalNumber *) self.numberOfReviews];
}

-(void)calculateAverageDifficulty: (NSString *)difficultyRating {
    NSDecimalNumber *rating = [NSDecimalNumber decimalNumberWithString:difficultyRating];
    self.difficultyTotal = [self.difficultyTotal decimalNumberByAdding: rating];
    self.averageDifficulty = [self.difficultyTotal decimalNumberByDividingBy:(NSDecimalNumber *) self.numberOfReviews];
}

-(NSDecimalNumber *)roundDecimal: (NSDecimalNumber *)amount {
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                              scale:2
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    
    NSDecimalNumber *roundedNumber = [amount decimalNumberByRoundingAccordingToBehavior:behavior];
    return roundedNumber;
    
}

@end
