//
//  ClassObject.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/19/21.
//

#import "ClassObject.h"
#import <Parse/Parse.h>

@implementation ClassObject

@dynamic classCode;
@dynamic department;
@dynamic overallRating;

+ (nonnull NSString *)parseClassName {
    return @"Class";
}



@end
