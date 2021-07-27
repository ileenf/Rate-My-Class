//
//  MajorModel.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/26/21.
//

#import "MajorModel.h"

@implementation MajorModel

@dynamic tagsArray;
@dynamic major;

+ (nonnull NSString *)parseClassName {
    return @"Major";
}

+ (void)createMajor:(NSString * _Nullable)major withTagsArray:(NSMutableArray * _Nullable)tagsArray withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    MajorModel *newMajor = [MajorModel new];
    newMajor.major = major;
    newMajor.tagsArray = tagsArray;
 
    [newMajor saveInBackgroundWithBlock: completion];
}


@end
