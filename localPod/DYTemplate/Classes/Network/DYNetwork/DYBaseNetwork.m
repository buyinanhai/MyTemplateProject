//
//  WNBaseNetwork.m
//  项目常用设定
//
//  Created by Hansen on 2018/11/8.
//  Copyright © 2018 ma c. All rights reserved.
//

#import "DYBaseNetwork.h"
#import "DYNetworkConfig.h"
#import "AFNetworking.h"

@implementation DYBaseNetwork

- (instancetype)init {
    
    self = [super init];
    [self setDefaultParam];
    return self;
}
- (void)setDefaultParam {
    self.dy_requestSerializerType = YTKRequestSerializerTypeJSON;
    self.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //只需要初始化一次的在这里设置
        [DYNetworkConfig initializeNetworkConfig];
    });
}

- (void)dy_startRequestWithSuccessful:(void (^)(id _Nullable))successful {
    if (![self isAvailableNetwork]) {
        
//        [SVProgressHUD showInfoWithStatus:@"当前网络不可用！"];
        successful(nil);
        return;
    }
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [self getStatusCode:request.responseJSONObject];
        if (status == 200) {
            id data = [self getResponseJson:request.responseJSONObject];
            DYNetworkError *error = nil;
            @try {
                if ([data isKindOfClass:[NSString class]]) {
                    data = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:0];
                }
            } @catch (NSException *exception) {
                data = [self getResponseJson:request.responseJSONObject];
                error = [DYNetworkError new];
                error.errorCode = -20000;
                error.errorMessage = [NSString stringWithFormat:@"数据解析错误: %@",exception.reason];
            } @finally {
                if (data == nil && error == nil) {
                    data = [self getResponseJson:request.responseJSONObject];
                }
                if (data == nil) {
//                    请求成功 但是返回数据
                    successful(@"1");
                } else {
                    successful(data);
                }
            }
        } else {
            NSString *message = [self getErrorMessage:request.responseJSONObject];
            DYNetworkError *error = [DYNetworkError new];
            error.errorCode = status;
            error.errorMessage = message;
//            [SVProgressHUD showErrorWithStatus:error.errorMessage];
            successful(nil);
        }
        DYLog(@"%@",request);
        DYLog(@"the response string: \n%@",request.responseString);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        DYNetworkError *error = [DYNetworkError errorWithDomain:NSCocoaErrorDomain code:-8888 userInfo:request.error.userInfo];
        error.errorCode = request.responseStatusCode;
        if (request.response == nil) {
            error.errorMessage = @"服务器无响应，请稍后再试！";
        } else {
            error.errorMessage = @"网络请求失败";
        }
//        [SVProgressHUD showErrorWithStatus:error.errorMessage];
        successful(nil);
        DYLog(@"%@",request);
        DYLog(@"%@",error);
    }];
}

