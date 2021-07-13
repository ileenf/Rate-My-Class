//
//  ReviewCell.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;

@end

NS_ASSUME_NONNULL_END
