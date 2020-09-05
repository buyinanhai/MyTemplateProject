//
//  WKWebView+DYWKWebView.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/9/3.
//

#import "WKWebView+dy_extension.h"

@interface _DYScriptMessageHandler : NSObject<WKScriptMessageHandler>
@property (nonatomic, weak) id target;;
@end

@implementation WKWebView (dy_extension)


- (void)dy_addScriptMessageHandler:(id)handler name:(NSString *)name {
    
    WKUserContentController *cc = self.configuration.userContentController;
    if (cc == nil) {
        cc = [WKUserContentController new];
    }
    _DYScriptMessageHandler *weakHandler = [_DYScriptMessageHandler new];
    weakHandler.target = handler;
    [cc addScriptMessageHandler:weakHandler name:name];
    
    
}

@end


@implementation _DYScriptMessageHandler


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.target respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.target userContentController:userContentController didReceiveScriptMessage:message];
    }
}
- (void)dealloc {
    
    DYLog(@"_DYScriptMessageHandler 888");
}
@end
