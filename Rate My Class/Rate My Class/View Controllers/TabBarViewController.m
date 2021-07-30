//
//  TabBarViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/29/21.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "ProfileViewController.h"
#import "ClassAPIManager.h"
#import "ClassObject.h"

@interface TabBarViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong) NSArray *allClassesArray;
@property (nonatomic, strong) NSMutableDictionary *deptToClasses;
@property (nonatomic, strong) NSArray *departmentsArray;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    self.deptToClasses = [[NSMutableDictionary alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    UINavigationController *navVC = self.selectedViewController;
    UIViewController *viewController = navVC.topViewController;
    if ([viewController isKindOfClass:[HomeViewController class]]) {
        HomeViewController *homeVC = (HomeViewController *)viewController;
        [self fetchAllClasses:homeVC];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UINavigationController *)navController {
    UIViewController *viewController = navController.topViewController;
    
    if ([viewController isKindOfClass:[SearchViewController class]]) {
        SearchViewController *searchVC = (SearchViewController *)viewController;
        searchVC.allClasses = self.allClassesArray;
    } else if ([viewController isKindOfClass:[ProfileViewController class]]) {
        ProfileViewController *profileVC = (ProfileViewController *)viewController;
        profileVC.departmentsArray = self.departmentsArray;
    }
    return YES;
}

- (void)fetchAllClasses:(HomeViewController *)homeVC {
    ClassAPIManager *manager = [ClassAPIManager new];
    [manager fetchCurrentClasses:^(NSArray *classes, NSError *error) {
        if (error == nil) {
            [ClassObject classesWithQueries:classes handler:^(NSMutableArray * _Nonnull classes, NSError * _Nonnull error) {
                if (error == nil) {
                    homeVC.allClasses = classes;
                    homeVC.classes = classes;
                    [homeVC reloadTableData];
                    
                    self.allClassesArray = classes;
                    [self createDeptToClassesMapping];
                    homeVC.deptToClasses = self.deptToClasses;
                }
            }];
        }
    }];
}

- (void)createDeptToClassesMapping {
    for (ClassObject *class in self.allClassesArray) {
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

@end
