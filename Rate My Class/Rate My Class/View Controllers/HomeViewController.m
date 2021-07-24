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
@property (nonatomic, strong) UIRefreshControl *allClassesRefreshControl;
@property (nonatomic, strong) UIRefreshControl *recommendedRefreshControl;
@property (nonatomic, strong) NSMutableDictionary *deptToClasses;
@property (nonatomic, strong) NSArray *departmentsArray;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSArray *userSelectedTags;
@property (nonatomic, strong) NSString *unratedClassesRating;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 70;
    self.deptToClasses = [[NSMutableDictionary alloc] init];
    self.user = [PFUser currentUser];
    self.unratedClassesRating = @"2.5";
    
    [self getUserSelectedTags];
    [self fetchAllClasses];
}

- (void)createDeptToClassesMapping {
    for (ClassObject *class in self.allClasses) {
        NSMutableArray *classesArray = [self.deptToClasses objectForKey:class.department];
        if (classesArray == nil) {
            NSMutableArray *initialClassArray = [NSMutableArray arrayWithObject:class];
            [self.deptToClasses setObject:initialClassArray forKey:class.department];
        } else {
            [classesArray addObject:class];
        }
    }
    self.departmentsArray = self.deptToClasses.allKeys;
}

- (void)getUserSelectedTags {
    self.userSelectedTags = self.user[@"selectedTagsText"];
}

-(void)sendDepartmentsAndClassToProfileView:(ClassObject *)classObj {
    UINavigationController *nav = (UINavigationController*) [[self.tabBarController viewControllers] objectAtIndex:2];
    ProfileViewController *profileVC = (ProfileViewController *)nav.topViewController;
    profileVC.departmentsArray = self.departmentsArray;
}

-(void)sendClassesArrayToSearchView {
    UINavigationController *nav = (UINavigationController*) [[self.tabBarController viewControllers] objectAtIndex:1];
    SearchViewController *searchVC = (SearchViewController *)nav.topViewController;
    searchVC.allClasses = self.allClasses;
}

- (void)fetchAllClasses {
    ClassAPIManager *manager = [ClassAPIManager new];
    [manager fetchCurrentClasses:^(NSArray *classes, NSError *error) {
        if (error == nil) {
            [ClassObject classesWithQueries:classes handler:^(NSMutableArray * _Nonnull classes, NSError * _Nonnull error) {
                if (error == nil) {
                    self.allClasses = classes;
                    self.classes = classes;
                    [self.tableView reloadData];
                    
                    [self createDeptToClassesMapping];
                    [self sendClassesArrayToSearchView];
                }
            }];
        }
        [self.allClassesRefreshControl endRefreshing];
    }];
}

- (NSArray *)getRecommendedClassesFromTags {
    NSMutableArray *classesFromTags = [NSMutableArray array];
    for (NSString *tagText in self.userSelectedTags) {
        NSArray *classesFromDept = [self.deptToClasses objectForKey:tagText];

        NSArray *sortedByRating = [classesFromDept sortedArrayUsingComparator:^NSComparisonResult(ClassObject *class1, ClassObject *class2) {
            NSString *rating1 = (NSString *)class1.overallRating;
            NSString *rating2 = (NSString *)class2.overallRating;
            
            if ([rating1 isEqualToString:@"N/A"]) {
                rating1 = self.unratedClassesRating;
            }
            if ([rating2 isEqualToString:@"N/A"]) {
                rating2 = self.unratedClassesRating;
            }
            
            return [rating2 compare:rating1];
        }];
        
        NSArray *topTenRated = [sortedByRating subarrayWithRange:NSMakeRange(0, 10)];
        [classesFromTags addObjectsFromArray:topTenRated];
    }
    return classesFromTags;
}

- (IBAction)allClassesFilter:(id)sender {
    self.classes = self.allClasses;
    [self.tableView reloadData];
}
- (IBAction)recommendedClassesFilter:(id)sender {
    self.classes = [self getRecommendedClassesFromTags];
    [self.tableView reloadData];
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
        
        [self sendDepartmentsAndClassToProfileView:class];
    }
}

@end
