//
//  ClassObject.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/19/21.
//

#import "ClassObject.h"
#import <Parse/Parse.h>
#import "ClassAPIManager.h"

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

+ (void)classesWithQueries:(NSMutableArray *)allClasses handler:(void(^)(NSMutableArray *classes, NSError *error))completion {
    NSMutableSet *newClasses = [NSMutableSet set];

    PFQuery *query = [PFQuery queryWithClassName:@"Class"];
    [query selectKeys:@[@"classCode"]];
    query.limit = 10000;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil) {
            // get class codes from database
            NSMutableSet *classCodesFromParse = [NSMutableSet set];
            for (ClassObject *object in objects) {
                [classCodesFromParse addObject:object.classCode];
            }
                        
            for (NSDictionary *class in allClasses){
                NSString *code = [NSString stringWithFormat:@"%@ %@", class[@"department"], class[@"number"]];
                if (![classCodesFromParse containsObject:code]){
                    ClassObject *classObj = [ClassObject createClass:@"N/A"
                                                   withDifficulty:@"N/A"
                                                         withCode:[NSString stringWithFormat:@"%@ %@", class[@"department"], class[@"number"]]
                                                   withDepartment:class[@"department_name"] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    }];
                    [newClasses addObject:classObj];
                }
            }
            [PFObject saveAllInBackground:(NSArray *)newClasses block:^(BOOL succeeded, NSError * _Nullable error) {
                if (error == nil) {
                    completion(allClasses, nil);
                }
            }];
        }
    }];
}
  
@end
