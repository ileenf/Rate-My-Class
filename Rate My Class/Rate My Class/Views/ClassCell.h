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
@property (weak, nonatomic) IBOutlet UILabel *overallRating;
@property (weak, nonatomic) IBOutlet UILabel *className;

- (void)setClass:(ClassModel *)class;

@end

NS_ASSUME_NONNULL_END
