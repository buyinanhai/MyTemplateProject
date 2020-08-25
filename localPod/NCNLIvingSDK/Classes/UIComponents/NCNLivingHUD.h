//
//  NCNLivingHUD.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCNLivingHUD : NSObject

+ (instancetype)sharedInstance;

/**
 view == nil  显示在windowl
 */
+ (void)showWithMessage:(NSString *)message onView:(UIView  * _Nullable)view;

@end

NS_ASSUME_NONNULL_END
