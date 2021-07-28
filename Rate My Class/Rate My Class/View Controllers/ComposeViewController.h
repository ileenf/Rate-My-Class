//
//  ComposeViewController.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "ClassObject.h"
#import "DetailsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) ClassObject *classObj;
@property (nonatomic, strong) NSArray *reviewsFromDetails;
@property (nonatomic, strong) DetailsViewController *detailsVC;

@end

NS_ASSUME_NONNULL_END
