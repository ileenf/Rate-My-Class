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
    if (self.review.usersLiked == nil){
        self.tempUsersLiked = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"%@", self.review.usersLiked);
    if ([self.review.usersLiked containsObject:[PFUser currentUser].username]) {
        int value = [self.review.likeCount intValue];
        self.review.likeCount = [NSNumber numberWithInt:value - 1];
        
        [self.likeIcon setSelected: NO];
        [self.review.usersLiked removeObject:[PFUser currentUser].username];
    } else {
        int value = [self.review.likeCount intValue];
        self.review.likeCount = [NSNumber numberWithInt:value + 1];
        
        [self.likeIcon setSelected: YES];
        [self.review.usersLiked addObject:[PFUser currentUser].username];
    }
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.review.likeCount];
    [self.review saveInBackground];
}

@end
