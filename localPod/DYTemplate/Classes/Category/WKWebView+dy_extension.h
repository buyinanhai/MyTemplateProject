//
//  WKWebView+DYWKWebView.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/9/3.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (dy_extension)

/**
 为解决直接在vc中添加handler引起的内存泄漏问题 记得在原view中销毁时删除添加的message
 */
- (void)dy_addScriptMessageHandler:(id)handler name:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
