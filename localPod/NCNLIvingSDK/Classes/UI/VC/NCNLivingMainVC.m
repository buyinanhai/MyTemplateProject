//
//  NCNVideoRoomController.m
//  XYClassRoom
//
//  Created by IOSrsn on 2020/3/25.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNLivingMainVC.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import "NCNLiveTeacherInfoView.h"
#import "NCNLiveChatView.h"
#import "GenerateTestUserSig.h"
#import "NCNSpeakView.h"
#import "NCNBlankView.h"
#import "NCLivePullView.h"
#import "NCLivePushView.h"
#import "NCNBlankPPTListView.h"
#import "NCNTestChooseView.h"
#import "NCNTestJudgeView.h"
#import "NCNTestResultView.h"
#import "NCNRollCallAlert.h"
#import "NCNNetwork.h"
#import "NCCustomMessageData.h"
#import "NCCustomeElemMSG.h"
#import <objc/runtime.h>
#import "TUIInputController.h"
#import "NCNLiveLansacpeMaskView.h"
#import "NSTimer+dy_extension.h"
#import "NCNCustomMessageUtil.h"
#import "NCCustomMessageData.h"
#import "NCCustomeElemMSG.h"
#import "NCControlElemMSG.h"
#import "NCNPublishVC.h"
#import "NCNQ&ACellData.h"
#import "NCQAElemMSG.h"
#import "NCIMManager.h"
#import "NSDate+Formatter.h"
#import "NCNMessageCellModel.h"
#import "NCNTestView.h"
#import "NCNTestResultView.h"
#import "NCNIMStateController.h"


@interface NCNLivingMainVC ()<NCNLiveTeacherInfoDelegate,NCNLiveChatViewDelegate, NCNBlankViewDelegate, NCNBlankPPTListViewDelegate,TInputControllerDelegate>
@property (weak,nonatomic) NCNLiveTeacherInfoView *infoView;
@property (weak,nonatomic) NCNLiveChatView *chatView;
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UILabel  *blankLabel;

@property (nonatomic, strong) TIMConversation *groupConversation;
@property (nonatomic, strong) TIMConversation *groupCodeConversation;

@property (nonatomic, strong) NCNBlankView *blankView;

@property (nonatomic, strong) NCLivePullView *teacherLiveView;
@property (nonatomic, strong) NCLivePullView *studentPullView;
@property (nonatomic, strong) NCLivePushView *studentPushView;

@property (nonatomic, weak) NCLiveView  *currentBigView;

@property (nonatomic, strong) NCNBlankPPTListView *blankListView;

@property (nonatomic, assign) BOOL isLandscape;


@property (nonatomic, strong) UIView *rightBottomBtnsView;

@property (nonatomic, strong) UIStackView *landscapeBtnsCiew;

@property (nonatomic, strong) TUIInputController *inputVC;


@property (nonatomic, strong) NCNLiveLansacpeMaskView *landscapeMaskView;

@property (nonatomic, strong) NSTimer *handsupTimer;

@property (nonatomic, strong) NCNLivingRoomModel *liveModel;

@property (nonatomic, weak) NCNTestView *testView;

@end


@implementation NCNLivingMainVC {
    
    NSInteger _handsupCount;
}



- (instancetype)init {
    
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self setupOrientationConfig];

    return self;
}

+ (instancetype)livingMainVCWithRoomModel:(NCNLivingRoomModel *)model {
    
    NCNLivingMainVC *vc = [[NCNLivingMainVC alloc] init];
    vc.liveModel = model;
    [NCNLivingSDK.shareInstance setLiveRoomId:model.liveRoomId];
    [NCNLivingSDK.shareInstance setGroupId:[NSString stringWithFormat:@"CHAT_%@",model.groupChatId]];
    [NCNLivingSDK.shareInstance setTeacherId:model.teacherId];
    [NCNLivingSDK.shareInstance setStudentId:model.studentId];
    [NCNLivingSDK.shareInstance setGroupCodeId:[NSString stringWithFormat:@"CODE_%@",model.groupCodeId]];
    [NCIMManager.sharedInstance setAccountID:model.studentId];
    [NCIMManager.sharedInstance setPassword:model.studentSignIdentifier];
   
    

    return vc;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setUI];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    [self addNotification];
    [self loadData];
    [NCIMManager.sharedInstance connectLiveRoom];
    [NCIMManager.sharedInstance startLoginForIM];
    if ([UIDevice.currentDevice orientation] == UIDeviceOrientationLandscapeRight) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isLandscape = true;
            [self orientationChange:YES];
        });

    }
    
}


- (void)setUI {
    
    CGFloat blankWidth = kScreen_Width - 15;
    
    CGRect r = CGRectMake(7.5, 20 + kTop_SafeHeight, blankWidth, blankWidth / kDrawAspectRatio);
    self.blankView = [[NCNBlankView alloc] init];
    self.blankView.state = NCLivingViewStateBig;
    [self.view addSubview:self.blankView];
    self.blankView.frame = r;
    self.blankView.delegate = self;
    self.currentBigView = self.blankView;
    [self.blankView living_addShadowWithCornerRadius:8];
   

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setImage:[NSBundle living_loadImageWithName:@"closeBtn-another@3x"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(r.origin.y + 5);
        make.size.offset(25);
    }];
    self.closeBtn = closeBtn;
    CGFloat infoHeight = 71;
    CGRect infoRect = CGRectMake(0, CGRectGetMaxY(self.blankView.frame) + 3, self.view.width, infoHeight);
    NCNLiveTeacherInfoView *infoView = [[NCNLiveTeacherInfoView alloc] initWithFrame:infoRect];
    infoView.delegate = self;
    [self.view addSubview:infoView];
    self.infoView = infoView;
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(infoHeight);
        make.top.offset(CGRectGetMaxY(r));
    }];
    [infoView updateWithModel:self.liveModel];
    infoView.hidden = false;
    [self.view addSubview:self.blankListView];

    self.blankListView.frame = CGRectMake(0, self.infoView.y, kScreen_Width, infoHeight);
    self.blankListView.hidden = true;
    self.blankListView.delegate = self;



    CGFloat chatY = CGRectGetMaxY(infoRect);
    CGRect chatRect = CGRectMake(7.5, chatY, kScreen_Width - 15, self.view.height-chatY);
    NCNLiveChatView *chatView = [NCNLiveChatView liveChatInfoViewWithFrame:chatRect];
    chatView.belongVC = self;
    chatView.delegate = self;
    chatView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:chatView];
    [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7.5);
        make.right.offset(-7.5);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.infoView.mas_bottom);
    }];
    [chatView living_addShadowWithCornerRadius:5];
    self.chatView = chatView;
    kWeakSelf(self);
    self.blankView.didClickLivingCallback = ^{

        [weakself changeLiveViewToBigWithTargetView:weakself.blankView];

    };
    self.blankView.onSwipeGestureCallBack = ^(UISwipeGestureRecognizerDirection direction) {
        [weakself onCurrentBigViewSwipeWithDirection:direction];
    };
    chatView.settingView.settingValueChangedCallback = ^(NCNSettingChangedType style, BOOL isOpen) {
        [weakself settingValueChangedWithType:style value:isOpen];
    };

    [self.view addSubview:self.rightBottomBtnsView];

    [self.rightBottomBtnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.bottom.offset(-70);
        make.width.offset(50);
        make.height.offset(120);
    }];

    [self.view addSubview:self.landscapeBtnsCiew];
    [self.landscapeBtnsCiew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.bottom.offset(-20);
        make.width.offset(280);
        make.height.offset(50);
    }];

    self.landscapeBtnsCiew.hidden = true;

    [self.view addSubview:self.landscapeMaskView];
    [self.landscapeMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.chatView.askView.publishBtnClickCallback = ^{

        [weakself publishQuestion];
    };
    UIView *stateView = [NCNIMStateController configStateView];
    [self.view addSubview:stateView];
    [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(25);
    }];
   
}


