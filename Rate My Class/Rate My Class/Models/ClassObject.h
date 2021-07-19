//
//  ClassObject.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/19/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassObject : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *classCode;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *overallRating;

+ (void) createClass: (NSString * _Nullable)overallRating withDifficulty: (NSString * _Nullable)difficulty withCode: (NSString * _Nullable)classCode withDepartment: (NSString * _Nullable)department withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
