//
//  NCPushLiveView.m
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/11.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCLivePushView.h"
#import <AFNetworking/AFNetworking.h>
#import "TRTCCloud.h"
#import <AVKit/AVKit.h>


@interface NCLivePushView ()<TRTCCloudDelegate>

@property (nonatomic, copy) NSString *streamURL;

@property (nonatomic, strong) TXView *showView;


@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *micphoneBtn;


@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation NCLivePushView {
    
    UInt32 _appid;
    UInt32 _roomid;
    NSString *_userSign;
    
    BOOL _currentCameraPosition;
    
    
}


+ (instancetype)pushViewWithLiveRoom:(NSString *)url appid:(UInt32)appid userSign:(nonnull NSString *)sign roomId:(UInt32)roomid {
    
    NCLivePushView *view = [NCLivePushView new];
    view.streamURL = url;
    [view setupSubview];
    view->_appid = appid;
    view->_roomid = roomid;
    view->_userSign = sign;
    [view prepareForPushStream];
    return view;
}

- (void)setupSubview {
       
    [self insertSubview:self.showView atIndex:0];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.top.bottom.offset(0);
        make.width.equalTo(self).multipliedBy(0.4);
//        make.edges.offset(0);
    }];
    [self addSubview:self.cameraBtn];
    [self addSubview:self.micphoneBtn];
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.size.offset(20);
    }];
    [self.micphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.size.offset(20);
    }];
    
//    [self addSubview:self.playBtn];
//    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.bottom.offset(0);
//        make.size.offset(35);
//    }];
//    self.playBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    [self.playBtn addTarget:self action:@selector(clickPush:) forControlEvents:UIControlEventTouchUpInside];
//    self.playBtn.hidden = true;
    
    //去除默认的上下扫手势
    [super prepareZoomToSmallFrame:CGRectZero];


}

- (void)prepareForPushStream {
    
    TRTCCloud.sharedInstance.delegate = self;
    TRTCParams *params = [TRTCParams new];
    [params setSdkAppId:_appid];
    [params setUserSig:_userSign];
    params.role = TRTCRoleAnchor;
    params.roomId = _roomid;
    params.userId = kLivingConfig.stuId;
  
    params.streamId =  [NSString stringWithFormat:@"%d_%d_%@_main",_appid,_roomid,params.userId];
    [[self cloud] enterRoom:params appScene:TRTCAppSceneLIVE];
    
    
    TRTCVideoEncParam *videoParam = [TRTCVideoEncParam new];
    videoParam.resMode = TRTCVideoResolution_480_270;
    videoParam.videoFps = 15;
    videoParam.videoBitrate = 550;
    videoParam.resMode = self.oritention == NCLivingViewOritention_portrait ? TRTCVideoResolutionModePortrait : TRTCVideoResolutionModeLandscape;
    [TRTCCloud.sharedInstance setVideoEncoderParam:videoParam];
    
    TXBeautyManager *manager = TRTCCloud.sharedInstance.getBeautyManager;
    
    [manager setBeautyStyle:TXBeautyStyleNature];
    [manager setBeautyLevel:5];
    [manager setWhitenessLevel:2];
    
    _currentCameraPosition = kLivingSettingConfig.capturePosition;
   
    
//    [self.pusher setDelegate:self];
//    [self.pusher startPreview:self.showView];
    
   
}
- (void)prepareZoomToBigFrame:(CGRect)frame {
    [super prepareZoomToBigFrame:frame];
    self.playBtn.hidden = false;
}
- (void)prepareZoomToSmallFrame:(CGRect)frame {
    [super prepareZoomToSmallFrame:frame];
    self.playBtn.hidden = true;
}

- (void)startToLive {
    
    [self requestAccessForCameraCompletionHandler:^{
        [self start];
    }];

}

#pragma mark - 请求相机权限
- (void)requestAccessForCameraCompletionHandler:(void (^)(void))handler
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
               
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    if (granted) {
                        if (handler) {
                            handler();
                        }
                        
                    } else {
                        // 无权限 做一个友好的提示
                        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
                        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
                        NSString *message = [NSString stringWithFormat:@"请在\"设置-隐私-相机\"中允许%@访问麦克风",appName];
                        [self showAlertWithTitle:nil cancelTitle:@"设置" message:message complete:^{
                            if (@available(iOS 8.0, *)){
                                if (@available(iOS 10.0, *)){
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                } else {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                }
                            } else {
                                NSString *message = @"无法跳转到隐私设置页面，请手动前往设置页面，谢谢";
                                [self showAlertWithTitle:@"设置" cancelTitle:@"取消" message:message complete:^{
                                    
                                }];
                            }
                        }];
                        
                    }
                }];
                
            } else {
                // 无权限 做一个友好的提示
                NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
                if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
                NSString *message = [NSString stringWithFormat:@"请在\"设置-隐私-相机\"中允许%@访问相机",appName];
                [self showAlertWithTitle:nil cancelTitle:@"设置" message:message complete:^{
                    if (@available(iOS 8.0, *)){
                        if (@available(iOS 10.0, *)){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                        } else {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }
                    } else {
                        NSString *message = @"无法跳转到隐私设置页面，请手动前往设置页面，谢谢";
                        [self showAlertWithTitle:@"设置" cancelTitle:@"取消" message:message complete:^{
                            
                        }];
                    }
                }];
            }
        });
    }];
}
- (void)showAlertWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle message:(NSString *)message complete:(void (^)(void))complete
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (complete) {
            complete();
        }
    }]];
    [self.superview.mm_viewController presentViewController:alertController animated:true completion:nil];
}

