//
//  NCNLiveLansacpeMaskView.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 横屏装载 其他view的全屏容器
 */
@interface NCNLiveLansacpeMaskView : UIView

- (void)showWithTitle:(NSString *)title subView:(UIView *)view;


- (NSArray<UIView *> *)allShowViews;
@end

NS_ASSUME_NONNULL_END
