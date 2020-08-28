//
//  NCNTestView.m
//  LFLiveKit
//
//  Created by 汪宁 on 2020/5/6.
//

#import "NCNTestView.h"
#import "DYButton.h"
#import "NSTimer+dy_extension.h"
#import "NCAnswerElemMSG.h"
@interface NCNTestView () <UIScrollViewDelegate>
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIView *middleView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UIButton *confirmBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NCAnswerElemMSG *elemMsg;


@property (nonatomic, weak) UILabel *explainLabel;


@end

@implementation NCNTestView {
    
    NSInteger _seconds;
    
}

+ (instancetype)testWithElem:(NCAnswerElemMSG *)msg {
    
    NSDictionary *classDict = @{@"0":@"NCNTestChooseView",@"1":@"NCNTestJudgeView"};
    
    Class cls = NSClassFromString(classDict[msg.questionType]);
    
    NCNTestView *view = [cls new];
    view.elemMsg = msg;
    [view setupSubview];
    view.explainLabel.text = msg.questionExplain;
    view->_seconds = msg.questionTime.intValue;
    view.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",view->_seconds / 60, view->_seconds % 60];
    view.explainLabel.hidden = msg.questionExplain.length > 0 ? false : true;

    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setupSubview {
    _seconds = 0;
    self.backgroundColor = rgba(0, 0, 0, 0.3);
    
    UIView *contentView = UIView.new;
    contentView.backgroundColor = UIColor.clearColor;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(293);
        make.height.offset(300);
    }];
    self.contentView = contentView;
    contentView.clipsToBounds = true;
    [self setMiddleView];
    [self setUpView];
    [self setBottomView];
    self.timer = [NSTimer dy_scheduledWeakTimerWithTimeInterval:1.0 target:self selector:@selector(timerFire) userInfo:@{} repeats:true];
}

- (void)setUpView {
    
    UIView *upView = UIView.new;
    upView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:upView];
    self.headerView = upView;
    
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(60);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage living_imageWithNamed:@"test-up-background@3x"]];
    [upView addSubview:imgView];
    
    UIImageView *clockView = [[UIImageView alloc] initWithImage:[UIImage living_imageWithNamed:@"test-clock@3x"]];
    [upView addSubview:clockView];
    
    UILabel *timeLabel = UILabel.new;
    timeLabel.font = [UIFont fontWithName:@"PingFang SC" size: 17];
    timeLabel.textColor = UIColor.blackColor;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [upView addSubview:timeLabel];
    timeLabel.text = @"00:00";
    self.timeLabel = timeLabel;
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
        make.width.offset(146);
        make.height.offset(60);
    }];
    
    [clockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(5);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(clockView.mas_bottom).offset(5);
    }];
    
}

- (void)setMiddleView {
    
    UIView *middleView = UIView.new;
    middleView.backgroundColor = UIColor.whiteColor;
    [middleView sl_setCornerRadius:10];
    [self.contentView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(60);
    }];
    self.middleView = middleView;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [closeBtn setImage:[UIImage living_imageWithNamed:@"test-close@3x"] forState:UIControlStateNormal];
    [middleView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(30);
        make.right.offset(-6);
        make.top.offset(6);
    }];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    self.scrollView = UIScrollView.new;
    self.scrollView.scrollEnabled = true;
    self.scrollView.showsHorizontalScrollIndicator = false;
    [self.contentView addSubview:self.scrollView];
    self.scrollView.delegate = self;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(middleView.mas_centerY);
        make.center.offset(0);
        make.height.offset(50);
        make.width.offset(self.contentView.width);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithRed:239/255.0 green:241/255.0 blue:253/255.0 alpha:1.0];
    [label sl_setCornerRadius:10];
    label.text = @"请仔细审题，加油~！";
    label.font = [UIFont fontWithName:@"PingFang SC" size: 13];
    label.textColor = [UIColor colorWithRed:152/255.0 green:158/255.0 blue:180/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [middleView addSubview:label];
    self.explainLabel = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(5);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(44);
    }];
    
    DYButton *confirmBtn = [DYButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.text = @"提交答案";
    confirmBtn.textColor = UIColor.whiteColor;
    [confirmBtn dy_setBackgroundColor:[UIColor colorWithHexString:@"#D2D5DF"] forState:UIControlStateNormal];
    [confirmBtn dy_setBackgroundColor:[UIColor colorWithHexString:@"#FC9400"] forState:UIControlStateSelected];
    [confirmBtn setCornerRadius:16.5];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [middleView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-22);
        make.width.offset(160);
        make.height.offset(33);
        make.centerX.offset(0);
    }];
    confirmBtn.enabled = false;
    
    self.confirmBtn = confirmBtn;
    
    [self setupTestContent];
    
    
}
- (void)canSubmit:(BOOL)isCan {
    
    self.confirmBtn.enabled = isCan;
    self.confirmBtn.selected = isCan;
    if (isCan == false) {
        [self.timer invalidate];
        self.timer = nil;
        _seconds = 0;
        self.timeLabel.text = @"00:00";
    }
   
}
- (void)testEnded {
    [self.timer invalidate];
    [self canSubmit:false];
}

- (void)setupTestContent {
    
    NSAssert(1, @"在子类实现该方法");
    
}

- (void)setBottomView {
    
    
}

- (void)showOnView:(UIView *)view {
    if (view == nil) {
        view = UIApplication.sharedApplication.keyWindow;
    }
    
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [view bringSubviewToFront:self];
    
}

- (void)closeBtnClick {
    [self.timer invalidate];
    self.timer = nil;
    [self removeFromSuperview];
    
}
- (void)dismiss {
    
    [self closeBtnClick];
    
}

- (void)timerFire {
    
    _seconds--;
    if (_seconds == 0) {
        [self.timer invalidate];
        [self canSubmit:false];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",_seconds / 60, _seconds % 60];
    
}

- (UIScrollView *)testContentView {
    
    return self.scrollView;
    
}

- (void)dealloc {
    
    NSLog(@"关闭了答题");
    
}


- (BOOL)timeIsExhausted {
    
    return _seconds > 0 ? false : true;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)recmaskView/ Drawing code
}
*/

@end