- (void)stopToLive {
    [TRTCCloud.sharedInstance stopRemoteView:self.teacherID];
    [TRTCCloud.sharedInstance exitRoom];
    [TRTCCloud.sharedInstance stopLocalAudio];
    [TRTCCloud.sharedInstance stopLocalPreview];
    [TRTCCloud.sharedInstance stopPublishing];
    [TRTCCloud destroySharedIntance];
}

- (void)openMircphone:(BOOL)isOpen {
    
    isOpen ? [[self cloud] startLocalAudio] : [[self cloud] stopLocalAudio];
    self.micphoneBtn.selected = !isOpen;
    
}
- (void)openCamera:(BOOL)isOpen {
    
    isOpen ? [[self cloud] startLocalPreview:!kLivingSettingConfig.capturePosition view:self.showView] : [[self cloud] stopLocalPreview];
//    if (isOpen) {
//        [self.pusher pausePush];
//    } else {
//        [self.pusher resumePush];
//    }
    self.showView.hidden = !isOpen;
    self.cameraBtn.selected = !isOpen;
   
//    [self.session setCaptureDevicePosition:isOpen ? AVCaptureDevicePositionUnspecified : self.capturePosition];
}

- (void)openBeauty:(BOOL)isOpen {
    
    [[[self cloud] getBeautyManager] setFaceBeautyLevel:isOpen ? 5 : 0];
//    [self.pusher.getBeautyManager setBeautyLevel:isOpen ? 5 : 0];
}

- (void)changeCapturePosition:(BOOL)position {
    if (position != _currentCameraPosition) {
        [[self cloud] switchCamera];
        _currentCameraPosition = position;
    }
}

- (void)pause {
    
    
}

- (void)start {
    
    [self startPush];
}

- (void)stop {
    
//    [self.session stopLive];
    [self stopToLive];
    
}

#pragma mark - 推流逻辑

- (BOOL)startPush {

        
    [TRTCCloud.sharedInstance startLocalAudio];
    [TRTCCloud.sharedInstance startLocalPreview:!_currentCameraPosition view:self.showView];
    if (self.teacherShowView && self.teacherID.length > 0) {
        [[self cloud] startRemoteView:self.teacherID view:self.teacherShowView];
    }
    [self openMircphone:kLivingSettingConfig.isOpenMicrophone];
    [self openCamera:kLivingSettingConfig.isOpenCamera];
    [self openBeauty:kLivingSettingConfig.isOpenBeauty];

    return YES;
}


- (void)stopPush {
    
    
}


- (void)prepareToChangeFrame:(CGRect)frame {
    
    
}

- (void)prepareRatateOritentionLandscape {
    if (self.oritention == NCLivingViewOritention_landscape) return;

    
    [super prepareRatateOritentionLandscape];
    
    
    [self videoIsHorizontal:true];

    
    self.oritention = NCLivingViewOritention_landscape;


}

- (void)prepareRatateOritentionPortrait {
    if (self.oritention == NCLivingViewOritention_portrait) return;
    
    [super prepareRatateOritentionPortrait];

   
    [self videoIsHorizontal:false];

    
    self.oritention = NCLivingViewOritention_portrait;
    
}

- (void)videoIsHorizontal:(BOOL)isH {
    
    
    if (isH) {

        TRTCVideoEncParam *videoParam = [TRTCVideoEncParam new];
        videoParam.resMode = TRTCVideoResolution_480_270;
        videoParam.videoFps = 15;
        videoParam.videoBitrate = 550;
        videoParam.resMode = TRTCVideoResolutionModeLandscape;
        [TRTCCloud.sharedInstance setVideoEncoderParam:videoParam];
        [[self cloud] setVideoEncoderRotation:TRTCVideoRotation_90];
//        self.showView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.showView mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height).multipliedBy(kDrawAspectRatio);
            make.center.offset(0);
        }];
    } else {
        TRTCVideoEncParam *videoParam = [TRTCVideoEncParam new];
        videoParam.resMode = TRTCVideoResolution_480_270;
        videoParam.videoFps = 15;
        videoParam.videoBitrate = 550;
        videoParam.resMode = TRTCVideoResolutionModePortrait;
        [TRTCCloud.sharedInstance setVideoEncoderParam:videoParam];
        [[self cloud] setVideoEncoderRotation:TRTCVideoRotation_0];
//        self.showView.transform = CGAffineTransformIdentity;
        [self.showView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.center.top.bottom.offset(0);
               make.width.equalTo(self).multipliedBy(0.4);
           }];
    }
    
}

