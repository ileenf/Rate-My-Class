//
//  ProfileCell.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/15/21.
//

#import "ProfileCell.h"
#import "ReviewModel.h"

@implementation ProfileCell

- (void)setReview:(ReviewModel *)review {
    _review = review;
    
    self.classNameLabel.text = review.code;
    self.ratingLabel.text = review.rating;
    self.difficultyLabel.text = review.difficulty;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
