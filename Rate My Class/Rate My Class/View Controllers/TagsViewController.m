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

@interface TagsViewController () <TTGTextTagCollectionViewDelegate>

@property (nonatomic, strong) TTGTextTagCollectionView *tagCollectionView;
@property (nonatomic, strong) NSMutableArray *selectedTagsText;
@property (nonatomic, strong) NSMutableArray *departments;
@property (nonatomic, strong) PFUser *user;

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"thise are dpet: %@", self.departmentsArray);
    
    self.user = [PFUser currentUser];
    self.selectedTagsText = [[NSMutableArray alloc] initWithArray:self.user[@"selectedTagsText"] copyItems:YES];
    
    [self fetchDepartments];
}

- (void)setTagsFromParseAsSelected {
    NSArray *tagsTextArray = self.user[@"selectedTagsText"];
    NSArray *allTagObjects = [self.tagCollectionView allTags];
    
    int idx = 0;
    for (TTGTextTag *tagObj in allTagObjects) {
        TTGTextTagStringContent *content = tagObj.content;
        NSString *tagText = content.text;
        
        if ([tagsTextArray containsObject:(NSString *)tagText]) {
            [self.tagCollectionView updateTagAtIndex:idx selected:YES];
        }
        idx += 1;
    }
}

- (void)fetchDepartments {
    PFQuery *query = [PFQuery queryWithClassName:@"Class"];
    query.limit = 10000;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil){
            self.departments = [self getDepartments:objects];

            [self createTagsView];
            self.tagCollectionView.delegate = self;
            [self setTagsFromParseAsSelected];
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
    self.tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(20, 20, 400, 1000)];
    self.tagCollectionView.enableTagSelection = YES;
    self.tagCollectionView.manualCalculateHeight = YES;
    
    [self.view addSubview:self.tagCollectionView];
    
    NSArray *tagsArray = [self createInterestTagsArray:self.departments];
    [self.tagCollectionView addTags:tagsArray];
}

- (NSArray *)createInterestTagsArray:(NSMutableArray *)departmentsArray {
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init];
    for (NSString *department in self.departments){
        TTGTextTag *textTag = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:department] style:[TTGTextTagStyle new]];
        textTag.style.extraSpace = CGSizeMake(20.5, 20.5);
        //light blue - default
        textTag.style.backgroundColor = [UIColor colorWithRed:0 green:0.5294 blue:0.8196 alpha:1];
        //dark blue - selected
        textTag.selectedStyle.backgroundColor = [UIColor colorWithRed:0 green:0.3412 blue:0.7098 alpha:1];
        
        [tagsArray addObject:textTag];
    }
    return tagsArray;
}

- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView canTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    return YES;
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    TTGTextTagStringContent *content = tag.content;
    NSString *tagText = content.text;

    if ([self.selectedTagsText containsObject:tagText]) {
        [self.selectedTagsText removeObject:tagText];
    } else {
        [self.selectedTagsText addObject:tagText];
    }
}

- (IBAction)handleSave:(id)sender {
    self.user[@"selectedTagsText"] = self.selectedTagsText;
    [self.user saveInBackground];
}

@end
