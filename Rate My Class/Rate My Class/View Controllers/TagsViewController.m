//
//  TagsViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/19/21.
//

#import "TagsViewController.h"
#import "TTGTagCollectionView.h"
#import "TTGTagCollectionView/TTGTextTagCollectionView.h"
#import "Parse/Parse.h"
#import "ClassObject.h"

@interface TagsViewController ()

@property (nonatomic, strong) TTGTextTagCollectionView *tagCollectionView;
@property (nonatomic, strong) NSMutableArray *departments;

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchDepartments];
}

- (void)fetchDepartments {
    PFQuery *query = [PFQuery queryWithClassName:@"Class"];
    query.limit = 10000;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil){
            self.departments = [self getDepartments:objects];

            [self createTagsView];
        } 
    }];
}

- (NSMutableArray *)getDepartments:(NSArray *)classes {
    NSMutableArray *depts = [[NSMutableArray alloc] init];
    for (ClassObject *class in classes) {
        if (![depts containsObject:class.department]) {
            [depts addObject:class.department];
        }
    }
    return depts;
}

- (void)createTagsView {
    self.tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(20, 20, 400, 1200)];
    [self.view addSubview:self.tagCollectionView];
    
    NSArray *tagsArray = [self createInterestTagsArray:self.departments];

    [self.tagCollectionView addTags:tagsArray];
}

- (NSArray *)createInterestTagsArray:(NSMutableArray *)departmentsArray {
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init];
    for (NSString *department in self.departments){
        TTGTextTag *textTag = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:department] style:[TTGTextTagStyle new]];
        [tagsArray addObject:textTag];
    }
    return tagsArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
