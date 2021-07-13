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

@property (nonatomic, strong) NSMutableArray *classes;
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

-(void)enableRefreshing {
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(fetchClasses) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchClasses {
    ClassAPIManager *manager = [ClassAPIManager new];
    [manager fetchCurrentClasses:^(NSArray *classes, NSError *error) {

        if (error){

        } else {
            self.classes = classes;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        ClassModel *class = [[ClassModel alloc] initWithDictionary:self.classes[indexPath.row]];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.classObj = class;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassCell"];
    ClassModel *class = [[ClassModel alloc] initWithDictionary:self.classes[indexPath.row]];
    cell.className.text = class.code;
            
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classes.count;
}

@end
