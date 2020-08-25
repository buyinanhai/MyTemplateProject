//
//  NCLivePullView.m
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/11.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCLivePullView.h"
#import "TXLivePlayer.h"
#import <AFNetworking/AFNetworking.h>
#import "TRTCCloud.h"
@interface NCLivePullView ()<TXLivePlayListener>
@property (nonatomic, copy) NSString *teacherRTMP;

@property (nonatomic, strong) TXLivePlayer *player;

@property (nonatomic, strong) TXView *showView;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, assign) TX_Enum_PlayType playType;


@end

@implementation NCLivePullView {
    ///是否正方播放RTC教师流
    BOOL _isPlayRemoteStream;
    
}

+ (instancetype)pullViewWithLiveRoom:(NSString *)url {
    
    
    NCLivePullView *view = [NCLivePullView new];
    view.teacherRTMP = url;
    [view preparePullStreaming];
    [view setupSubview];
    return view;
}

- (void)preparePullStreaming {
    
    // 创建播放器
    _player = [[TXLivePlayer alloc] init];
    
    [_player setRenderMode:RENDER_MODE_FILL_EDGE];
    TXLivePlayConfig* config = _player.config;
    // 开启 flvSessionKey 数据回调
    //config.flvSessionKey = @"X-Tlive-SpanId";
    // 允许接收消息
    config.enableMessage = YES;
    [_player setConfig:config];
    _player.delegate = self;
    
    
     
}

- (void)setupSubview {
    
    [self addSubview:self.activityView];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    [self addSubview:self.showView];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.size.offset(35);
        make.left.offset(10);
    }];
    self.playBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.hidden = true;
    //去除默认的上下扫手势
    [super prepareZoomToSmallFrame:CGRectZero];
}

- (void)playBtnClick:(UIButton *)sender {
    
    if (![self checkPlayUrl]) {
        return;
    }
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        [self.player setDelegate:self];
        [self.player setupVideoWidget:CGRectZero containView:self.showView insertIndex:0];
        [self.player startPlay:self.teacherRTMP type:_playType];
    } else {
        if (self.player.isPlaying) {
            [self.player pause];
        } else {
            [self.player stopPlay];
        }
    }
    
}

- (BOOL)checkPlayUrl {
      
    NSString *playUrl = self.teacherRTMP;
    if ([playUrl hasPrefix:@"rtmp:"]) {
        _playType = PLAY_TYPE_LIVE_RTMP;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && ([playUrl rangeOfString:@".flv"].length > 0)) {
        _playType = PLAY_TYPE_LIVE_FLV;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && [playUrl rangeOfString:@".m3u8"].length > 0) {
        _playType = PLAY_TYPE_VOD_HLS;
    } else{
        [self toastTip:@"播放地址不合法，直播目前仅支持rtmp,flv播放方式!"];
        return false;
    }
       
    return true;
    
}



- (UIView *)stopTeacherLivingToPlayRemoteLiving {
    
    [self stop];
    _isPlayRemoteStream = true;
    self.playBtn.hidden = true;
    self.playBtn.enabled = false;
    return self.showView;
}
- (void)replayTeacherLiving {
    
    _isPlayRemoteStream = false;
    self.playBtn.selected = false;
    [self start];
    if (self.oritention == NCLivingViewOritention_landscape) {
        self.playBtn.hidden = false;
    }
    self.playBtn.enabled = true;
    
}
- (void)prepareToChangeFrame:(CGRect)frame {
    
//    [self.player setupVideoWidget:<#(CGRect)#> containView:<#(TXView *)#> insertIndex:<#(unsigned int)#>]
//    self.moviePlayer.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//   [UIView animateWithDuration:0.25 animations:^{
//   } completion:^(BOOL finished) {
//
//   }];
}
- (void)prepareZoomToBigFrame:(CGRect)frame {
    [self prepareToChangeFrame:frame];
    if (_isPlayRemoteStream) {
        return;
    }
    self.playBtn.hidden = false;
}

- (void)prepareZoomToSmallFrame:(CGRect)frame {
    [self prepareToChangeFrame:frame];
    self.playBtn.hidden = true;

}
- (void)prepareRatateOritentionLandscape {
    if (self.oritention == NCLivingViewOritention_landscape) return;

    [super prepareRatateOritentionLandscape];

    if (self.state == NCLivingViewStateBig) {
        CGFloat landscapeHeight = kScreen_Height;
        
        
        CGFloat scale = landscapeHeight / self.portraitFrame.size.height;
        
        CGFloat width =  self.portraitFrame.size.width * scale;
        
        CGFloat x = (kScreen_Width - width) * 0.5;
        
        [self prepareToChangeFrame:CGRectMake(x, 0,width, self.portraitFrame.size.height * scale)];
    }
    self.oritention = NCLivingViewOritention_landscape;
    
}
- (void)prepareRatateOritentionPortrait {
    if (self.oritention == NCLivingViewOritention_portrait) return;

    [super prepareRatateOritentionPortrait];
    if (self.state == NCLivingViewStateBig) {
        [self prepareToChangeFrame:CGRectMake(0, 0, self.portraitFrame.size.width, self.portraitFrame.size.height)];
    }
  
    
    self.oritention = NCLivingViewOritention_portrait;

}



- (void)initObserver
{
   
}

- (void)pause {
    
    [self.player pause];
}

- (void)start {
  
    [self playBtnClick:self.playBtn];
    
}

- (void)stop {
    
    if (_player) {
        [_player setDelegate:nil];
        [_player removeVideoWidget];
        [_player stopPlay];
    }
    
}

#pragma mark play listener
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    NSDictionary *dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            [self.activityView stopAnimating];
            
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END) {
            // 断开连接时，模拟点击一次关闭播放
            [self playBtnClick:self.playBtn];
            
            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
                NSString *msg = (NSString*)[dict valueForKey:EVT_MSG];
                [YJProgressHUD showMessage:msg inView:UIApplication.sharedApplication.keyWindow];
            }
            
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
            [self.activityView startAnimating];
            
        } else if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            [self.activityView stopAnimating];
            self.playBtn.selected = true;
            BOOL isWifi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
            if (!isWifi) {
                self.playBtn.selected = true;
                __weak __typeof(self) weakSelf = self;
                [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                    if (weakSelf.teacherRTMP.length == 0) {
                        return;
                    }
                    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                       message:@"您要切换到Wifi再观看吗?"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            
                            // 先停止，再重新播放
                            [weakSelf stop];
                            [weakSelf start];
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                        }]];
                        [weakSelf.belongVC presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }
        }
        else if (EvtID == PLAY_EVT_GET_MESSAGE) {
            NSData *msgData = param[@"EVT_GET_MSG"];
            NSString *msg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
            [YJProgressHUD showMessage:msg inView:UIApplication.sharedApplication.keyWindow];
        }
        /*
         7.2 新增
        else if (EvtID == PLAY_EVT_GET_FLVSESSIONKEY) {
            //NSString *Msg = (NSString*)[dict valueForKey:EVT_MSG];
            //[self toastTip:[NSString stringWithFormat:@"event PLAY_EVT_GET_FLVSESSIONKEY: %@", Msg]];
        }
         */
    });
}

- (void)onNetStatus:(NSDictionary *)param {
    
}



- (UIButton *)playBtn {
    
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage living_imageWithNamed:@"play@3x"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage living_imageWithNamed:@"pause@3x"] forState:UIControlStateSelected];

    }
    return _playBtn;
    
}

- (TXView *)showView {
    
    if (!_showView) {
        _showView = [TXView new];
    }
    return _showView;
    
}


- (void)dealloc {
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
