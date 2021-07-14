//
//  DetailsViewController.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewControllerDelegate
- (void)sendOverallRating:(NSString *)rating path:(nonnull NSIndexPath *)indexPath;
@end

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *nextPath;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) ClassModel *classObj;

@end

NS_ASSUME_NONNULL_END
