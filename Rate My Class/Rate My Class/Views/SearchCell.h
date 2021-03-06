//
//  SearchCell.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "ClassObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (strong, nonatomic) ClassObject *currClass;

- (void)setClass:(ClassObject *)currClass withIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
