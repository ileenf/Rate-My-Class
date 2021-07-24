//
//  ProfileViewController.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "ClassObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSArray *departmentsArray;

@end

NS_ASSUME_NONNULL_END
