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

static NSString *unratedClassesRating = @"2.5";

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableDictionary *deptToClasses;
@property (nonatomic, strong) NSArray *departmentsArray;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSArray *topMajorTagsByOccurence;
@property BOOL allClassesSelected;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 70;
    self.deptToClasses = [[NSMutableDictionary alloc] init];
    self.user = [PFUser currentUser];
    self.allClassesSelected = YES;
    
    [self enableRefreshing];
    [self fetchAllClasses];
    [self fetchMajorRelatedTagsForCurrMajor];
}

- (void)enableRefreshing {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshCurrClasses) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)refreshCurrClasses {
    if (self.allClassesSelected == NO) {
        self.classes = [self getRecommendedClassesFromTags];
    }
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
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

-(void)sendDepartmentsToProfileView {
    UINavigationController *nav = (UINavigationController*) [[self.tabBarController viewControllers] objectAtIndex:2];
    ProfileViewController *profileVC = (ProfileViewController *)nav.topViewController;
    profileVC.departmentsArray = self.departmentsArray;
}

-(void)sendClassesArrayToSearchView {
    UINavigationController *nav = (UINavigationController*) [[self.tabBarController viewControllers] objectAtIndex:1];
    SearchViewController *searchVC = (SearchViewController *)nav.topViewController;
    searchVC.allClasses = self.allClasses;
}

-(void)fetchMajorRelatedTagsForCurrMajor {
    PFQuery *query = [PFUser query];
    [query includeKey:@"major"];
    [query whereKey:@"major" equalTo:self.user[@"major"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *sameMajorSelectedTags = [self getselectedTagsOfSameMajor:objects];
        NSMutableDictionary *selectedTagsToOccurences = [self createTagsToOccurencesMapping:sameMajorSelectedTags];
        NSLog(@"mapping : %@", selectedTagsToOccurences);
        [self getMajorRelatedTopTags:selectedTagsToOccurences];
        NSLog(@"the sorted : %@", self.topMajorTagsByOccurence);
    }];
}

-(NSMutableArray *)getselectedTagsOfSameMajor:(NSArray *)userObjects {
    NSMutableArray *selectedTags = [NSMutableArray array];
    for (PFUser *user in userObjects) {
        [selectedTags addObjectsFromArray:user[@"selectedTagsText"]];
    }
    return selectedTags;
}

-(NSMutableDictionary *)createTagsToOccurencesMapping:(NSMutableArray *)majorSelectedTags {
    NSMutableDictionary *selectedTagsToOccurences = [NSMutableDictionary dictionary];
    for (NSString *tagText in majorSelectedTags) {
        if ([selectedTagsToOccurences objectForKey:tagText]) {
            NSDecimalNumber *count = [selectedTagsToOccurences objectForKey:tagText];
            count = [count decimalNumberByAdding:[NSDecimalNumber one]];
            [selectedTagsToOccurences setObject:count forKey:tagText];
            
        } else {
            [selectedTagsToOccurences setObject:[NSDecimalNumber one] forKey:tagText];
        }
    }
    return selectedTagsToOccurences;
}

-(void)getMajorRelatedTopTags:(NSMutableDictionary *)selectedTagsToOccurences {
    NSArray *sortedTags = [selectedTagsToOccurences keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull tag1, id  _Nonnull tag2) {
        return [tag2 compare:tag1];
    }];
    NSInteger sortedTagsCount = sortedTags.count;
    if (sortedTagsCount < 5) {
        self.topMajorTagsByOccurence = [sortedTags subarrayWithRange:NSMakeRange(0, sortedTagsCount)];
    } else {
        self.topMajorTagsByOccurence = [sortedTags subarrayWithRange:NSMakeRange(0, 5)];
    }
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
                    [self sendDepartmentsToProfileView];
                }
            }];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (NSArray *)getRecommendedClassesFromTags {
    NSMutableArray *classesFromTags = [NSMutableArray array];
    for (NSString *tagText in self.user[@"selectedTagsText"]) {
        NSArray *classesFromDept = [self.deptToClasses objectForKey:tagText];

        NSArray *sortedByRating = [classesFromDept sortedArrayUsingComparator:^NSComparisonResult(ClassObject *class1, ClassObject *class2) {
            NSString *rating1 = class1.overallRating;
            NSString *rating2 = class2.overallRating;
            
            if ([rating1 isEqualToString:@"N/A"]) {
                rating1 = unratedClassesRating;
            }
            if ([rating2 isEqualToString:@"N/A"]) {
                rating2 = unratedClassesRating;
            }
            
            return [rating2 compare:rating1];
        }];
        NSInteger sortedTagsCount = sortedByRating.count;
        NSArray *topTenRated;
        if (sortedTagsCount < 10) {
            topTenRated = [sortedByRating subarrayWithRange:NSMakeRange(0, sortedTagsCount)];
        } else {
            topTenRated = [sortedByRating subarrayWithRange:NSMakeRange(0, 10)];
        }
        [classesFromTags addObjectsFromArray:topTenRated];
    }
    
    return classesFromTags;
}

- (IBAction)allClassesFilter:(id)sender {
    self.classes = self.allClasses;
    [self.tableView reloadData];
    self.allClassesSelected = YES;
}
- (IBAction)recommendedClassesFilter:(id)sender {
    self.classes = [self getRecommendedClassesFromTags];
    [self.tableView reloadData];
    self.allClassesSelected = NO;
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
    }
}

@end