#pragma mark 获取直播间配置信息
- (void)loadData {
    
    NSString *roomId = self.liveModel.liveRoomId;
    [NCNNetwork getLivingRoomInitialConfigWithLiveRoomID:roomId completed:^(NSError * _Nonnull error, NSDictionary * _Nonnull response) {
        
        if (response) {
           
           NCNLivingSDK.shareInstance.config = [NCNLiveConfig liveConfigWithDict:response[@"data"]];
            //测试
            [NCNNetwork getLivingRoomIMInstructsWithLiveRoomID:roomId completed:^(NSError * _Nullable error, NSDictionary * _Nullable response) {
                  if (response) {
                      NSArray *datas = response[@"data"];
                      NSMutableDictionary<NSString *,NCNBlankPPTListCellModel *> *newBlanks = @{}.mutableCopy;
                      NSMutableDictionary<NSString *, NSMutableArray<NCCustomeElemMSG *> *> *drawDictM = @{}.mutableCopy;
                      [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                          NCCustomMessageData *data = [NCCustomMessageData customMessageWithDict:obj];
                          if ([data.cmdType isEqualToString:@"16"] || [data.cmdType isEqualToString:@"17"]) {
                              NCNBlankPPTListCellModel *model = [NCNBlankPPTListCellModel modelFromElemMsg:data.cmdData];
                              newBlanks[model.pageIndex] = model;
                              
                          }
                          if (data.cmdType.intValue == 0) {
                              NCDrawElemMSG *drawElem = (NCDrawElemMSG *)data.cmdData;
                              NSString *identifier = drawElem.pageType.boolValue ? @"ppt" : @"blank";
                              NSString *key = [NSString stringWithFormat:@"%@+%@",identifier, drawElem.pageIndex];
                              NSMutableArray<NCCustomeElemMSG *> *drawsM = drawDictM[key];
                              if (drawsM == nil) {
                                  drawsM = @[].mutableCopy;
                                  drawDictM[key] = drawsM;
                              }
                              [drawsM addObject:data.cmdData];
                          }
                      }];
                      NSArray <NCNBlankPPTListCellModel *> *models = [newBlanks.allValues sortedArrayUsingComparator:^NSComparisonResult(NCNBlankPPTListCellModel  *obj1, NCNBlankPPTListCellModel  * obj2) {
                          return obj1.pageIndex.intValue > obj2.pageIndex.intValue;
                      }];
                      [models enumerateObjectsUsingBlock:^(NCNBlankPPTListCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                          NSString *key = [NSString stringWithFormat:@"%@+%@",obj.useIdentifier ,obj.pageIndex];
                          NSMutableArray *arrayM = drawDictM[key];
                          [obj.draws addObjectsFromArray:arrayM.copy];
                      }];
                      if (models.count > 0) {
                          [self.blankListView addBlanks:models];
                          NSInteger currentPage = kLivingConfig.currentPage.intValue - 1;
                          if (currentPage > models.count - 1) {
                              currentPage = 0;
                          }
                          NCNBlankPPTListCellModel *model = models[currentPage];
                          [self.blankView showContentWithCellModel:model];
                      }
                      [self startToSetup];
                  } else {
                      [YJProgressHUD showMessage:@"请求指令信息失败！" inView:self.view];
                      [self startToSetup];

                  }
              }];
        } else {
            [YJProgressHUD showMessage:@"请求配置信息失败！" inView:self.view];
            
        }
    }];
    
    
  
}
- (void)startToSetup {
   

    [self.blankView updateState];
    [self updateTeacherPullLiving];
    [self updateStudentPullLiving];
    
    [self updateMyPushLiving];
    [self updateRightButtonsState];
    
    NSMutableArray<NCNBlankPPTListCellModel *> *arrayM = [[NSMutableArray alloc] initWithCapacity:kLivingConfig.courseData.imageList.count];
    [kLivingConfig.courseData.imageList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NCNBlankPPTListCellModel *model = [NCNBlankPPTListCellModel new];
        model.useIdentifier = @"ppt";
        model.pptImageURL = obj[@"imageUrl"];
        model.pageIndex = obj[@"seq"];
        [arrayM addObject:model];
    }];
    //    [self.blankListView clear];
    [self.blankListView addPPTS:arrayM.copy];
    if (kLivingConfig.pageType.intValue == 1) {
        NSInteger index = kLivingConfig.currentPage.intValue;
        if (index < arrayM.count) {
            [self.blankListView makeListViewIsPullOut:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.blankListView selectBlankOrPPTWithType:1 pageIndex:index];
                [self.blankView showContentWithCellModel:arrayM[index - 1]];
            });
        }
        
    }
    if (arrayM.count > 0 || [self.blankListView canShow]) {
        [self showBlankListView:true];
    } else {
        [self showBlankListView:false];
    }
    
}

- (void)updateMyPushLiving {
    
    CGSize videoSmSize = CGSizeMake(self.currentBigView.width * 0.30, self.currentBigView.height * 0.30);
    if (self.currentBigView.portraitFrame.size.width > 0) {
        videoSmSize = CGSizeMake(self.currentBigView.portraitFrame.size.width * 0.30, self.currentBigView.portraitFrame.size.height * 0.30);
    }
    kWeakSelf(self);
//    NCNLivingSDK.shareInstance.config.stuPushRtmp = @"rtmp://3891.livepush.myqcloud.com/live/3891_user_365a8fc0_5d1c?bizid=3891&txSecret=75767ea83c1ec0ba288408469e2c3723&txTime=5F0C32B0";
    if ([kLivingConfig.stuId isEqualToString:NCNLivingSDK.shareInstance.studentId]) {
        if (self.studentPushView == nil) {
            
            self.studentPushView = [NCLivePushView pushViewWithLiveRoom:kLivingConfig.stuPushRtmp appid:self.liveModel.liveAppid userSign:self.liveModel.liveUserSign roomId:self.liveModel.tc_liveRoomid];
            self.studentPushView.teacherID = self.liveModel.teacherId;
            self.studentPushView.teacherShowView = [self.teacherLiveView stopTeacherLivingToPlayRemoteLiving];
            self.studentPushView.belongVC = self;
            [self.view addSubview:self.studentPushView];
            
            CGFloat y = self.isLandscape ? videoSmSize.height + 20 : kScreen_Height * 0.5;
            
            self.studentPushView.frame = CGRectMake(kLiving_margin, y, videoSmSize.width, videoSmSize.height);
            self.studentPushView.didClickLivingCallback = ^{
                [weakself changeLiveViewToBigWithTargetView:weakself.studentPushView];
            };
            self.studentPushView.onSwipeGestureCallBack = ^(UISwipeGestureRecognizerDirection direction) {
                [weakself onCurrentBigViewSwipeWithDirection:direction];
            };
            [self.studentPushView setLeftTopSymbol:@"我"];
            [self.studentPushView startToLive];
        }
    } else {
        if (self.currentBigView == self.studentPushView) {
            [self changeLiveViewToBigWithTargetView:self.blankView];
        }
        if (self.studentPushView) {
            //一开始初始化也会调用这里 不能影响老师拉流
            [self.teacherLiveView replayTeacherLiving];
        }
        [self.studentPushView stopToLive];
        [self.studentPushView removeFromSuperview];
        self.studentPushView = nil;
    
    }
    
}

