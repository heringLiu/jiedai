//
//  NetWorkingModel.h
//  huaxiajishi
//
//  Created by qm on 16/4/26.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkingModel : NSObject

+(NetWorkingModel *) sharedInstance;

- (void)GET:(NSString *)url parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id obj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id obj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) DELETE:(NSString *)url parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id obj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) PUT:(NSString *)url parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id obj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
