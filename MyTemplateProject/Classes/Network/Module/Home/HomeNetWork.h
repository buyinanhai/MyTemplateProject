//
//  HomeNetWork.h
//  ID贷
//
//  Created by 吴祖辉 on 2019/6/21.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "DYBaseNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeNetWork : DYBaseNetwork

//获取用户各项认证
+ (instancetype)getObtainAuthentication;

//获取我的额度
+ (instancetype)getMyquato;

//获取我的借款
+ (instancetype)getMyReturn;

//立即申请贷款
+ (instancetype)saveMyApplyWithMoney:(NSString *)money andDid:(NSString *)did;

//我申请的额度
+ (instancetype)getMyApplyWithModel:(NSString *)model andDid:(NSString *)did;

//还款
+ (instancetype)saveMyReturn;

//获取订单号状态
+ (instancetype)getOrderWithOrderId:(NSString *)orderId;
@end

NS_ASSUME_NONNULL_END
