//
//  ClassAPIManager.h
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassAPIManager : NSObject

- (void)fetchCurrentClasses:(void(^)(NSArray *classes, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
