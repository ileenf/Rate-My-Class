//
//  ReviewCell.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import "ReviewCell.h"
#import "ReviewModel.h"
#import "Parse/Parse.h"

@implementation ReviewCell

- (IBAction)didTapLike:(id)sender {
    if ([self.review.usersLiked containsObject:[PFUser currentUser].username]) {
        int value = [self.review.likeCount intValue];
        self.review.likeCount = [NSNumber numberWithInt:value - 1];
        
        [self.likeIcon setSelected: NO];
        [self.review removeObject:[PFUser currentUser].username forKey:@"usersLiked"];
    } else {
        int value = [self.review.likeCount intValue];
        self.review.likeCount = [NSNumber numberWithInt:value + 1];
        
        [self.likeIcon setSelected: YES];
        [self.review addObject:[PFUser currentUser].username forKey:@"usersLiked"];
    }
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.review.likeCount];
    [self.review saveInBackground];
}

- (void)setReview:(ReviewModel *)review withIndexPath:(NSIndexPath *)indexPath {
    _review = review;

    self.ratingLabel.text = review.rating;
    self.difficultyLabel.text = review.difficulty;
    self.commentsLabel.text = review.comment;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", review.likeCount];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([review.usersLiked containsObject:[PFUser currentUser].username]) {
        [self.likeIcon setSelected: YES];
    } else {
        [self.likeIcon setSelected: NO];
    }
    
    [self.contentView.layer setMasksToBounds:YES];
    [self.contentView.layer setCornerRadius:14];
    [self.contentView.layer setBorderWidth:2];
    [self.contentView.layer setShadowOffset:CGSizeMake(-1, -1)];

    UIColor *color = [UIColor colorWithRed:0 green:0.2667 blue:0.8471 alpha:0.6];
    [self.contentView.layer setBorderColor:color.CGColor];
}

@end
