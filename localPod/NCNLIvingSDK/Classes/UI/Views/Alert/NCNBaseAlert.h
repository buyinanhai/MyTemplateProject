//
//  NCNBaseAlert.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/7.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    NCNBaseAlertFlag_Cancle = 0,
    NCNBaseAlertFlag_Sign,
} NCNBaseAlertFlags;

NS_ASSUME_NONNULL_BEGIN

@interface NCNBaseAlert : UIView

/**
 自雷自己定义点击的含义
 */
@property (nonatomic, copy) void(^completeCallback) (NCNBaseAlertFlags flag, __nullable id unknown, NCNBaseAlert *alert);


- (void)showOnView:(UIView * _Nullable)view;


- (void)setupContentView;

- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
