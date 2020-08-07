//
//  MainNetwork.m
//  HX_Car_CLL
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "TestNetwork.h"

@implementation TestNetwork

+ (instancetype)calculateCarCost:(double)total type:(int)type rate:(float)rate year:(int)year {
    
    TestNetwork *obj = [TestNetwork new];
    obj.dy_baseURL = @"https://www.xjzhuan.com";
    obj.dy_requestUrl = @"/calcul/calcul";
    obj.dy_requestArgument = @{
                                @"total" : @(total),
                                @"type" : @(type),
                                @"rate" : @(rate),
                                @"year" : @(year)
                                };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
   
    return obj;
    
}
@end
