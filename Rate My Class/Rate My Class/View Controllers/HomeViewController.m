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

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 70;
    
    self.classes = [[NSMutableArray alloc] init];
    
    [self fetchClasses];
}

- (void)fetchClasses {
    ClassAPIManager *manager = [ClassAPIManager new];
    NSLog(@"in here first");
    [manager fetchCurrentClasses:^(NSArray *classes, NSError *error) {
        NSLog(@"in here");

        if (error){

        } else {
            self.classes = classes;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        ClassModel *class = self.classes[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.classObj = class;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassCell"];
    ClassModel *class = [[ClassModel alloc] initWithDictionary:self.classes[indexPath.row]];
    cell.className.text = class.code;
        
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classes.count;
}

@end
