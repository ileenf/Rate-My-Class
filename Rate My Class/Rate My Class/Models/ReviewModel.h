//
//  ReviewModel.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import <Parse/Parse.h>
#import "ClassObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReviewModel : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *difficulty;
@property (nonatomic, strong) ClassObject *classObject;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSMutableArray *usersLiked;

+ (void) postReview: (NSString * _Nullable)rating withDifficulty: (NSString * _Nullable)difficulty withClassObj: (ClassObject * _Nullable)classObj withComment: (NSString * _Nullable)comment withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
