//
//  ReviewCell.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import "ReviewCell.h"
#import "ReviewModel.h"

@implementation ReviewCell

- (IBAction)didTapLike:(id)sender {
    if (self.review.liked == NO){
        self.review.liked = YES;
                
        int value = [self.review.likeCount intValue];
        self.review.likeCount = [NSNumber numberWithInt:value + 1];
    } else {
        self.review.liked = NO;
        
        int value = [self.review.likeCount intValue];
        self.review.likeCount = [NSNumber numberWithInt:value - 1];
    }
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.review.likeCount];
    
    [self.likeIcon setSelected: self.review.liked];
    [self.review saveInBackground];
}

@end
