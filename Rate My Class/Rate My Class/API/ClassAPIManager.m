//
//  ClassAPIManager.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import "ClassAPIManager.h"
#import "ClassModel.h"
#import "ClassObject.h"


@interface ClassAPIManager()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ClassAPIManager

- (id)init {
    self = [super init];

    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    return self;
}

- (void)fetchCurrentClasses:(void(^)(NSArray *classes, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://api.peterportal.org/rest/v0/courses/all"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSArray *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}

@end