- (void)updateTeacherPullLiving {
    
    
    CGSize videoSmSize = CGSizeMake(self.currentBigView.width * 0.30, self.currentBigView.height * 0.30);
    if (self.currentBigView.portraitFrame.size.width > 0) {
        videoSmSize = CGSizeMake(self.currentBigView.portraitFrame.size.width * 0.30, self.currentBigView.portraitFrame.size.height * 0.30);
    }
//    NCNLivingSDK.shareInstance.config.teacherRtmp = @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";

    kWeakSelf(self);
    if (kLivingConfig.teacherRtmp.length > 0 && kLivingConfig.isBegin.boolValue) {
        if (self.teacherLiveView == nil) {
            self.teacherLiveView = [NCLivePullView pullViewWithLiveRoom:kLivingConfig.teacherRtmp];
            self.teacherLiveView.belongVC = self;
            CGFloat y = self.isLandscape ? 10 : kScreen_Height * 0.5;
            self.teacherLiveView.frame = CGRectMake(kScreen_Width - videoSmSize.width - kLiving_margin, y, videoSmSize.width, videoSmSize.height);
            [self.view addSubview:self.teacherLiveView];
            self.teacherLiveView.didClickLivingCallback = ^{
                
                [weakself changeLiveViewToBigWithTargetView:weakself.teacherLiveView];
            };
            self.teacherLiveView.onSwipeGestureCallBack = ^(UISwipeGestureRecognizerDirection direction) {
                [weakself onCurrentBigViewSwipeWithDirection:direction];
            };
            [self.teacherLiveView setLeftTopSymbol:@"老师"];
            [self.teacherLiveView start];
        }
            
    } else {

        if (self.currentBigView == self.studentPullView) {
            [self changeLiveViewToBigWithTargetView:self.blankView];
        }
        [self.teacherLiveView stop];
        [self.teacherLiveView removeFromSuperview];
        self.teacherLiveView = nil;

    }
}

- (void)updateStudentPullLiving {
    
    CGSize videoSmSize = CGSizeMake(self.currentBigView.width * 0.30, self.currentBigView.height * 0.30);
    if (self.currentBigView.portraitFrame.size.width > 0) {
        videoSmSize = CGSizeMake(self.currentBigView.portraitFrame.size.width * 0.30, self.currentBigView.portraitFrame.size.height * 0.30);
    }
    kWeakSelf(self);
    if (kLivingConfig.stuPlayRtmp.length > 0 && ![kLivingConfig.stuId isEqualToString:NCNLivingSDK.shareInstance.studentId]) {
        if (self.studentPullView == nil) {
            self.studentPullView = [NCLivePullView pullViewWithLiveRoom:kLivingConfig.stuPlayRtmp];
            self.studentPullView.belongVC = self;
            [self.view addSubview:self.studentPullView];
            CGFloat y = self.isLandscape ? videoSmSize.height + 20 : kScreen_Height * 0.5;
            self.studentPullView.frame = CGRectMake(kLiving_margin, y, videoSmSize.width, videoSmSize.height);
            self.studentPullView.didClickLivingCallback = ^{
                [weakself changeLiveViewToBigWithTargetView:weakself.studentPullView];
            };
            self.studentPullView.onSwipeGestureCallBack = ^(UISwipeGestureRecognizerDirection direction) {
                [weakself onCurrentBigViewSwipeWithDirection:direction];
            };
            [self.studentPullView setLeftTopSymbol:kLivingConfig.stuName];
            [self.studentPullView start];
        }
        
    } else {
        
        if (self.currentBigView == self.studentPullView) {
            [self changeLiveViewToBigWithTargetView:self.blankView];
        }
        [self.studentPullView stop];
        [self.studentPullView removeFromSuperview];
        self.studentPullView = nil;
        
    }
}




#pragma mark 设备旋转

- (void)setupOrientationConfig {
    UIApplication *application = [UIApplication sharedApplication];
    id appdelegate = application.delegate;
    
    SEL implSelector = @selector(ncn_application:supportedInterfaceOrientationsForWindow:);
    
    Method originalMethod = class_getInstanceMethod([appdelegate class], @selector(application:supportedInterfaceOrientationsForWindow:));
    if (originalMethod == nil) {
        //appdelegate必须实现  这个方法
        NSAssert(0, @"appdelegate must define application:supportedInterfaceOrientationsForWindow:");
    }
    Method newMethod = class_getInstanceMethod(self.class, implSelector);
    
    method_exchangeImplementations(originalMethod, newMethod);
    
}

- (UIInterfaceOrientationMask)ncn_application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
    
}
- (BOOL)shouldAutorotate {
    
    return true;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    if (self.isLandscape) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    return UIInterfaceOrientationPortrait;
}

- (void)deviceOrientationDidChange
{
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        self.isLandscape = false;
        [self orientationChange:NO];
        
        
        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        self.isLandscape = true;
        [self orientationChange:YES];
        
    }
}
- (void)orientationChange:(BOOL)landscapeRight
{
   
    if (landscapeRight) {
      
        [self enterLandscapeScreen];
    } else {
        
        [self exitLandscapeScreen];
    }
   
}

- (void)enterLandscapeScreen {
    
   
    if (self.currentBigView.oritention == NCLivingViewOritention_landscape) {
        return;
    }

    [self.blankView prepareRatateOritentionLandscape];
    [self.teacherLiveView prepareRatateOritentionLandscape];
    [self.studentPushView prepareRatateOritentionLandscape];
    [self.studentPullView prepareRatateOritentionLandscape];
    //处理可移动view的位置
    NSMutableArray *smallViews = [[NSMutableArray alloc] initWithCapacity:3];
    if (self.teacherLiveView != self.currentBigView && self.teacherLiveView) {
        [smallViews addObject:self.teacherLiveView];
    }
    if (self.studentPushView != self.currentBigView && self.studentPushView) {
        [smallViews addObject:self.studentPushView];
    }
    if (self.studentPullView != self.currentBigView && self.studentPullView) {
        [smallViews addObject:self.self.studentPullView];
    }
    if (self.blankView != self.currentBigView) {
        [smallViews addObject:self.self.blankView];
    }
    for (int  i = 0; i < smallViews.count; i++) {
        UIView *view = smallViews[i];
        view.frame = CGRectMake(kScreen_Width - view.width - 10, 10 + (i  * (view.height + 10)), view.width, view.height);
    }
    self.landscapeBtnsCiew.hidden = false;
    NCNSpeakView *chatView = self.chatView.getChatView;
    [self.view addSubview:self.chatView.getChatView];
    [self.chatView.getChatView enterLandscapeScreen];
    chatView.frame = CGRectMake(35, self.view.height - 200 - 80, 350, 200);
        [self.rightBottomBtnsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            CGFloat rightMargin = -10;
            if (@available(iOS 11.0, *)) {
                rightMargin = self.view.safeAreaLayoutGuide.layoutFrame.origin.x > 0 ? -32 : -10;
            }
            make.right.offset(rightMargin);
            make.bottom.offset(-20);
            make.width.offset(180);
            make.height.offset(120);
        }];
    
    self.infoView.hidden = true;
    self.chatView.hidden = true;
       
    if (self.blankListView.hidden == false) {
        CGFloat blankMaxY = self.view.height - 95;
        self.blankListView.frame = CGRectMake(0, blankMaxY, self.view.width, 95);
         [self.view bringSubviewToFront:self.blankListView];
    }
 
    
    self.closeBtn.hidden = true;
    
    
    [self addChildViewController:self.inputVC];
    [self.view addSubview:self.inputVC.view];
    self.inputVC.view.frame = CGRectMake(0, self.view.height - 70, self.view.width, 70);
    self.inputVC.view.hidden = true;
        [self.blankListView enterLandscape:true];
    [self.chatView.getChatView scrollToMessageBottom];
}

- (void)exitLandscapeScreen {
    if (self.currentBigView.oritention == NCLivingViewOritention_portrait) {
        return;
    }
    [self.blankListView enterLandscape:false];
    self.landscapeBtnsCiew.hidden = true;
    self.landscapeMaskView.hidden = true;
    self.rightBottomBtnsView.hidden = false;
    [self.rightBottomBtnsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.bottom.offset(-70);
        make.width.offset(180);
        make.height.offset(120);
    }];
    self.infoView.hidden = false;
    self.chatView.hidden = false;
    [self.blankView prepareRatateOritentionPortrait];
    [self.teacherLiveView prepareRatateOritentionPortrait];
    [self.studentPushView prepareRatateOritentionPortrait];
    [self.studentPullView prepareRatateOritentionPortrait];
    

    if (self.blankListView.hidden == false) {
        
        CGRect infoRect = CGRectMake(0, CGRectGetMaxY(self.currentBigView.frame) + 3, kScreen_Width, 71);
        self.blankListView.hidden = false;
        self.blankListView.frame = infoRect;
    }

