//
//  ProfileViewController.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END