- (void)dy_startRequestWithFinished:(void (^)(id _Nullable, DYNetworkError * _Nullable))finished {
    if (![self isAvailableNetwork]) {
//        [SVProgressHUD showInfoWithStatus:@"当前网络不可用！"];
        return;
    }
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [self getStatusCode:request.responseJSONObject];
        if (status == 200 || status == 0) {
            id data = [self getResponseJson:request.responseJSONObject];
            DYNetworkError *error = nil;
            @try {
                if ([data isKindOfClass:[NSString class]]) {
                    data = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:0];
                }
            } @catch (NSException *exception) {
                data = [self getResponseJson:request.responseJSONObject];
                error = [DYNetworkError new];
                error.errorCode = -20000;
                error.errorMessage = [NSString stringWithFormat:@"数据解析错误: %@",exception.reason];
            } @finally {
                if (data == nil && error == nil) {
                    data = [self getResponseJson:request.responseJSONObject];
                }
                finished(data,error);
            }
        } else {
            NSString *message = [self getErrorMessage:request.responseJSONObject];
            DYNetworkError *error = [DYNetworkError errorWithDomain:NSURLErrorDomain code:-999 userInfo:@{@"define": @"自定义的业务错误"}];
            error.errorCode = status;
            error.errorMessage = message;
            finished(nil,error);
        }
        DYLog(@"=======================请求地址和参数==============================");
        DYLog(@"%@",request);
        DYLog(@"=======================请求结果===================================");
        DYLog(@"the response string: \n%@",request.responseString);
        DYLog(@"================================================================");

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        DYNetworkError *error = [DYNetworkError errorWithDomain:NSCocoaErrorDomain code:-8888 userInfo:request.error.userInfo];
        error.errorCode = request.responseStatusCode;
        error.errorMessage = @"网络请求失败";
        if (error.code == -8888) {
            error.errorMessage = @"请求超时，请稍后重试";
        }
       DYLog(@"=======================请求地址和参数==============================");
        DYLog(@"%@",request);
        DYLog(@"=======================请求结果===================================");
        DYLog(@"the error: \n%@ \n response : %@",error, request.responseString);
        DYLog(@"================================================================");

        finished(nil,error);
    }];
}
- (void)dy_startRequestWithSuccessful:(void (^)(id _Nullable, DYNetworkError * _Nullable))successful failing:(void (^)(DYNetworkError * _Nullable))failing {
   
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [self getStatusCode:request.responseJSONObject];
        if (status == 200) {
            id data = [self getResponseJson:request.responseJSONObject];
            DYNetworkError *error = nil;
            @try {
                if ([data isKindOfClass:[NSString class]]) {
                    data = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:0];
                }
            } @catch (NSException *exception) {
                data = [self getResponseJson:request.responseJSONObject];
                error = [DYNetworkError new];
                error.errorCode = -20000;
                error.errorMessage = [NSString stringWithFormat:@"数据解析错误: %@",exception.reason];
            } @finally {
                if (data == nil && error == nil) {
                    data = [self getResponseJson:request.responseJSONObject];
                }
                successful(data,error);
            }
        } else {
            NSString *message = [self getErrorMessage:request.responseJSONObject];
            DYNetworkError *error = [DYNetworkError new];
            error.errorCode = status;
            error.errorMessage = message;
            successful(nil,error);
        }
        DYLog(@"=======================请求地址和参数==============================");
        DYLog(@"%@",request);
        DYLog(@"================================================================");

        DYLog(@"=======================请求结果===================================");
        DYLog(@"the response string: \n%@",request.responseString);
        DYLog(@"================================================================");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        DYNetworkError *error = [DYNetworkError errorWithDomain:NSCocoaErrorDomain code:-8888 userInfo:request.error.userInfo];
        error.errorCode = request.responseStatusCode;
        if (request.response == nil) {
            error.errorMessage = @"服务器无响应，请稍后再试！";
        } else {
            error.errorMessage = @"网络请求失败";
        }
        DYLog(@"=======================请求地址和参数==============================");
        DYLog(@"%@",request);
        DYLog(@"================================================================");
        DYLog(@"=======================请求结果===================================");
        DYLog(@"%@",error);
        DYLog(@"================================================================");
        failing(error);
    }];
}

- (void)dy_startRequestWithCompleted:(void (^)(YTKBaseRequest * _Nullable))Completed {
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        Completed(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        Completed(request);
    }];
}


- (BOOL)isAvailableNetwork {
   
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    return manager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
    
}


- (id)getResponseJson:(NSDictionary *)dict {
    __block id result = nil;
    NSArray *array = @[@"Data",@"data"];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict allKeys] containsObject:obj]) {
            result = dict[obj];
            *stop = YES;
        }
    }];
    
    return result;
}
- (NSInteger)getStatusCode:(NSDictionary *)dict {
    __block NSInteger code = 0;
    NSArray *array = @[@"Status",@"State",@"status",@"statusCode",@"flag"];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict allKeys] containsObject:obj]) {
            code = [dict[obj] integerValue];
            *stop = YES;
        }
    }];
   
    return code;
}
- (NSString *)getErrorMessage:(NSDictionary *)dict {
    __block NSString *message = 0;
    NSArray *array = @[@"Error",@"Message",@"msg",@"message"];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict allKeys] containsObject:obj]) {
            message = [dict objectForKey:obj];
            *stop = YES;
        }
    }];
    if (message.length == 0) {
        message = @"未知错误";
    }
    return message;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    
    if (self.dy_requestHeaderFieldValueDictionary == nil) {
        
//        if (LoginManager.shared.loginToken.length > 0) {
//            return @{@"ticket": LoginManager.shared.loginToken};
//        }
        
    }
    
    return self.dy_requestHeaderFieldValueDictionary;
}

- (NSString *)baseUrl {
    return self.dy_baseURL;
}

- (NSString *)requestUrl {
    return self.dy_requestUrl;
}

- (id)requestArgument {
    return self.dy_requestArgument;
}

- (YTKRequestMethod)requestMethod {
    return self.dy_requestMethod;
}

- (NSInteger)cacheTimeInSeconds {
    return self.dy_cacheTimeInSeconds;
}

- (id)jsonValidator {
    return self.dy_jsonValidator;
}

- (YTKRequestSerializerType)requestSerializerType {
    return self.dy_requestSerializerType;
}
- (YTKResponseSerializerType)responseSerializerType {
    return self.dy_responseSerializerType;
}
- (NSTimeInterval)requestTimeoutInterval {
    if (self.dy_requestTimeout > 0) {
        return self.dy_requestTimeout;
    }
    return 60;
}
- (AFConstructingBlock)constructingBodyBlock {
    return self.dy_constructingBodyBlock;
}
@end
