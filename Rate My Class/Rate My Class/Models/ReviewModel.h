//
//  ReviewModel.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReviewModel : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *difficulty;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic) BOOL liked;

+ (void) postReview: (NSNumber * _Nullable)rating withDifficulty: (NSNumber * _Nullable)difficulty withCode: (NSString * _Nullable)code withComment: (NSString * _Nullable)comment withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