- (void)clickPush:(UIButton *)btn {
    if (btn.isSelected) {
       
        [self start];
        self.playBtn.selected = false;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
    } else {
        [self stop];
        self.playBtn.selected = true;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}



#pragma mark push listener
//- (void)onPushEvent:(int)evtID withParam:(NSDictionary *)param {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (evtID == PUSH_ERR_NET_DISCONNECT || evtID == PUSH_ERR_INVALID_ADDRESS) {
//            // 断开连接时，模拟点击一次关闭推流
//            [self clickPush:self.playBtn];
//
//        } else if (evtID == PUSH_ERR_OPEN_CAMERA_FAIL) {
//            [self clickPush:self.playBtn];
//            [self toastTip:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限"];
//
//        } else if (evtID == PUSH_EVT_OPEN_CAMERA_SUCC) {
//            [self.pusher toggleTorch:false];
//
//        } else if (evtID == PUSH_ERR_OPEN_MIC_FAIL) {
//            [self clickPush:self.playBtn];
//            [self toastTip:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限"];
//
//        } else if (evtID == PUSH_EVT_CONNECT_SUCC) {
//            [self openMircphone:kLivingSettingConfig.isOpenMicrophone];
//            [self openCamera:kLivingSettingConfig.isOpenCamera];
//            [self openBeauty:kLivingSettingConfig.isOpenBeauty];
//            [self changeCapturePosition:kLivingSettingConfig.capturePosition];
//            [self.pusher setMirror:true];
//            BOOL isWifi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
//            if (!isWifi) {
//                __weak __typeof(self) weakSelf = self;
//                [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//                    if (weakSelf.streamURL.length == 0) {
//                        return;
//                    }
//                    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
//                                                                                       message:@"您要切换到WiFi再推流吗?"
//                                                                                preferredStyle:UIAlertControllerStyleAlert];
//                        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//                            [alert dismissViewControllerAnimated:YES completion:nil];
//
//                            // 先暂停，再重新推流
//                            [weakSelf.pusher stopPush];
//                            [weakSelf.pusher startPush:weakSelf.streamURL];
//                        }]];
//                        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
//                            [alert dismissViewControllerAnimated:YES completion:nil];
//                        }]];
//                        [weakSelf.belongVC presentViewController:alert animated:YES completion:nil];
//                    }
//                }];
//            }
//        } else if (evtID == PUSH_WARNING_NET_BUSY) {
//            [self toastTip:@"您当前的网络环境不佳，请尽快更换网络保证正常直播"];
//        }
//
//    });
//}



#pragma mark  TRTCCloudDelegate


- (void)onEnterRoom:(NSInteger)result {
    
    //进房失败的错误码含义请参见[错误码](https://cloud.tencent.com/document/product/647/32257)
    
    if (result < 0) {
        NSLog(@"trtc 直播失败 code == %ld",(long)result);
    } else {
        
        NSLog(@"推流进入房间成功------");
    }
    
}

- (void)onExitRoom:(NSInteger)reason {
    
    
    
}
- (void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(NSDictionary *)extInfo {
    
    NSLog(@"直播时发生错误  code == %d   msg == %@",errCode, errMsg);
    
}

- (void)onWarning:(TXLiteAVWarning)warningCode warningMsg:(NSString *)warningMsg extInfo:(NSDictionary *)extInfo {
    
    NSLog(@"**************%@", warningMsg);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIButton *)playBtn {
    
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage living_imageWithNamed:@"play@3x"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage living_imageWithNamed:@"pause@3x"] forState:UIControlStateSelected];

    }
    return _playBtn;
    
}

- (UIView *)showView {
    
    if (!_showView) {
        _showView = [UIView new];
    }
    return _showView;
}

- (UIButton *)cameraBtn {
    
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setImage:[UIImage living_imageWithNamed:@"camera-open@3x"] forState:UIControlStateNormal];
        [_cameraBtn setImage:[UIImage living_imageWithNamed:@"camera-close@3x"] forState:UIControlStateSelected];
    }
    return _cameraBtn;
    
}

- (UIButton *)micphoneBtn {
    
    if (!_micphoneBtn) {
        _micphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_micphoneBtn setImage:[UIImage living_imageWithNamed:@"micphone-open@3x"] forState:UIControlStateNormal];
        [_micphoneBtn setImage:[UIImage living_imageWithNamed:@"micphone-close@3x"] forState:UIControlStateSelected];
    }
    return _micphoneBtn;
    
}


- (TRTCCloud *)cloud {
    
    return TRTCCloud.sharedInstance;
}
@end
