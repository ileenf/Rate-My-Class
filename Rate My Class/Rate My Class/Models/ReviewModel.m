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
@dynamic code;

+ (nonnull NSString *)parseClassName {
    return @"Review";
}

+ (void) postReview: (NSString * _Nullable)rating withDifficulty: (NSString * _Nullable)difficulty withCode: (NSString * _Nullable)code withComment: (NSString * _Nullable)comment withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    ReviewModel *newReview = [ReviewModel new];
    newReview.author = [PFUser currentUser];
    newReview.comment = comment;
    newReview.rating = rating;
    newReview.difficulty = difficulty;
    newReview.code = code;
 
    [newReview saveInBackgroundWithBlock: completion];
}

@end