//
    self.closeBtn.hidden = false;

    [self.chatView restarationChatView];
    NCNSpeakView *chatView = self.chatView.getChatView;
    [chatView enterPortraitScreen];
    [self.landscapeMaskView.allShowViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.chatView addLostView:obj];
    }];
    
    [self.inputVC removeFromParentViewController];
    [self.inputVC.view removeFromSuperview];

  
}


- (void)showBlankListView:(BOOL)isShow {
    
    self.blankListView.hidden = !isShow;
        
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage:) name:TUIKitNotification_TIMMessageListener object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMloginSuccessful) name:TUIKitNotification_onLoginSuccessful object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];

}

- (void)changeLiveViewToBigWithTargetView:(NCLiveView *)view {
    
    if (self.currentBigView.portraitFrame.size.width == 0) {
        self.currentBigView.portraitFrame = self.currentBigView.frame;
    }
    [self.inputVC.inputBar endEditing:true];
    self.inputVC.view.hidden = true;
    if (self.isLandscape) {
        //如果
        self.chatView.getChatView.hidden = true;
        self.landscapeBtnsCiew.hidden =  !self.landscapeBtnsCiew.isHidden ;
        self.rightBottomBtnsView.hidden = !self.rightBottomBtnsView.isHidden;
        [self.blankListView dismisswSelfViewOnLandscape];
    }
    if (self.currentBigView.state == NCLivingViewStateMoving || view == self.currentBigView) {
        return;
    }
    
    CGRect smallFrame = view.frame;
    CGRect bigFrame = self.currentBigView.frame;
    //有的系统会崩溃
    if (bigFrame.size.width == 0 || bigFrame.size.height == 0) {
        return;
        
    }
    [self.view bringSubviewToFront:self.self.currentBigView];
    [view prepareZoomToBigFrame:self.currentBigView.frame];
    [self.currentBigView prepareZoomToSmallFrame:smallFrame];
    [UIView animateWithDuration:0.25 animations:^{
        self.currentBigView.state = NCLivingViewStateMoving;
        view.state = NCLivingViewStateMoving;
        if ([self.currentBigView.class isSubclassOfClass:NCNBlankView.class]) {
            ///blankView更改的是transform 所以宽高也需要跟着一致
            view.frame = bigFrame;
            self.currentBigView.frame = smallFrame;
        }  else {
            view.frame = bigFrame;
            self.currentBigView.frame = smallFrame;
        }
       
    } completion:^(BOOL finished) {
        //需要转移在竖屏时的frame
        view.portraitFrame = self.currentBigView.portraitFrame;
//        self.currentBigView.portraitFrame = CGRectZero;
        self.currentBigView.smallOriginalFrame = view.smallOriginalFrame;
//        view.smallOriginalFrame = CGRectZero;
        view.state = NCLivingViewStateBig;
        self.currentBigView.state = NCLivingViewStateSmall;
        self.currentBigView = view;
        self.currentBigView.smallOriginalFrame = view.smallOriginalFrame;
        [self.view sendSubviewToBack:self.currentBigView];
       
    }];
   
    
    
}

#pragma mark NCNBlankViewDelegate

- (void)blankView:(NCNBlankView *)view onButtonClicked:(BOOL)isSelected {
    
    if (self.isLandscape) {
        if (isSelected) {
            [self.blankListView showSelfViewOnLandscape];
        } else {
            [self.blankListView dismisswSelfViewOnLandscape];
        }
    } else {
        self.blankListView.hidden = isSelected;
    }
    
}

#pragma mark NCNBlankPPTListViewDelegate

- (void)blankPPTListView:(NCNBlankPPTListView *)view scrollBlankToIndexPath:(NSIndexPath *)path {
    
    [self.blankView scrollToIndexPath:path];
    
}

- (void)blankPPTListView:(NCNBlankPPTListView *)view scrollPPTToIndexPath:(NSIndexPath *)path {
    
    
    
}

- (void)blankPPTListView:(NCNBlankPPTListView *)view selectedSomeCellModel:(NCNBlankPPTListCellModel *)model {
    
    [self.blankView showContentWithCellModel:model];
    
}


#pragma mark NCNLiveTeacherInfoDelegate

- (void)teacherInfoView:(NCNLiveTeacherInfoView *)view isFold:(BOOL)isfold {
    
    CGFloat height = !isfold ? 71 : 44;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.currentBigView.frame) + 3, kScreen_Width, height);
        self.infoView.frame = rect;
        [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(height);
            make.top.offset(CGRectGetMaxY(self.blankView.frame));
        }];
        [self.view layoutIfNeeded];
        
    }];

}

#pragma mark NCNLiveChatViewDelegate

- (void)chatView:(NCNLiveChatView *)view ratateMovieViewToOrientation:(UIInterfaceOrientation)orientation {
    
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        
        self.isLandscape = true;
        [self orientationChange:true];

    } else {
        
        self.isLandscape = false;
        [self orientationChange:false];
        
    }
}

- (void)chatView:(NCNLiveChatView *)view onFaceKeyBoardIsShow:(BOOL)isShow {
    
    if (isShow) {
        [self.view sendSubviewToBack:self.rightBottomBtnsView];
    } else {
         [self.view bringSubviewToFront:self.rightBottomBtnsView];
    }
    
}

- (void)chatView:(NCNLiveChatView *)view onCameraIsOpen:(BOOL)isOpen {
    
    
}

- (void)chatView:(NCNLiveChatView *)view onMicphoneIsOpen:(BOOL)isOpen {
    
    
}

- (void)onHandUpChatView:(NCNLiveChatView *)view {
    
//    NCNTestView *testView = [[NCNTestJudgeView alloc] initWithFrame:CGRectZero];
//    NCNTestResultView *resultView = [NCNTestResultView new];
//    [resultView showOnView:UIApplication.sharedApplication.keyWindow ];
}

- (void)onDrawClearChatView:(NCNLiveChatView *)view {
    
    NCNRollCallAlert *alert = [NCNRollCallAlert rollCallAlertWithTime:120];
    
    [alert showOnView:UIApplication.sharedApplication.keyWindow];
    
}

- (void)onStartDrawChatView:(NCNLiveChatView *)view {
    
    
}

- (void)settingValueChangedWithType:(NCNSettingChangedType)type value:(BOOL)isOpen {
    
    if (self.studentPushView) {
        switch (type) {
            case NCNSettingChangedType_microphone:
               
                [self.studentPushView openMircphone:isOpen];
                
                break;
                
            case NCNSettingChangedType_camera:
                [self.studentPushView openCamera:isOpen];

                break;
                
            case NCNSettingChangedType_beauty:
                
                [self.studentPushView openBeauty:isOpen];
                break;
                
            case NCNSettingChangedType_capturePosition:
                
                [self.studentPushView changeCapturePosition:isOpen];
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark NCNBlankViewDelegate

#pragma mark TInputControllerDelegate

- (void)inputController:(TUIInputController *)inputController didChangeHeight:(CGFloat)height {
    
    __weak typeof(self) ws = self;
       [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

           CGRect inputFrame = ws.inputVC.view.frame;
           inputFrame.origin.y = ws.view.height - height;
           inputFrame.size.height = height;
           ws.inputVC.view.frame = inputFrame;
           
           
       } completion:nil];
    
}
- (void)inputController:(TUIInputController *)inputController didSendMessage:(NSString *)msg {
    
    NCNTextMessageCellModel *model = [NCNTextMessageCellModel new];
    model.content = msg;
    [inputController.inputBar endEditing:true];
    [self.chatView.getChatView sendMessageWithCellModel:model];
    
}

- (void)inputController:(TUIInputController *)inputController onPrepareSendPhotos:(NSArray<UIImage *> *)images {
    
    [self.chatView.getChatView sendImageMessageWithImages:images];
}


#pragma mark button action

//对当前的主屏幕view的手势操作， 只在横屏下开启
- (void)onCurrentBigViewSwipeWithDirection:(UISwipeGestureRecognizerDirection)direction {
 
    if (direction == UISwipeGestureRecognizerDirectionUp) {
        
        [self.blankListView showSelfViewOnLandscape];
        
    } else if (direction == UISwipeGestureRecognizerDirectionDown) {
        
        [self.blankListView dismisswSelfViewOnLandscape];

    }
    
}

- (void)closeBtnClick {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定退出教室吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        ////再将方法交换回去
           [self setupOrientationConfig];
           [self.studentPushView stopToLive];
           [self.teacherLiveView stop];
           [self.studentPullView stop];
            [NCIMManager.sharedInstance disConectLiveRoom];
            [NCIMManager.sharedInstance logoutForIM];
           [self dismissViewControllerAnimated:true completion:nil];
        
    }]];
    
    [self presentViewController:alertVC animated:true completion:nil];
    
   
}

