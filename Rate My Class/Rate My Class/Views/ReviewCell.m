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
    self.tempUsersLiked = self.review.usersLiked;
    
    if ([self.review.usersLiked containsObject:[PFUser currentUser].username]) {
        if (self.review.liked == NO){
            self.review.liked = YES;
                    
            int value = [self.review.likeCount intValue];
            self.review.likeCount = [NSNumber numberWithInt:value + 1];
        } else {
            self.review.liked = NO;
            
            int value = [self.review.likeCount intValue];
            self.review.likeCount = [NSNumber numberWithInt:value - 1];
        }
        [self.likeIcon setSelected: self.review.liked];
        self.review.usersLiked = self.tempUsersLiked;
    } else {
        int value = [self.review.likeCount intValue];
        self.review.likeCount = [NSNumber numberWithInt:value + 1];
        [self.likeIcon setSelected: YES];
        [self.tempUsersLiked addObject:[PFUser currentUser].username];
        
        self.review.usersLiked = self.tempUsersLiked;
        self.review.liked = YES;
    }
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.review.likeCount];
    [self.review saveInBackground];
}

@end
