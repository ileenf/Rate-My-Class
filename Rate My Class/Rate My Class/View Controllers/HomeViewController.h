//
//  HomeViewController.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (nonatomic, strong) NSArray *allClasses;
@property (nonatomic, strong) NSArray *recommendedClasses;
@property (nonatomic, strong) NSArray *classes;
@property (nonatomic, strong) NSDictionary *deptToClasses;

- (void)reloadTableData;

@end

NS_ASSUME_NONNULL_END
