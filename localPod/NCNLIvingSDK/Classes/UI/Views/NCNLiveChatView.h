//
//  NCNLiveChatView.h
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/2.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NCNSpeakView.h"
#import "NCNQuestionAskView.h"
#import "NCNMemberView.h"
#import "NCNAnnouncementView.h"
#import "NCNSettingView.h"

NS_ASSUME_NONNULL_BEGIN
@class NCNSpeakView;
@class NCNLiveChatView;
@class NCQAElemMSG;
@protocol NCNLiveChatViewDelegate <NSObject>

- (void)chatView:(NCNLiveChatView *)view ratateMovieViewToOrientation:(UIInterfaceOrientation)prientation;

- (void)onHandUpChatView:(NCNLiveChatView *)view;
- (void)onDrawClearChatView:(NCNLiveChatView *)view;
- (void)onStartDrawChatView:(NCNLiveChatView *)view;
- (void)chatView:(NCNLiveChatView *)view onCameraIsOpen:(BOOL)isOpen;
- (void)chatView:(NCNLiveChatView *)view onMicphoneIsOpen:(BOOL)isOpen;

/**
 目的就是主页面的按钮挡住了表情键盘
 */
- (void)chatView:(NCNLiveChatView *)view onFaceKeyBoardIsShow:(BOOL)isShow;

@end

@interface NCNLiveChatView : UIView
@property (nonatomic, weak) UIViewController *belongVC;

@property (weak,nonatomic) NCNSpeakView *speakView;
@property (weak,nonatomic) NCNQuestionAskView *askView;
@property (weak,nonatomic) NCNMemberView *memberView;
@property (weak,nonatomic) NCNAnnouncementView *announceView;
@property (weak,nonatomic) NCNSettingView *settingView;

@property (nonatomic, weak) id<NCNLiveChatViewDelegate> delegate;

+ (instancetype)liveChatInfoViewWithFrame:(CGRect)frame;


- (NCNSpeakView *)getChatView;

- (void)addQAData:(NSArray<NCQAElemMSG *> *)datas;

/**
 添加回 显示到横屏上的view
 */
- (void)addLostView:(UIView *)view;

- (void)restarationChatView;

@end

NS_ASSUME_NONNULL_END
