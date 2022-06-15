//
//  NetWorkingModel.m
//  huaxiajishi
//
//  Created by qm on 16/4/26.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "NetWorkingModel.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NetWorkingModel

static NetWorkingModel *sharedNetWorkModalInstance = nil;
static AFHTTPRequestOperationManager *manager = nil;

+ (NetWorkingModel *)sharedInstance
{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedNetWorkModalInstance = [[self alloc] init];
        manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer.timeoutInterval = 15.f;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    
    return sharedNetWorkModalInstance;
}


- (void)PUT:(NSString *)url parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    if ([self getWifiName] == nil) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        SHOWTEXTINWINDOW(@"没有连接WiFi", 1);
        failure(nil, nil);
    }
#endif
    
    
    NSString * encodingString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *mutableRequest =[[AFHTTPRequestSerializer serializer]
                                          requestWithMethod:@"PUT"
                                          URLString:encodingString
                                          parameters:jsonString
                                          error:nil];
    mutableRequest.timeoutInterval = 15.0f;
    if ([self networkIsAvailable]) {
        [mutableRequest setCachePolicy: NSURLRequestReloadIgnoringCacheData];
    } else {
        [mutableRequest setCachePolicy: NSURLRequestReturnCacheDataElseLoad];
    }
    
    NSLog(@"Etag: %@", [self getEtag:mutableRequest]);
    
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 获取版本号
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [mutableRequest setValue:ver forHTTPHeaderField: @"ver"];
    NSLog(@"%@", encodingString);
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([@"error" isEqualToString:[responseObject objectForKey:@"status"]] && [[responseObject objectForKey:@"message"] isEqualToString:@"error_Noauthority"]) {
            SHOWTEXTINWINDOW(@"没有权限", 1);
            return ;
        }
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DISMISS
        if (operation.response.statusCode == 500) {
            SHOWTEXTINWINDOW(@"服务器内部错误 500", 1);
        } else if (operation.response.statusCode == 403) {
            SHOWTEXTINWINDOW(@"禁止访问 403", 1);
        } else if (operation.response.statusCode == 0) {
            if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"请求超时。"]) {
                SHOWTEXTINWINDOW(@"请求超时", 1);
            } else {
                SHOWTEXTINWINDOW(@"未能连接到服务器", 1);
            }
        } else if (operation.response.statusCode == 404) {
            SHOWTEXTINWINDOW(@"无法找到文件 404", 1);
        } else {
            NSString *str = [NSString stringWithFormat:@"网络请求错误 错误码%ld", (long)operation.response.statusCode];
            SHOWTEXTINWINDOW(str, 1);
        }
        NSLog(@"%@", error);
        failure(operation, error);
        
    }];
    
    [requestOperation start];
    
}

- (void)GET:(NSString *)url parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    if ([self getWifiName] == nil) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        SHOWTEXTINWINDOW(@"没有连接WiFi", 1);
        failure(nil, nil);
    }
#endif
    NSString * encodingString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 获取版本号
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    [manager.requestSerializer setValue:ver forHTTPHeaderField:@"ver"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    
    [manager GET:encodingString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([@"error" isEqualToString:[responseObject objectForKey:@"status"]] && [[responseObject objectForKey:@"message"] isEqualToString:@"error_Noauthority"]) {
            SHOWTEXTINWINDOW(@"没有权限", 1);
            return ;
        }
        
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DISMISS
        if (operation.response.statusCode == 500) {
            SHOWTEXTINWINDOW(@"服务器内部错误 500", 1);
        } else if (operation.response.statusCode == 403) {
            SHOWTEXTINWINDOW(@"禁止访问 403", 1);
        } else if (operation.response.statusCode == 0) {
            if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"请求超时。"]) {
                SHOWTEXTINWINDOW(@"请求超时", 1);
            } else {
                SHOWTEXTINWINDOW(@"未能连接到服务器", 1);
            }
        } else if (operation.response.statusCode == 404) {
            SHOWTEXTINWINDOW(@"无法找到文件 404", 1);
        } else {
            NSString *str = [NSString stringWithFormat:@"网络请求错误 错误码%ld", (long)operation.response.statusCode];
            SHOWTEXTINWINDOW(str, 1);
        }
        failure(operation, error);
        NSLog(@"%@", error);
    }];
    
}

- (void)DELETE:(NSString *)url parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    if ([self getWifiName] == nil) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        SHOWTEXTINWINDOW(@"没有连接WiFi", 1);
        failure(nil, nil);
    }
