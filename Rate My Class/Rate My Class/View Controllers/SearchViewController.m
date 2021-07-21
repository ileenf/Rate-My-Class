//
//  SearchViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/14/21.
//

#import "SearchViewController.h"
#import "HomeViewController.h"
#import "DetailsViewController.h"
#import "SearchCell.h"
#import "ClassObject.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *classesToShow;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 70;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(ClassObject *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject.classCode containsString:searchText];
        }];

        self.classesToShow = [self.allClasses filteredArrayUsingPredicate:predicate];
    } else {
        self.classesToShow = nil;
        [self.view endEditing:YES];
    }
    
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    ClassObject *class = self.classesToShow[indexPath.row];
    
    cell.class = class;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classesToShow.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DetailSegueFromSearch"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        ClassObject *class = self.classesToShow[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.classObj = class;
        detailsViewController.sendingClassObject = YES;
    }
}

@end
