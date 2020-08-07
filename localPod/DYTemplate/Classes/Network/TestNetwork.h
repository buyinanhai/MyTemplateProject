//
//  MainNetwork.h
//  HX_Car_CLL
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "DYBaseNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestNetwork : DYBaseNetwork


/**
 计算车贷
 
 @param type 1,全款 2，贷款
 @param rate 首付比率，全额，1，其它是 0.3，0.4等等
 @param year 还款年限
 @return NSURLSessionDataTask
 */
+ (instancetype)calculateCarCost:(double)total type:(int)type rate:(float)rate year:(int)year;

@end

NS_ASSUME_NONNULL_END
