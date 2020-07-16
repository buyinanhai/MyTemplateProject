//
//  HomeNetWork.m
//  ID贷
//
//  Created by 吴祖辉 on 2019/6/21.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "HomeNetWork.h"

@implementation HomeNetWork

+ (instancetype)getObtainAuthentication
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/user/getauth";
    obj.dy_requestArgument = @{};
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)getMyquato
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/apply/getmyquato";
    obj.dy_requestArgument = @{@"model":[NSString getCurrentDeviceModel]};
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)getMyReturn
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/apply/getmyretrun";
    obj.dy_requestArgument = @{};
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)saveMyApplyWithMoney:(NSString *)money andDid:(NSString *)did
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/apply/savemyapply";
    obj.dy_requestArgument = @{@"money":money,@"did":did};
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)getMyApplyWithModel:(NSString *)model andDid:(NSString *)did
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/apply/getmyapply";
    obj.dy_requestArgument = @{@"model":model,@"did":did};
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)saveMyReturn
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/apply/savemyretrun";
    obj.dy_requestArgument = @{};
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)getOrderWithOrderId:(NSString *)orderId
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/apply/getorder";
    obj.dy_requestArgument = @{@"orderid":orderId};
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

@end
