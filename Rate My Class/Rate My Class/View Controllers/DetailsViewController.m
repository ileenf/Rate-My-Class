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

@end

@implementation DetailsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 170;
    self.classCode.text = self.classObj.code;
    
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

-(NSMutableArray *)getCurrentClassReviews:(NSArray *)allClassReviews {
    NSMutableArray *currClassReviews = [NSMutableArray array];
    for (ClassModel *class in allClassReviews) {
        if ([class.code isEqualToString:self.classCode.text]){
            [currClassReviews addObject:class];
        }
    }
    
    return currClassReviews;
}

-(void)loadReviews {
    PFQuery * query = [PFQuery queryWithClassName:@"Review"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil){
            self.reviews = [self getCurrentClassReviews:objects];
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

    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

@end
