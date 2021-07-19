//
//  ClassModel.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *averageRating;
@property (nonatomic, strong) NSString *department;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)classesWithDictionaries:(NSMutableArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
