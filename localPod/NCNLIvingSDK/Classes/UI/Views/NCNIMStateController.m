//
//  NCNIMStateController.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/6/24.
//

#import "NCNIMStateController.h"
#import "NCIMManager.h"


@interface NCNIMStateView : UIView
@property (nonatomic, strong) NCNIMStateController *contrroller;
@property (nonatomic, strong) UIButton *btn;


@end


@interface NCNIMStateController () <TIMUserStatusListener>
@property (nonatomic, weak) NCNIMStateView *stateView;


@end
@implementation NCNIMStateController


+ (UIView *)configStateView {
    
    NCNIMStateController *ctrl = [NCNIMStateController new];
    NCNIMStateView *stateView = [NCNIMStateView new];
    ctrl.stateView = stateView;
    stateView.contrroller = ctrl;
        
    [[NSNotificationCenter defaultCenter] addObserver:ctrl selector:@selector(IMStatusChanged:) name:TUIKitNotification_TIMConnListener object:nil];
    [ctrl updateNetStatusWithStatus:NCIMManager.sharedInstance.netStatus];
    TIMManager.sharedInstance.getUserConfig.userStatusListener = self;
    return stateView;
}


- (void)IMStatusChanged:(NSNotification *)info {
    
    TUINetStatus status = [info.object intValue];
    [self updateNetStatusWithStatus:status];
    
    
}
- (void)updateNetStatusWithStatus:(TUINetStatus)status; {
    
    NSArray *array = @[@"连接成功",@"正在连接...",@"连接失败",@"已断开连接"];
    
    if (status < array.count) {
        [self.stateView.btn setTitle:array[status] forState:UIControlStateNormal];
    }
    if (status == TNet_Status_Succ) {
        self.stateView.hidden = true;
    } else {
        self.stateView.hidden = false;
    }
}

#pragma mark TIMUserStatusListener

- (void)onForceOffline {
    
    [self.stateView.btn setTitle:@"当前用户已在另外一台设备上登录!" forState:UIControlStateNormal];
}

- (void)onUserSigExpired {
    [self.stateView.btn setTitle:@"当前无法连接，请退出重新登录！" forState:UIControlStateNormal];

}
- (void)onReConnFailed:(int)code err:(NSString *)err {
    
    [self.stateView.btn setTitle:@"重连失败！" forState:UIControlStateNormal];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


@implementation NCNIMStateView


- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.redColor;
    
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}
- (void)btnClick {
    
   
    
}
- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(kScreen_Width, 25);
}


- (UIButton *)btn {
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.titleLabel.font = [UIFont systemFontOfCeilfScaleSize:12];
        [_btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _btn;
}
@end