- (void)rightBottomViewBtnClick:(UIButton *)sender {

    switch (sender.tag) {
        case 11:
            //点击了举手
        {
            if (kLivingConfig.isBegin.boolValue == false) {
                [YJProgressHUD showMessage:@"老师还没有上课" inView:self.view];
                return;
            }
            
            BOOL isHandup = true;
            //我是否正在推流
            BOOL isPushingStream = [kLivingConfig.stuId isEqualToString:NCNLivingSDK.shareInstance.studentId];
            if (sender.isSelected) {
                isHandup = false;
                sender.selected = false;
                //关闭我的推流
                kLivingConfig.stuId = nil;
                [self updateMyPushLiving];
            } else {
                isHandup = !self.handsupTimer.isValid;
            }
            [self updateRightButtonsState];
            
            TIMMessage *message = [NCNCustomMessageUtil customMessageForSendHandsUpWithOpen:isHandup];
            
            [[self teacherConversaction] sendMessage:message succ:^{
                
                [YJProgressHUD showMessage:(self.handsupTimer.isValid || isPushingStream) ? @"举手被取消了" : @"举手成功，等待同意..." inView:self.view];

                if (!self.handsupTimer.isValid && !isPushingStream) {
                    //开始倒计时
                    self.handsupTimer = [NSTimer dy_scheduledWeakTimerWithTimeInterval:1.0 target:self selector:@selector(handsupTimerFire) userInfo:nil repeats:true];
                } else {
                    [self.handsupTimer invalidate];
                    self.handsupTimer = nil;
                    self->_handsupCount = 0;
                    [[self.rightBottomBtnsView viewWithTag:1001] removeFromSuperview];
                }
                
            } fail:^(int code, NSString *msg) {
                [YJProgressHUD showMessage:[NCNLivingHelper im_errorMsgWithCode:code defaultErrMsg:@"举手失败！"] inView:self.view];
                
            }];
            
        }
            
            
            break;
        case 12:
            sender.selected = !sender.isSelected;

            //点击了旋转屏幕
            if (sender.isSelected) {
                self.isLandscape = true;
                 if ([[UIDevice currentDevice]   respondsToSelector:@selector(setOrientation:)]) {
                          [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeLeft]
                                                       forKey:@"orientation"];
                        }

                [self orientationChange:true];

            } else {
                
                self.isLandscape = false;
                if ([[UIDevice currentDevice]   respondsToSelector:@selector(setOrientation:)]) {
                  [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait]
                                               forKey:@"orientation"];
                }
                [self orientationChange:false];
            }
            break;
        case 13:
            sender.selected = !sender.isSelected;

            //点击了相机
            kLivingSettingConfig.isOpenCamera = !sender.isSelected;
            [self.chatView.settingView updateButtonStateWithType:NCNSettingChangedType_camera isOpen:!sender.isSelected];
            break;
        case 14:
            //点击了麦克风
            sender.selected = !sender.isSelected;
            kLivingSettingConfig.isOpenMicrophone = !sender.isSelected;
            [self.chatView.settingView updateButtonStateWithType:NCNSettingChangedType_microphone isOpen:!sender.isSelected];

            break;
            
        default:
            break;
    }
}
//倒计时花圈动画
- (void)handsupTimerFire {
    
    UIButton *handsupBtn = [self.rightBottomBtnsView viewWithTag:11];
    _handsupCount++;
    if (_handsupCount == 60) {
       
        [self rightBottomViewBtnClick:handsupBtn];
        
    } else {
        UIView *ovalView = [self.rightBottomBtnsView viewWithTag:1001];
        if (ovalView == nil) {
            ovalView = UIView.new;
            ovalView.backgroundColor = UIColor.clearColor;
            ovalView.tag = 1001;
            [self.rightBottomBtnsView addSubview:ovalView];
            ovalView.frame = handsupBtn.bounds;
            ovalView.userInteractionEnabled = false;
            ovalView.transform = CGAffineTransformMakeScale(0.98, 0.98);
        }
        
        CAShapeLayer *shapeLayer = ovalView.layer.sublayers.lastObject;
        if (shapeLayer == nil) {
            shapeLayer = [CAShapeLayer new];
            shapeLayer.frame = ovalView.bounds;
            [ovalView.layer addSublayer:shapeLayer];
        }
        CGFloat endAngle = (M_PI * 2) / 60 * _handsupCount;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:handsupBtn.center radius:handsupBtn.width * 0.5 startAngle:0 endAngle:endAngle clockwise:true];
        shapeLayer.strokeColor = [[UIColor colorWithHexString:@"#FF890B"] CGColor];
        shapeLayer.fillColor = UIColor.clearColor.CGColor;
        shapeLayer.path = path.CGPath;
        shapeLayer.lineWidth = 2.0;
    }
    
}
- (void)handsupBtnCountDown:(UIButton *)sender {
    
    
}
- (void)landscapeBtnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
            //点击了聊天
            self.inputVC.view.hidden = false;
            if (self.isLandscape) {
                self.chatView.getChatView.hidden = false;
            }
            [self.inputVC.inputBar becomeFirstResponder];
            [self.inputVC.inputBar endEditing:false];
            
            break;
        default:
            // 1 问答 2： 成员 3： 通知 4：设置
        {
            NSDictionary *titleDict = @{@"1":@"问答",@"2":@"在线成员",@"3":@"公告",@"4":@"设置"};
            NSDictionary *viewDict = @{@"1":self.chatView.askView,@"2":self.chatView.memberView,@"3":self.chatView.announceView,@"4":self.chatView.settingView};

            NSString *key = [NSString stringWithFormat:@"%ld",sender.tag];
            UIView *showingView = viewDict[key];
            if ([showingView isKindOfClass:NCNAnnouncementView.class]) {
                [(NCNAnnouncementView *)showingView willAppear];
            }
            
            [self.landscapeMaskView showWithTitle:titleDict[key] subView:viewDict[key]];
            self.landscapeMaskView.transform = CGAffineTransformMakeTranslation(0, -self.view.height);
            [self.view bringSubviewToFront:self.landscapeMaskView];
            [UIView animateWithDuration:0.5 animations:^{
                self.landscapeMaskView.hidden = false;
                self.landscapeMaskView.transform = CGAffineTransformIdentity;
            }];
            
        }
            
            break;
    }
    
}
- (void)publishQuestion {
    
    NCNPublishVC *vc = [NCNPublishVC new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    kWeakSelf(self);
    vc.publishBtnClickCallback = ^(NCNPublishVC * _Nonnull vc, NSString * _Nonnull text) {
        
        if (text.length > 200) {
            [YJProgressHUD showMessage:@"最长不能超过200个字符!" inView:vc.view];
            return;
        }
        
        TIMMessage *msg = [NCNCustomMessageUtil customMessageForSendQuestionWithText:text];
        [[weakself teacherConversaction] sendMessage:msg succ:^{
            
            NCNQ_ACellData *data = [NCNQ_ACellData new];
            data.askText = text;
            data.askId = [NSString stringWithFormat:@"%llu",msg.locator.seq];
            data.askName = NCIMManager.sharedInstance.myselfProfile.nickname;
            data.askTime = [NSDate.date dateWithFormat:@"hh:mm"];
            data.askElem = msg;
            data.sender = [NCNLivingSDK.shareInstance studentId];
            [weakself.chatView.askView addQAData:@[data]];

            [vc dismissViewControllerAnimated:true completion:^{
                [YJProgressHUD showMessage:@"提问发送成功！" inView:weakself.view];
            }];
            
        } fail:^(int code, NSString *msg) {
            [YJProgressHUD showMessage:[NCNLivingHelper im_errorMsgWithCode:code defaultErrMsg:@"提问发送失败！"] inView:UIApplication.sharedApplication.keyWindow];

        }];
    };
    
    [self presentViewController:nav animated:true completion:nil];
    
}



#pragma mark IM

- (void)IMloginSuccessful {
    [[TIMManager.sharedInstance groupManager] getGroupList:^(NSArray *groupList) {
        NSLog(@"%@,",groupList);
    } fail:^(int code, NSString *msg) {
        
    }];
    [[TIMManager.sharedInstance friendshipManager] getFriendList:^(NSArray<TIMFriend *> *friends) {
        
        NSLog(@"%@,",friends);

    } fail:^(int code, NSString *msg) {
        
    }];
    self.groupConversation = [TIMManager.sharedInstance getConversation:TIM_GROUP receiver:NCNLivingSDK.shareInstance.groupId];
    self.groupCodeConversation = [TIMManager.sharedInstance getConversation:TIM_GROUP receiver:NCNLivingSDK.shareInstance.groupCodeId];
}

- (void)onNewMessage:(NSNotification *)info {
    
    NSArray<TIMMessage *> *messages = info.object;
    for (TIMMessage *message in messages) {
        TIMConversation *conversation = [message getConversation];
        NSString *receiverID = [conversation getReceiver];
       
        if (![receiverID isEqualToString:self.groupConversation.getReceiver] && ![receiverID isEqualToString:[self teacherConversaction].getReceiver] && ![receiverID isEqualToString:[self groupCodeConversation].getReceiver]) {
            continue;
        }
        TIMElem *elem = [message getElem:0];
        NSMutableArray *newMessages = [[NSMutableArray alloc] initWithCapacity:messages.count];
        if ([receiverID isEqualToString:self.groupConversation.getReceiver]) {
            [newMessages addObject:message];
        }
      
        if ([elem isKindOfClass:TIMCustomElem.class]) {
            TIMCustomElem *custom = (TIMCustomElem *)elem;
            [self handleUpCustomeMessage:custom message:message];
        }
        if (newMessages.count > 0) {
            [self.chatView.getChatView insertNewMessages:newMessages];
        }
    }
    
}

- (void)handleUpCustomeMessage:(TIMCustomElem *)elem message:(TIMMessage *)msg {
    
    NSError *error = NULL;
    NSDictionary *customDict = [NSJSONSerialization JSONObjectWithData:elem.data options:0 error:&error];
    if (!error) {
        NCCustomMessageData *message = [NCCustomMessageData customMessageWithDict:customDict];
        /*
         2    答题器    答题器指令
         4    测验    开始/结束测验，公布测验答案
         8    学生锁    打开  ； 关闭
         11    点赞    无
         18    学生提交答题器答案    提交答题器答案
         20    学生端提交测验答案    提交测验（测试）答案
         23    标清/高清切换    标清/高清切换指令
         */
        switch (message.cmdType.intValue) {
            case 0:
                #pragma mark  0    批注    白板中的图形、笔迹

            {
                NCDrawElemMSG *msg = (NCDrawElemMSG *)message.cmdData;
                msg.isNewMsg = true;
                [self.blankListView addNewDrawMSG:msg];
                
            }
                break;
            case 14:
                #pragma mark  14    删除图形    删除指定图形
            {
               NCDrawElemMSG *msg = (NCDrawElemMSG *)message.cmdData;
                [self.blankListView deleteAnyoneDrawWithDrawMessage:msg];
                
            }
                break;
            case 15:
                #pragma mark   15    清空页面    清空指定页面中的批注

            {
                NCDrawElemMSG *msg = (NCDrawElemMSG *)message.cmdData;
                [self.blankListView clearDrawLayerWithDrawMessage:msg];
            }
                break;
            case 16:
                #pragma mark   16    新增白板页
            {
                NCAddNewBlankElemMSG *msg = (NCAddNewBlankElemMSG *)message.cmdData;
                NCNBlankPPTListCellModel *model = [NCNBlankPPTListCellModel modelFromElemMsg:msg];
                [self.blankListView addBlanks:@[model]];
                if (self.blankListView.isHidden == true) {
                    self.blankListView.hidden = false;
                    [self teacherInfoView:self.infoView isFold:false];
                    [self.blankView showContentWithCellModel:model];
                }
            }
                break;
            case 17:
                #pragma mark   17    设置白板页背景    设置页面的背景色/背景图片
            {
                NCAddNewBlankElemMSG *msg = (NCAddNewBlankElemMSG *)message.cmdData;
                [self.blankListView updateDrawLayerBackgroundColorWithMessage:msg];
            }
                break;
            case 1:
                #pragma mark  1    课件控制    打开或关闭ppt课件
            {
                NCControlElemMSG *msg = (NCControlElemMSG *)message.cmdData;
                if (msg.optType.boolValue) {
                    NSMutableArray *ppts = [[NSMutableArray alloc] initWithCapacity:msg.imageList.count];
                    [msg.imageList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       
                        NSString *imageUrl = [obj valueForKey:@"imageUrl"];
                        NSString *pageIndex = [obj valueForKey:@"seq"];
                        
                        NCNBlankPPTListCellModel *model = [NCNBlankPPTListCellModel new];
                        model.blankColor = UIColor.clearColor;
                        model.useIdentifier = @"ppt";
                        model.pageIndex = pageIndex;
                        model.pptImageURL = imageUrl;
                        [ppts addObject:model];
                        
                    }];
                    //如果先显示ppt 会有bug
                    [self.blankListView addPPTS:ppts];
                } else {
                    [self.blankListView closePPT];
                }
                
            }
                break;
            case 2:
            {
                #pragma mark  答题器
                NCAnswerElemMSG *msg = (NCAnswerElemMSG *)message.cmdData;
                
                if (self.testView) {
                    if (msg.questionOperation.boolValue == false) {
                        [YJProgressHUD showMessage:@"答题结束" inView:self.view];
                    }
                    [self.testView canSubmit:msg.questionOperation.boolValue];
                } else {
                    if (msg.questionOperation.boolValue == false) {
                        return;
                    }
                    NCNTestView *view = [NCNTestView testWithElem:msg];
                    kWeakSelf(self);
                    view.submitAnswerCallback = ^(NCNTestView * _Nonnull view, NSString * _Nonnull result) {
                        TIMMessage *message = [NCNCustomMessageUtil customMessageForSendTestAnswerWithText:result];
                        view.elemMsg.myAnswer = result;
                        [[weakself teacherConversaction] sendMessage:message succ:^{
                            
                            if (view.elemMsg.showAnswer.boolValue) {
                                NCNTestResultView *resultView = [NCNTestResultView new];
                                [resultView showOnView:nil elemMsg:view.elemMsg];
                            }
                            [view dismiss];
                        } fail:^(int code, NSString *msg) {
                            
                            [YJProgressHUD showMessage:[NCNLivingHelper im_errorMsgWithCode:code defaultErrMsg:@"提交失败！"] inView:weakself.view];
                        }];
                    };
                    [view showOnView:nil];
                    self.testView = view;
                }
            }
                break;
            case 13:
                
            {
                #pragma mark   13    翻页    翻页动作

                NCControlElemMSG *msg = (NCControlElemMSG *)message.cmdData;
                
                NCNBlankPPTListCellModel *model = [self.blankListView selectBlankOrPPTWithType:msg.pageType.intValue pageIndex:msg.pageIndex.intValue];
                [self.blankView showContentWithCellModel:model];
                
            }
                break;
                
                case 3:
            {
                #pragma mark  3    点名    点名指令，指定答道时间
                NCCustomeElemMSG *msg = message.cmdData;
                NSUInteger time = [msg.cmdData integerValue];
                NCNRollCallAlert *alert = [NCNRollCallAlert rollCallAlertWithTime:time];
                [alert showOnView:nil];
                kWeakSelf(self);
                alert.completeCallback = ^(NCNBaseAlertFlags flag, id  _Nullable unknown, NCNBaseAlert * _Nonnull alert) {
                    if (flag == NCNBaseAlertFlag_Sign) {
                        TIMMessage *message = [NCNCustomMessageUtil customMessageForSendSign];
                        [[weakself teacherConversaction] sendMessage:message succ:^{
                            [alert dismiss];
                            [YJProgressHUD showMessage:@"答到成功！" inView:self.view];

                        } fail:^(int code, NSString *msg) {
                            [YJProgressHUD showMessage:[NCNLivingHelper im_errorMsgWithCode:code defaultErrMsg:@"答到失败！"] inView:self.view];

                        }];
                    }
                };
            }
                break;
            case 5:
            {
                #pragma mark   5    问答    问答消息，需要指定所回答的问题消息ID
                NCQAElemMSG *msg = message.cmdData;
                NCNQ_ACellData *data = [self.chatView.askView findDataWithId:msg.askId];
                if (data) {
                    data.answerText = msg.askText;
                    data.answerName = NCIMManager.sharedInstance.teacherProfile.nickname;
                    data.answerTime = [NSDate.date dateWithFormat:@"hh:mm"];
                    data.answerElem = message;
                    [self.chatView.askView updateData:data];
                    
                }
                
            }
                break;
                
            case 6:
            {
                #pragma mark   6    上课/下课    上课  ； 下课
                NCCustomeElemMSG *msg = message.cmdData;
                if ([msg.cmdData boolValue]) {
                    [self attendClass];
                } else {
                    [self classRommEnded];
                }

            }
                break;
            case 7:
                #pragma mark  7    接受/拒绝举手    接受  ； 拒绝

            {
                NCCustomeElemMSG *msg = message.cmdData;
                NSString *open = [msg valueForKey:@"open"];
                if (open.boolValue) {
                    //老师同意了举手  开始推流
//                    NSString *pushURL = [msg valueForKey:@"liveUrl"];
//                    kLivingConfig.stuPushRtmp = pushURL;
                    kLivingConfig.stuId = NCNLivingSDK.shareInstance.studentId;
                    [self updateMyPushLiving];
                    UIButton *handupBtn = [self.rightBottomBtnsView viewWithTag:11];
                    [handupBtn setHidden:false];
                    handupBtn.selected = true;
                    [self.handsupTimer invalidate];
                    self.handsupTimer = nil;
                    self->_handsupCount = 0;
                    [[self.rightBottomBtnsView viewWithTag:1001] removeFromSuperview];
                } else {
                    //老师拒绝或关闭了举手
                    if (self.studentPushView || self.handsupTimer.isValid) {
                        [YJProgressHUD showMessage:self.studentPushView == nil ? @"老师拒绝了你的举手" : @"老师关闭了你的举手" inView:self.view];

                        [self.handsupTimer invalidate];
                        self.handsupTimer = nil;
                        self->_handsupCount = 0;
                        [[self.rightBottomBtnsView viewWithTag:1001] removeFromSuperview];
                        [[self handsupBtn] setSelected:false];
                        kLivingConfig.stuId = nil;
                        [self updateMyPushLiving];
                        [self updateRightButtonsState];
                    }
                }
            }
                break;
            case 9:
            {
                #pragma mark   9    摄像头    打开  ； 关闭
                NCCustomeElemMSG *msg = message.cmdData;
                BOOL isOpen = [msg.cmdData boolValue];
                kLivingSettingConfig.isOpenCamera = isOpen;
                [self.chatView.settingView updateButtonStateWithType:NCNSettingChangedType_camera isOpen:isOpen];
                [self.studentPushView openCamera:isOpen];
                if (isOpen) {
                    [self.chatView.settingView makeButtonDisableWithType:NCNSettingChangedType_camera isOpen:false];
                } else {
                    [self.chatView.settingView makeButtonDisableWithType:NCNSettingChangedType_camera isOpen:true];
                }
                
            }
                break;
            case 10:
            {
                #pragma mark  10    麦克风    打开  ； 关闭
                NCCustomeElemMSG *msg = message.cmdData;
                BOOL isOpen = [msg.cmdData boolValue];
                kLivingSettingConfig.isOpenMicrophone = isOpen;
                [self.chatView.settingView updateButtonStateWithType:NCNSettingChangedType_microphone isOpen:isOpen];
                [self.studentPushView openMircphone:isOpen];
                if (isOpen) {
                    [self.chatView.settingView makeButtonDisableWithType:NCNSettingChangedType_microphone isOpen:false];
                } else {
                    [self.chatView.settingView makeButtonDisableWithType:NCNSettingChangedType_microphone isOpen:true];
                }
                
            }
                break;
            case 12:
            
            {
                #pragma mark  12    举手控制开关    1：允许/ 0：禁止举手
                NCCustomeElemMSG *msg = message.cmdData;
                if ([msg.cmdData boolValue]) {
                    kLivingConfig.isHandup = @"1";
                    [[self handsupBtn] setHidden:false];
                } else {
                    kLivingConfig.isHandup = @"0";
                    [[self handsupBtn] setHidden:true];
                }

            }
                break;
            case 21:
            {
                #pragma mark   21    教师端推流    打开/关闭教师直播推流

                NCCustomeElemMSG *msg = message.cmdData;
                NSString *open = [msg valueForKey:@"open"];
               
               NSString *rtmpURL = [msg valueForKey:@"liveUrl"];
               kLivingConfig.teacherRtmp = rtmpURL;
               [self updateTeacherPullLiving];
                
            }
                
                break;
            case 22:
            {
                #pragma mark  22    学生端推流    同意学生举手，推送指令
                //其他的同学举手了  也有可能是自己
                NCCustomeElemMSG *msg = message.cmdData;
                NSString *open = [msg valueForKey:@"open"];
                NSString *rtmpURL = [msg valueForKey:@"liveUrl"];
                NSString *stuId = [msg valueForKey:@"stuId"];
               
                NSString *stuName = [msg valueForKey:@"stuName"];
                //如果是自己就不处理
                if (![stuId isEqualToString:NCNLivingSDK.shareInstance.studentId] && stuId.length > 0) {
                    kLivingConfig.stuPlayRtmp = rtmpURL;
                    kLivingConfig.isHandup = open.boolValue ? @"0" : @"1";
                    kLivingConfig.stuName = stuName;
                    kLivingConfig.stuId = stuId;
                    [self updateRightButtonsState];
                    [self updateStudentPullLiving];
                }
               
            }
                
                break;
            case 26:
            {
                TIMMessage *message = [NCNCustomMessageUtil customMessageForSendOnlineOrder];
                [[self teacherConversaction] sendMessage:message succ:^{
                    NSLog(@"给老师发送在线指令成功！");
                } fail:^(int code, NSString *msg) {
                    NSLog(@"%d, %@",code, msg);
                }];
            }
                break;
                                
            default:
                break;
        }
        NSLog(@"收到自定义消息： %@",customDict);
    }
}

