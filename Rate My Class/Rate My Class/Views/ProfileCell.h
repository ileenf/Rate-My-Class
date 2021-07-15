//
//  ProfileCell.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/15/21.
//

#import <UIKit/UIKit.h>
#import "ReviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (strong, nonatomic) ReviewModel *review;

@end

NS_ASSUME_NONNULL_END
