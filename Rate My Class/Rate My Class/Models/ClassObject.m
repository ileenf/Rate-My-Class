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

+ (ClassObject *) createClass: (NSString * _Nullable)overallRating withDifficulty: (NSString * _Nullable)difficulty withCode: (NSString * _Nullable)classCode withDepartment: (NSString * _Nullable)department withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    ClassObject *newClass = [ClassObject new];
    newClass.classCode = classCode;
    newClass.department = department;
    newClass.overallRating = overallRating;
    
    return newClass;
}

+ (NSMutableArray *)classesWithQueries:(NSMutableArray *)dictionaries {
    NSMutableArray *classes = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries){
        ClassObject *class = [ClassObject createClass:@"N/A" withDifficulty:@"N/A" withCode:[NSString stringWithFormat:@"%@ %@", dictionary[@"department"], dictionary[@"number"]] withDepartment:dictionary[@"department_name"] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        
        [classes addObject:class];
    }
    
    [PFObject saveAllInBackground:classes block:^(BOOL succeeded, NSError * _Nullable error) {
    }];

    return classes;
}

@end