- (void)classRommEnded {
    
    NCNLiveConfig *config = [NCNLiveConfig new];
    config.isBegin = @"0";
    config.isHandup = @"0";
    NCNLivingSDK.shareInstance.config = config;
    [self startToSetup];
    [self.blankView classEnded];
    self.blankListView.hidden = true;
    [self.blankListView clear];
    [NCNLivingSDK.shareInstance classRoomEnded];
//    [self teacherInfoView:self.infoView isFold:true];
    [[self handsupBtn] setHidden:true];
    [self.testView dismiss];
    
    
    
}
#pragma mark 开始上课
- (void)attendClass {
    
    NCNLiveConfig *config = [NCNLiveConfig new];
    config.isBegin = @"1";
    config.isHandup = @"1";
    NCNLivingSDK.shareInstance.config = config;
    [self startToSetup];
}

//- (BOOL)prefersStatusBarHidden {
//
//    return self.isLandscape;
//
//}


#pragma mark 右下角 按钮 状态设置
- (void)updateRightButtonsState {
    
    UIButton *handupBtn = [self.rightBottomBtnsView viewWithTag:11];
    UIButton *cameraBtn = [self.rightBottomBtnsView viewWithTag:13];
    UIButton *micphoneBtn = [self.rightBottomBtnsView viewWithTag:14];

    if ([kLivingConfig.stuId isEqualToString:NCNLivingSDK.shareInstance.studentId]) {
//            cameraBtn.hidden = false;
        
//            micphoneBtn.hidden = false;
            handupBtn.hidden = false;
            handupBtn.selected = true;
        } else {
            cameraBtn.hidden = true;
            micphoneBtn.hidden = true;
            handupBtn.hidden = !kLivingConfig.isHandup.boolValue;
            handupBtn.selected = false;
        }
       
    //有学生举手并且举手的不是我
    if (kLivingConfig.stuPlayRtmp.length > 0 && ![kLivingConfig.stuId isEqualToString:NCNLivingSDK.shareInstance.studentId]) {
        handupBtn.hidden = true;
    }
    
}
- (void)hideLivingBtn:(BOOL)isHide {
    UIButton *cameraBtn = [self.rightBottomBtnsView viewWithTag:13];
    UIButton *micphoneBtn = [self.rightBottomBtnsView viewWithTag:14];
    cameraBtn.hidden = isHide;
    micphoneBtn.hidden = isHide;
    
}
- (void)disableLivingBtn:(BOOL)disable {
    UIButton *cameraBtn = [self.rightBottomBtnsView viewWithTag:13];
    UIButton *micphoneBtn = [self.rightBottomBtnsView viewWithTag:14];
    cameraBtn.enabled = !disable;
    micphoneBtn.enabled = !disable;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:true];
    
}
#pragma mark lazy

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
    
}


