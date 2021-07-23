//
//  ProfileViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/14/21.
//

#import "ProfileViewController.h"
#import "DetailsViewController.h"
#import "TagsViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"
#import "ProfileCell.h"
#import "ReviewModel.h"
#import "ClassObject.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *profileReviewsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.rowHeight = 80;
    
    self.user = [PFUser currentUser];
    self.usernameLabel.text = [NSString stringWithFormat:@"%@", self.user.username];
    
    [self enableRefreshing];
    [self loadProfileReviews];
}

- (void)enableRefreshing {
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(loadProfileReviews) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)loadProfileReviews {
    PFQuery * query = [PFQuery queryWithClassName:@"Review"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query includeKey:@"classObject"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil){
            self.profileReviewsArray = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"error");
        }
        [self.refreshControl endRefreshing];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath: indexPath];
    ReviewModel *review = self.profileReviewsArray[indexPath.row];
    NSLog(@"%@", review);
    cell.review = review;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.profileReviewsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ProfileDetailsSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (IBAction)handleLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginviewcontroller;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ProfileDetailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        ReviewModel *review = self.profileReviewsArray[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.classObj = review.classObject;
    } else if ([[segue identifier] isEqualToString:@"TagsViewSegue"]) {
        TagsViewController *tagsViewController = [segue destinationViewController];
        tagsViewController.departmentsArray = self.departmentsArray;
    }
}

@end
