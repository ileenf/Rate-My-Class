//
//  HomeViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "DetailsViewController.h"
#import "ClassAPIManager.h"
#import "ClassCell.h"
#import "ClassObject.h"
#import "TTGTagCollectionView.h"
#import "TTGTagCollectionView/TTGTextTagCollectionView.h"
#import "ProfileViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableDictionary *deptToClasses;
@property (nonatomic, strong) NSArray *departmentsArray;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSArray *userSelectedTags;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 70;

    self.classes = [[NSMutableArray alloc] init];
    self.deptToClasses = [[NSMutableDictionary alloc] init];
    
    self.user = [PFUser currentUser];
    
    [self getUserSelectedTags];
    [self enableRefreshing];
    [self fetchClasses];
}

- (void)enableRefreshing {
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(fetchClasses) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)createDeptToClassesMapping {
    for (ClassObject *class in self.classes) {
        NSMutableArray *classesArray = [self.deptToClasses objectForKey:class.department];
        if (classesArray == nil) {
            NSMutableArray *initialClassArray = [NSMutableArray arrayWithObject:class];
            [self.deptToClasses setObject:initialClassArray forKey:class.department];
        } else {
            [classesArray addObject:class];
        }
    }
    self.departmentsArray = self.deptToClasses.allKeys;
    [self sendDepartmentsArrayToTagsView];
}

- (void)getUserSelectedTags {
    self.userSelectedTags = self.user[@"selectedTagsText"];
}

-(void)sendDepartmentsArrayToTagsView {
    UINavigationController *nav = (UINavigationController*) [[self.tabBarController viewControllers] objectAtIndex:2];
    ProfileViewController *profileVC = (ProfileViewController *)nav.topViewController;
    profileVC.departmentsArray = self.departmentsArray;
}

-(void)sendClassesArrayToSearchView {
    UINavigationController *nav = (UINavigationController*) [[self.tabBarController viewControllers] objectAtIndex:1];
    SearchViewController *searchVC = (SearchViewController *)nav.topViewController;
    searchVC.allClasses = self.classes;
}

- (void)fetchClasses {
    ClassAPIManager *manager = [ClassAPIManager new];
    [manager fetchCurrentClasses:^(NSArray *classes, NSError *error) {
        if (error == nil) {
            [ClassObject classesWithQueries:classes handler:^(NSMutableArray * _Nonnull classes, NSError * _Nonnull error) {
                if (error == nil) {
                    self.classes = classes;
                    [self.tableView reloadData];
                    
                    [self createDeptToClassesMapping];
                    [self sendClassesArrayToSearchView];
                }
            }];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassCell"];
    ClassObject *class = self.classes[indexPath.row];

    cell.class = class;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classes.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DetailSegueFromHome"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        ClassObject *class = self.classes[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.classObj = class;
        detailsViewController.sendingClassObject = YES;
    }
}

@end
