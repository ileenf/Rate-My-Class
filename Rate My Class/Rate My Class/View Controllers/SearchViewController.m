//
//  SearchViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/14/21.
//

#import "SearchViewController.h"
#import "HomeViewController.h"

@interface SearchViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSArray *classesToShow;
@property (nonatomic, strong) NSArray *allClasses;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    UINavigationController *nav = (UINavigationController*) [[self.tabBarController viewControllers] objectAtIndex:0];
    HomeViewController *homeVC = (HomeViewController *)nav.topViewController;
    self.allClasses = homeVC.classes;
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (searchText.length != 0) {
//        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
//            return [evaluatedObject[@"id"] containsString:searchText];
//        }];
//
//        self.classesToShow = [self.movies filteredArrayUsingPredicate:predicate];
//    } else {
//        self.classesToShow = nil;
//        [self.view endEditing:YES];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
