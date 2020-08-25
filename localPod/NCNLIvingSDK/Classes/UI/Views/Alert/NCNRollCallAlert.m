//
//  NCNRollCallAlert.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/7.
//

#import "NCNRollCallAlert.h"
#import "NSTimer+dy_extension.h"

@interface NCNRollCallAlert ()
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) UIButton *signBtn;

@property (nonatomic, weak) UILabel *contentLabel;


@end
@implementation NCNRollCallAlert {
    
    NSUInteger _seconds;
    
}


+ (instancetype)rollCallAlertWithTime:(NSInteger)second {
    
    NCNRollCallAlert *alert = [NCNRollCallAlert new];
    alert->_seconds = second;
    [alert setContentAttributeText:[NSString stringWithFormat:@"老师要求你在 %ld 秒内响应点名", second]];

    return alert;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setupContentView {
    
    _seconds = 60;
    UIView *contentView = UIView.new;
    contentView.backgroundColor = UIColor.whiteColor;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(270);
        make.height.offset(165);
    }];
    [contentView sl_setCornerRadius:10];
    self.contentView = contentView;
    
    UILabel *title = UILabel.new;
    title.font = [UIFont boldSystemFontOfSize:16];
    title.text = @"点名";
    title.textColor = UIColor.blackColor;
    
    [contentView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(20);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
   
    self.contentLabel = label;

    [self setContentAttributeText:[NSString stringWithFormat:@"老师要求你在 %ld 秒内响应点名", _seconds]];
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn setTitle:@"答到" forState:UIControlStateNormal];
    [signBtn sl_setCornerRadius:16.5];
    signBtn.backgroundColor = [UIColor colorWithHexString:@"#FC9400"];
    [contentView addSubview:signBtn];
    
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-26.5);
        make.width.offset(98.5);
        make.height.offset(33);
    }];
    
    [signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.signBtn = signBtn;
    self.timer = [NSTimer dy_scheduledWeakTimerWithTimeInterval:1.0 target:self selector:@selector(timerFire) userInfo:@{} repeats:true];

}


- (void)timerFire {
    
    _seconds--;
    if (_seconds == 0) {
        [self.timer invalidate];
        [self.signBtn setTitle:@"答到失败" forState:UIControlStateNormal];
        self.signBtn.enabled = false;
        
    }
    [self setContentAttributeText:[NSString stringWithFormat:@"老师要求你在 %ld 秒内响应点名", _seconds]];
    
}


- (void)setContentAttributeText:(NSString *)text {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];

    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:139/255.0 blue:13/255.0 alpha:1.0]} range:NSMakeRange(7, text.length - 14)];
    self.contentLabel.attributedText = string;
}


- (void)signBtnClick {
    
    if (self.completeCallback) {
        self.completeCallback(NCNBaseAlertFlag_Sign, nil, self);
    }
    
}



@end
