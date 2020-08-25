//
//  NCNLiveChatView.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/2.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNLiveChatView.h"
#import "NCNCategoryStripView.h"
#import "UIView+Extension.h"
#import "Masonry.h"

@interface NCNLiveChatView()<NCNCategoryStripViewDelegate>
@property (weak,nonatomic) NCNCategoryStripView *subjView;
@property (weak,nonatomic) UIView *contentView;




@property (nonatomic, weak) UIView *currentSelectView;

@end
@implementation NCNLiveChatView


+ (instancetype)liveChatInfoViewWithFrame:(CGRect)frame {
    return [[self alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubview];
        self.backgroundColor = UIColor.redColor;
    }
    return self;
}

- (void)setupSubview {
    // 头部标签
    NCNCategoryStripView *subjV = [[NCNCategoryStripView alloc]init];
    [self addSubview:subjV];
    subjV.frame = CGRectMake(0, 0, kScreen_Width - 15, 40);
    subjV.backgroundColor = [UIColor whiteColor];
    subjV.sliderH = 2.0;
    subjV.needEvenly = NO;
    subjV.textGap = 3;
    subjV.minBtnW = 60;
    subjV.textColorNormal = UIColor.blackColor;
    subjV.textFont = [UIFont boldSystemFontOfSize:SLMainFontSize+1];
    subjV.textFontSelected = FontScaleC_B(SLMainFontSize+2);
    subjV.actionDelegate = self;
    subjV.categoryNames = @[@"发言",@"问答",@"成员",@"公告",@"设置"];
    self.subjView = subjV;
    //
    UIView *contentView = [[UIView alloc]init];
    [self addSubview:contentView];
    CGFloat contentViewY =  CGRectGetMaxY(subjV.frame);
//    contentView.backgroundColor = UIColor.blueColor;
    contentView.frame = CGRectMake(0,contentViewY, self.width, self.height - contentViewY - kBottom_SafeHeight);
    contentView.clipsToBounds = true;
    self.contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(contentViewY);
        make.left.right.bottom.offset(0);
    }];
   
    [self addSubContentView];
}

- (void)addSubContentView {
    NCNSpeakView *speakView = [[NCNSpeakView alloc]init];
    [self.contentView addSubview:speakView];
       self.speakView = speakView;
       speakView.tag = 1000;
       
       NCNQuestionAskView *questionAskView = [[NCNQuestionAskView alloc]init];
    [self.contentView addSubview:questionAskView];
       self.askView = questionAskView;
       questionAskView.tag = 1001;
       self.askView = questionAskView;
       
       NCNMemberView *memberView = [[NCNMemberView alloc]init];
    [self.contentView addSubview:memberView];
       self.memberView = memberView;
       memberView.tag = 1002;
       
       NCNAnnouncementView *announceView = [[NCNAnnouncementView alloc]init];
    [self.contentView addSubview:announceView];
       self.announceView = announceView;
       announceView.tag = 1003;
       
       NCNSettingView *settingView = [NCNSettingView settingView];
    [self.contentView addSubview:settingView];
       self.settingView = settingView;
       settingView.tag = 1004;       
       self.currentSelectView = self.speakView;
       kWeakSelf(self);
       self.speakView.faceKeyboardIsShowCallback = ^(BOOL isShow) {
         
           if ([weakself.delegate respondsToSelector:@selector(chatView:onFaceKeyBoardIsShow:)]) {
               [weakself.delegate chatView:weakself onFaceKeyBoardIsShow:isShow];
           }
       };
}
- (void)setBelongVC:(UIViewController *)belongVC {
    
    _belongVC = belongVC;
    self.speakView.belongVC = belongVC;
    
}
- (void)handUpBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;

    [self.delegate onHandUpChatView:self];
    
    
}

- (void)rotateBtnClick:(UIButton *)sender {
        
    if ([self.delegate respondsToSelector:@selector(chatView:ratateMovieViewToOrientation:)]) {
        [self.delegate chatView:self ratateMovieViewToOrientation: UIInterfaceOrientationLandscapeRight];
    }
    
}

- (NCNSpeakView *)getChatView {
   return [self speakView];
}

-(void)categoryStripView:(NCNCategoryStripView *)ctgV selectedButton:(NSUInteger)btnIdx {
    NSLog(@"%s",__func__);
//    [self.contentSrollview setContentOffset:CGPointMake(btnIdx*self.width, 0) animated:YES];
//    if (btnIdx == 2) {
//        [self.contentSrollview.getMemberView willApear];
//    }
    
    if (btnIdx == self.currentSelectView.tag - 1000) {
        return;
    }
    self.userInteractionEnabled = false;
    UIView *view = [self.contentView viewWithTag:btnIdx + 1000];
    
    
    view.frame = CGRectMake(kScreen_Width, 0, view.width, view.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        view.frame = CGRectMake(0, 0, view.width, view.height);
        
    } completion:^(BOOL finished) {
        self.currentSelectView.frame = CGRectMake(kScreen_Width, 0, self.contentView.width, self.contentView.height);
        self.currentSelectView = view;
        self.userInteractionEnabled = true;
    }];
    
    [self.contentView bringSubviewToFront:view];
    if (view == self.memberView) {
        [self.memberView willApear];
    } else if (view == self.announceView) {
        [self.announceView willAppear];
    }
    
}

- (void)restarationChatView {
    
    [self.speakView removeFromSuperview];
    [self.contentView addSubview:self.speakView];
    if (self.currentSelectView == self.speakView) {
        self.speakView.frame = self.contentView.bounds;
        
    } else {
        self.speakView.frame = CGRectMake(kScreen_Width, 0, self.contentView.width, self.contentView.height);
    }
    
    
}

- (void)addLostView:(UIView *)view {
    
    [self.contentView addSubview:view];
    
    if (self.currentSelectView == view) {
        view.frame = self.contentView.bounds;
        
    } else {
        view.frame = CGRectMake(kScreen_Width, 0, self.contentView.width, self.contentView.height);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    
    for (UIView *view in self.contentView.subviews) {
        
        if (self.currentSelectView == view) {
            view.frame = self.contentView.bounds;
            
        } else {
            view.frame = CGRectMake(kScreen_Width, 0, self.contentView.width, self.contentView.height);
        }
        
    }
    
}
@end

