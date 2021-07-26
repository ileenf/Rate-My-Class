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
@dynamic overallDifficulty;

+ (nonnull NSString *)parseClassName {
    return @"Class";
}

+ (ClassObject *) createClass: (NSString * _Nullable)overallRating withDifficulty: (NSString * _Nullable)overallDifficulty withCode: (NSString * _Nullable)classCode withDepartment: (NSString * _Nullable)department withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    ClassObject *newClass = [ClassObject new];
    newClass.classCode = classCode;
    newClass.department = department;
    newClass.overallRating = overallRating;
    newClass.overallDifficulty = overallDifficulty;
        
    return newClass;
}

+ (void)classesWithQueries:(NSMutableArray *)ClassesFromAPI handler:(void(^)(NSMutableArray *classes, NSError *error))completion {
    NSMutableArray *newClassesNotInParse = [NSMutableArray array];

    PFQuery *query = [PFQuery queryWithClassName:@"Class"];
    query.limit = 10000;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable classesFromDatabase, NSError * _Nullable error) {
        if (error == nil) {
            NSMutableSet *classCodesFromParse = [NSMutableSet set];
            for (ClassObject *classObj in classesFromDatabase) {
                [classCodesFromParse addObject:classObj.classCode];
            }
                        
            for (NSDictionary *classDictionary in ClassesFromAPI){
                NSString *classCode = [NSString stringWithFormat:@"%@ %@", classDictionary[@"department"], classDictionary[@"number"]];
                if (![classCodesFromParse containsObject:classCode]){
                    ClassObject *classObj = [ClassObject createClass:@"N/A"
                                                      withDifficulty:@"N/A"
                                                            withCode:classCode
                                                      withDepartment:classDictionary[@"department_name"]
                                                      withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                        }];
                    [newClassesNotInParse addObject:classObj];
                }
            }
            [PFObject saveAllInBackground:(NSArray *)newClassesNotInParse block:^(BOOL succeeded, NSError * _Nullable error) {
                if (error == nil) {
                    NSMutableArray *allClasses = [classesFromDatabase arrayByAddingObjectsFromArray:newClassesNotInParse];
                    completion(allClasses, nil);
                }
            }];
        } else {
            NSLog(@"error fetching classes%@", error);
        }
    }];
}
  
@end
