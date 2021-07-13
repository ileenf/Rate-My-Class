//
//  ReviewModel.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import "ReviewModel.h"
#import <Parse/Parse.h>

@implementation ReviewModel

@dynamic author;
@dynamic comment;
@dynamic rating;
@dynamic difficulty;

+ (nonnull NSString *)parseClassName {
    return @"Review";
}

+ (void) postReview: (NSNumber * _Nullable)rating withDifficulty: (NSNumber * _Nullable)difficulty withComment: (NSString * _Nullable)comment withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    ReviewModel *newReview = [ReviewModel new];
    newReview.author = [PFUser currentUser];
    newReview.comment = comment;
    newReview.rating = rating;
    newReview.difficulty = difficulty;
 
    [newReview saveInBackgroundWithBlock: completion];
}

@end
