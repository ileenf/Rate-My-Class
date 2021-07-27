//
//  MajorModel.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/26/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface MajorModel : PFObject<PFSubclassing>

@property (nonatomic, strong) NSMutableArray *tagsArray;
@property (nonatomic, strong) NSString *major;

+ (void)createMajor:(NSString * _Nullable)major withTagsArray:(NSMutableArray * _Nullable)tagsArray withCompletion:(PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
