//
//  NCNLivingHUD.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/20.
//

#import "NCNLivingHUD.h"

@interface NCNLivingHUD_View : UIView
@property (nonatomic, strong) UIButton *contentBtn;


- (void)dismiss;
@end

@interface NCNLivingHUD ()


@end


@implementation NCNLivingHUD

+ (instancetype)sharedInstance {
    
    static id manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [NCNLivingHUD new];
    });
    
    return manager;
}


+ (void)showWithMessage:(NSString *)message onView:(UIView *)view {
    
    NCNLivingHUD_View *hud = [NCNLivingHUD_View new];
    UIView *contentView = view;
    if (view == nil) {
        contentView = [UIApplication.sharedApplication keyWindow];
    }
    [hud.contentBtn setTitle:message forState:UIControlStateNormal];
    [contentView addSubview:hud];
    [UIView animateWithDuration:0.2 animations:^{
        
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        hud.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
    } completion:^(BOOL finished) {
        hud.transform = CGAffineTransformIdentity;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud dismiss];
        });
    }];
    
}

@end


@implementation NCNLivingHUD_View



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}


- (void)setupSubview {
    
    
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.contentBtn];
    
    [self.contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(120);
        make.height.offset(45);
    }];
    
    
}
- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (UIButton *)contentBtn {
    
    if (!_contentBtn) {
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _contentBtn.titleLabel.numberOfLines = 0;
        [_contentBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _contentBtn.backgroundColor = UIColor.blackColor;
    }
    return _contentBtn;
    
}
@end
