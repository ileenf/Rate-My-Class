//
//  HomeViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import "HomeViewController.h"
#import "DetailsViewController.h"
#import "ClassAPIManager.h"
#import "ClassCell.h"
#import "ClassModel.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 70;

    self.classes = [[NSMutableArray alloc] init];
    
    [self enableRefreshing];
    [self fetchClasses];
}

- (void)enableRefreshing {
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(fetchClasses) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchClasses {
    ClassAPIManager *manager = [ClassAPIManager new];
    [manager fetchCurrentClasses:^(NSArray *classes, NSError *error) {

        if (error){
        } else {
            self.classes = [ClassModel classesWithDictionaries:classes];
            
            NSMutableArray *array = [NSMutableArray array];
            for (ClassModel *class in self.classes){
                if (![array containsObject:class.department]) {
                    [array addObject:class.department];
                }

                
            }
            
            NSLog(@"this is array of deps.   %@", array);
            
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)sendOverallRating:(NSString *)rating path:(nonnull NSIndexPath *)indexPath{
    ClassCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    ClassModel *class = self.classes[indexPath.row];
    class.averageRating = rating;
    cell.overallRating.text = rating;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassCell"];
    ClassModel *class = self.classes[indexPath.row];

    cell.class = class;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classes.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        ClassModel *class = self.classes[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.classObj = class;
        detailsViewController.delegate = self;
        detailsViewController.nextPath = indexPath;
    }
}

@end
