//
//  SearchViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/14/21.
//

#import "SearchViewController.h"
#import "HomeViewController.h"
#import "ClassModel.h"
#import "SearchCell.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *classesToShow;
@property (nonatomic, strong) NSArray *allClasses;

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

- (void)viewWillAppear:(BOOL)animated {
    UINavigationController *nav = (UINavigationController*) [[self.tabBarController viewControllers] objectAtIndex:0];
    HomeViewController *homeVC = (HomeViewController *)nav.topViewController;
    self.allClasses = homeVC.classes;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(ClassModel *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject.code containsString:searchText];
        }];

        self.classesToShow = [self.allClasses filteredArrayUsingPredicate:predicate];
    } else {
        self.classesToShow = nil;
        [self.view endEditing:YES];
    }
    
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    ClassModel *class = self.classesToShow[indexPath.row];
    
    cell.classNameLabel.text = class.code;
    cell.ratingLabel.text = class.averageRating;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classesToShow.count;
}


@end
