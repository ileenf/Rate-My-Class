//
//  ReviewModel.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import "ReviewModel.h"

@implementation ReviewModel

@dynamic author;
@dynamic comment;
@dynamic rating;
@dynamic difficulty;
@dynamic code;
@dynamic likeCount;
@dynamic usersLiked;

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
    newReview.likeCount = @(0);
    newReview.usersLiked = [[NSMutableArray alloc] init];
 
    [newReview saveInBackgroundWithBlock: completion];
}

@end
