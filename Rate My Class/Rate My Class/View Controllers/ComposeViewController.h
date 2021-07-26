//
//  ComposeViewController.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "ClassObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) ClassObject *classObj;
@property (nonatomic, strong) NSArray *reviewsFromDetails;

@end

NS_ASSUME_NONNULL_END
