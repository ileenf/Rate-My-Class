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

+ (void)classesWithQueries:(NSMutableArray *)allClasses handler:(void(^)(NSMutableArray *classes, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
