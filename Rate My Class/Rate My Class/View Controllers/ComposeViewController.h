//
//  ComposeViewController.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "ClassObject.h"
#import "DetailsViewController.h"
#import "ReviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate
- (void)didSubmitReview:(ReviewModel *)newReview;
@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic, strong) ClassObject *classObj;
@property (nonatomic, strong) NSArray *reviewsFromDetails;

@end

NS_ASSUME_NONNULL_END
