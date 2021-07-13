//
//  DetailsViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import "DetailsViewController.h"
#import "ReviewModel.h"
#import "ReviewCell.h"
#import "Parse/Parse.h"


@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *classCode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *reviews;

@end

@implementation DetailsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 170;
    self.classCode.text = self.classObj.code;
    
    [self loadReviews];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(void)loadReviews {
    PFQuery * query = [PFQuery queryWithClassName:@"Review"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil){
            self.reviews = objects;
            [self.tableView reloadData];
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    ReviewModel *review = self.reviews[indexPath.row];
    cell.ratingLabel.text = review.rating;
    cell.difficultyLabel.text = review.difficulty;
    
    NSLog(@"%@", review.rating);
    NSLog(@"%@", review.difficulty);
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

@end
