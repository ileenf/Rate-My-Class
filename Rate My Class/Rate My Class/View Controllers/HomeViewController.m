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
#import "ClassObject.h"

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
        if (error == nil) {
            [ClassObject classesWithQueries:classes handler:^(NSMutableArray * _Nonnull classes, NSError * _Nonnull error) {
                if (error == nil) {
                    self.classes = classes;
                    [self.tableView reloadData];
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
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        ClassObject *class = self.classes[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.classObj = class;
        detailsViewController.fromHome = YES;
    }
}

@end
