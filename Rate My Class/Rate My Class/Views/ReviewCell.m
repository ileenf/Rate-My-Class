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

- (void)setReview:(ReviewModel *)review {
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
}

@end
