//
//  NCNBaseAlert.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/7.
//

#import "NCNBaseAlert.h"


@interface NCNBaseAlert ()



@end
@implementation NCNBaseAlert


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = rgba(0, 0, 0, 0.3);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = self.backgroundColor;
        [btn addTarget:self action:@selector(screenBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        [self setupContentView];
    }
    return self;
}

- (void)screenBtnClick {
    
    if (self.completeCallback) {
        self.completeCallback(NCNBaseAlertFlag_Cancle, nil, self);
    }
    [self removeFromSuperview];
}

- (void)showOnView:(UIView *)view {
    
    UIView *contentView = view;
    if (contentView == nil) {
        contentView = UIApplication.sharedApplication.keyWindow;
    }
    
    [contentView addSubview:self];
    [contentView bringSubviewToFront:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
}

- (void)dismiss {
    
    [self removeFromSuperview];
    
}

- (void)dealloc {
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
