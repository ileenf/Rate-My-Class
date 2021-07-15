//
//  ClassCell.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *overallRating;
@property (strong, nonatomic) ClassModel *currClass;

- (void)setClass:(ClassModel *)currClass;

@end

NS_ASSUME_NONNULL_END