- (NCNBlankPPTListView *)blankListView {
    
    if (!_blankListView) {
        _blankListView = [NCNBlankPPTListView new];
        _blankListView.hidden = true;
    }
    return _blankListView;
    
}

- (UIView *)rightBottomBtnsView {
    
    if (!_rightBottomBtnsView) {
            
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = UIColor.clearColor;
        
        UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rotateBtn.tag = 12;
        [rotateBtn setImage:[UIImage living_imageWithNamed:@"rotateScreen@3x"] forState:UIControlStateNormal];
        [contentView addSubview:rotateBtn];
        [rotateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(contentView).offset(0);
            make.bottom.mas_equalTo(contentView).offset(0);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        [rotateBtn addTarget:self action:@selector(rightBottomViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *handsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [handsBtn setImage:[UIImage living_imageWithNamed:@"handUp-normal@3x"] forState:UIControlStateNormal];
        [handsBtn setImage:[NSBundle living_loadImageWithName:@"handUp-open@3x"] forState:UIControlStateSelected];
        handsBtn.hidden = true;
        [handsBtn addTarget:self action:@selector(rightBottomViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        handsBtn.tag = 11;
        [contentView addSubview:handsBtn];
        [handsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rotateBtn.mas_right);
            make.bottom.mas_equalTo(rotateBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        
        _rightBottomBtnsView = contentView;
        
    }
    return _rightBottomBtnsView;

}
- (UIButton *)handsupBtn {
    
    return [self.rightBottomBtnsView viewWithTag:11];
    
}
- (UIButton *)createControlButtonWithIcon:(NSString *)icon {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:[NSBundle living_loadImageWithName:[NSString stringWithFormat:@"%@-close@3x",icon]] forState:UIControlStateNormal];
    [btn setImage:[NSBundle living_loadImageWithName:[NSString stringWithFormat:@"%@-open@3x",icon]] forState:UIControlStateSelected];
    [btn setImage:[NSBundle living_loadImageWithName:[NSString stringWithFormat:@"%@-ban@3x",icon]] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(rightBottomViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIStackView *)landscapeBtnsCiew {
    
    if (!_landscapeBtnsCiew) {
        _landscapeBtnsCiew = [[UIStackView alloc] init];
        _landscapeBtnsCiew.axis = UILayoutConstraintAxisHorizontal;
        _landscapeBtnsCiew.distribution = UIStackViewDistributionEqualSpacing;
        
        NSArray *icons = @[@"living-landscape-chat@3x",@"living-landscape-QA@3x",@"living-landscape-member@3x",@"living-landscape-notice@3x",@"living-landscape-setting@3x"];
        for (NSString *icon in icons) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage living_imageWithNamed:icon] forState:UIControlStateNormal];
            btn.tag = [icons indexOfObject:icon];
            [btn addTarget:self action:@selector(landscapeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.bounds = CGRectMake(0, 0, 50, 50);
            [_landscapeBtnsCiew addArrangedSubview:btn];
            
        }
        
    }
    return _landscapeBtnsCiew;
    
}

- (TUIInputController *)inputVC {
    
    if (!_inputVC) {
        
        _inputVC = [[TUIInputController alloc] init];
        _inputVC.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _inputVC.delegate = self;
        _inputVC.view.backgroundColor = UIColor.whiteColor;
        
    }
    return _inputVC;
    
}

- (NCNLiveLansacpeMaskView *)landscapeMaskView {
    
    if (!_landscapeMaskView) {
        _landscapeMaskView = [NCNLiveLansacpeMaskView new];
        _landscapeMaskView.hidden = true;
    }
    return _landscapeMaskView;
    
}

- (TIMConversation *)teacherConversaction {
    
    TIMConversation *conversation = [TIMManager.sharedInstance getConversation:TIM_C2C receiver:NCNLivingSDK.shareInstance.teacherId];
    return conversation;
}
    
- (BOOL)canBecomeFirstResponder {
    
    return true;
}
- (void)copyMessageAction {
    
    [self.chatView.getChatView copyMessageAction];
    
}

- (void)revokeMessageAction {
    [self.chatView.getChatView revokeMessageAction];

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end


@implementation NCNLivingRoomModel


+ (instancetype)liveRoomModelWithDict:(NSDictionary *)dict {
    
    NCNLivingRoomModel *model = [NCNLivingRoomModel new];
    
    
    model.teacherId = dict[@"cml"][@"teachers"];
    model.groupChatId = dict[@"cml"][@"id"];
    model.studentSignIdentifier = dict[@"token"];
    model.groupCodeId = dict[@"cml"][@"id"];
    model.courseDesc = dict[@"cml"][@"lessonName"];
    model.teacherName = dict[@"cml"][@"teachersName"];
    model.liveRoomId = dict[@"cml"][@"liveRoom"];
    model.liveAppid = [dict[@"trtcAppId"] intValue];
    model.liveUserSign = dict[@"trtcSig"];
    model.tc_liveRoomid = [model.groupChatId intValue];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
- (NSString *)teacherName {
    
    if (_teacherName.classForCoder == NSNull.class) {
        return @"";
    }
    
    return _teacherName;
    
}

- (NSString *)courseDesc {
    
    if (_courseDesc.classForCoder == NSNull.class) {
        return @"";
    }
    return _courseDesc;
    
}

@end
