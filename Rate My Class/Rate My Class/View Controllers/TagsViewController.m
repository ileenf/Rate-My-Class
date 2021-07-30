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
@property (nonatomic, strong) PFUser *user;

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.user = [PFUser currentUser];
    self.selectedTagsText = [[NSMutableArray alloc] initWithArray:self.user[@"selectedTagsText"] copyItems:YES];
    
    [self createTagsView];
    self.tagCollectionView.delegate = self;
    [self setTagsFromParseAsSelected];
}

- (void)setTagsFromParseAsSelected {
    NSArray *tagsTextArray = self.user[@"selectedTagsText"];
    NSArray *allTagObjects = [self.tagCollectionView allTags];
    
    int idx = 0;
    for (TTGTextTag *tagObj in allTagObjects) {
        TTGTextTagStringContent *content = (TTGTextTagStringContent *)tagObj.content;
        NSString *tagText = content.text;
        
        if ([tagsTextArray containsObject:(NSString *)tagText]) {
            [self.tagCollectionView updateTagAtIndex:idx selected:YES];
        }
        idx += 1;
    }
}

- (void)createTagsView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(5, 5, screenWidth, screenHeight)];
    self.tagCollectionView.enableTagSelection = YES;
    self.tagCollectionView.manualCalculateHeight = YES;
    
    [self.view addSubview:self.tagCollectionView];
    
    NSArray *tagsArray = [self createInterestTagsArray:self.departmentsArray];
    [self.tagCollectionView addTags:tagsArray];
}

- (NSArray *)createInterestTagsArray:(NSArray *)departmentsArray {
    NSMutableArray *tagsArray = [[NSMutableArray alloc] init];
    for (NSString *department in departmentsArray){
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
    TTGTextTagStringContent *content = (TTGTextTagStringContent *)tag.content;
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
    
    UIAlertController *saveSuccessfulAlert = [UIAlertController alertControllerWithTitle:@"Saved"
                                                                   message:@"Successfully saved interests"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [saveSuccessfulAlert addAction:OKAction];
    
    [self presentViewController:saveSuccessfulAlert animated:YES completion:^{
    }];
}

@end
