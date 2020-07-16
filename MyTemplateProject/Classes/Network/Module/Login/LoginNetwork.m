//
//  LoginNetwork.m
//  ID贷
//
//  Created by apple on 2019/6/19.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "LoginNetwork.h"

@implementation LoginNetwork

+ (instancetype)loginWithMobile:(NSString *)mobile time:(NSString *)timeStamp md5:(NSString *)md5 app:(NSString *)appName model:(NSString *)phoneType version:(NSString *)version imei:(NSString *)uuid {
    
    LoginNetwork *obj = [LoginNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/user/facebooklogin";
    obj.dy_requestArgument = @{
                                @"mobile" : mobile,
                                @"times" : timeStamp,
                                @"md5" : md5,
                                @"app" : appName,
                                @"model" : phoneType,
                                @"version" : version,
                                @"imei" : uuid,
                                };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

@end
