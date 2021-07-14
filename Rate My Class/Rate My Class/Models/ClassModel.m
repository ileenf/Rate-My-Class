//
//  ClassModel.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import "ClassModel.h"

@implementation ClassModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    NSString *department = [NSString stringWithFormat:@"%@ ", dictionary[@"department"]];
    self.code = [department stringByAppendingString:dictionary[@"number"]];
    self.averageRating = @"N/A";
    
    return self;
}

+ (NSMutableArray *)classesWithDictionaries:(NSMutableArray *)dictionaries{
    NSMutableArray *classes = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries){
        ClassModel *class = [[ClassModel alloc]initWithDictionary:dictionary];

        [classes addObject:class];
    }
    
    return classes;
}

@end
