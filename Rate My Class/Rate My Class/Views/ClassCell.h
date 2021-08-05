//
//  ClassCell.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "ClassObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *overallRating;
@property (strong, nonatomic) ClassObject *currClass;

- (void)setClass:(ClassObject *)currClass withIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
