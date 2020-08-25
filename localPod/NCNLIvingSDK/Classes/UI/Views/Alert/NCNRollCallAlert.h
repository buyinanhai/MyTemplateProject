//
//  NCNRollCallAlert.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/7.
//

#import "NCNBaseAlert.h"

NS_ASSUME_NONNULL_BEGIN
/**
 被点名弹框
 */
@interface NCNRollCallAlert : NCNBaseAlert

+ (instancetype)rollCallAlertWithTime:(NSInteger)second;
@end

NS_ASSUME_NONNULL_END