#endif
    NSString * encodingString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] init];
    [mutableRequest setHTTPMethod:@"DELETE"];
    [mutableRequest setURL:[NSURL URLWithString:encodingString]];
    [mutableRequest setHTTPBody:jsonData];
//    NSMutableURLRequest *mutableRequest =[[AFHTTPRequestSerializer serializer]
//                                          requestWithMethod:@"POST"
//                                          URLString:encodingString
//                                          parameters:jsonString
//                                          error:nil];
    mutableRequest.timeoutInterval = 15.0f;
    if ([self networkIsAvailable]) {
        [mutableRequest setCachePolicy: NSURLRequestReloadIgnoringCacheData];
    } else {
        [mutableRequest setCachePolicy: NSURLRequestReturnCacheDataElseLoad];
    }
    
    NSLog(@"Etag: %@", [self getEtag:mutableRequest]);
    
//    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 获取版本号
    NSLog(@"%@", encodingString);
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([@"error" isEqualToString:[responseObject objectForKey:@"status"]] && [[responseObject objectForKey:@"message"] isEqualToString:@"error_Noauthority"]) {
            SHOWTEXTINWINDOW(@"没有权限", 1);
            return ;
        }
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        if (operation.response.statusCode == 500) {
            SHOWTEXTINWINDOW(@"服务器内部错误 500", 1);
        } else if (operation.response.statusCode == 403) {
            SHOWTEXTINWINDOW(@"禁止访问 403", 1);
        } else if (operation.response.statusCode == 0) {
            if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"请求超时。"]) {
                SHOWTEXTINWINDOW(@"请求超时", 1);
            } else {
                SHOWTEXTINWINDOW(@"未能连接到服务器", 1);
            }
        } else if (operation.response.statusCode == 404) {
            SHOWTEXTINWINDOW(@"无法找到文件 404", 1);
        } else {
            NSString *str = [NSString stringWithFormat:@"网络请求错误 错误码%ld", (long)operation.response.statusCode];
            SHOWTEXTINWINDOW(str, 1);
        }
        NSLog(@"%@", error);
    }];
    
    [requestOperation start];
}

- (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    if ([self getWifiName] == nil) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        SHOWTEXTINWINDOW(@"没有连接WiFi", 1);
        failure(nil, nil);
    }
#endif
    NSString * encodingString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *mutableRequest =[[AFHTTPRequestSerializer serializer]
                                          requestWithMethod:@"POST"
                                          URLString:encodingString
                                          parameters:jsonString
                                          error:nil];
    mutableRequest.timeoutInterval = 15.0f;
    if ([self networkIsAvailable]) {
        [mutableRequest setCachePolicy: NSURLRequestReloadIgnoringCacheData];
    } else {
        [mutableRequest setCachePolicy: NSURLRequestReturnCacheDataElseLoad];
    }
    
    NSLog(@"Etag: %@", [self getEtag:mutableRequest]);
    
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 获取版本号
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [mutableRequest setValue:ver forHTTPHeaderField: @"ver"];
    NSLog(@"%@", encodingString);
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([@"error" isEqualToString:[responseObject objectForKey:@"status"]] && [[responseObject objectForKey:@"message"] isEqualToString:@"error_Noauthority"]) {
            SHOWTEXTINWINDOW(@"没有权限", 1);
            return ;
        }
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DISMISS
        NSLog(operation.response.description);
        if (operation.response.statusCode == 500) {
            
            WINDOWSHOWTEXT(@"服务器内部错误 500", 1);
        } else if (operation.response.statusCode == 403) {
            SHOWTEXTINWINDOW(@"禁止访问 403", 1);
        } else if (operation.response.statusCode == 0) {
            if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"请求超时。"]) {
                SHOWTEXTINWINDOW(@"请求超时", 1);
            } else {
                SHOWTEXTINWINDOW(@"未能连接到服务器", 1);
            }
        } else if (operation.response.statusCode == 404) {
            SHOWTEXTINWINDOW(@"无法找到文件 404", 1);
        } else {
            NSString *str = [NSString stringWithFormat:@"网络请求错误 错误码%ld", (long)operation.response.statusCode];
            SHOWTEXTINWINDOW(str, 1);
        }
        failure(operation, error);
    
    }];
    
    [requestOperation start];
}

- (NSString *)getEtag:(NSURLRequest *)request {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"Path: %@", paths);
    NSLog(@"Log: %@", request.URL);
    NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", request.URL]];
    NSLog(@"Filename: %@", filename);
    NSString *etag = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    return etag;
}
- (BOOL)networkIsAvailable {
    return [AFNetworkReachabilityManager sharedManager].isReachable ? YES : NO;
}


- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}
@end
