//
//  TUIKit.m
//  TUIKit
//
//  Created by kennethmiao on 2018/10/12.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "NCIMManager.h"
#import "THeader.h"
#import "tuimenucell.h"
#import "tuifacecell.h"
#import "tuifaceview.h"
#import "NSTimer+dy_extension.h"
#import <SocketIO/SocketIO-Swift.h>
@interface NCIMManager () <TIMMessageListener, TIMConnListener, TIMMessageUpdateListener,TIMMessageReceiptListener,TIMMessageRevokeListener,TIMUploadProgressListener,TIMGroupEventListener>
@property (nonatomic) TUINetStatus netStatus;

@property (nonatomic, strong) NSArray<TMenuCellData *> *faceGroups;


@property (nonatomic, strong) NSTimer *heartTimer;

@property (nonatomic, strong) SocketIOClient *socketIO;

@property (nonatomic, strong) SocketManager *socketManager;

@property (nonatomic, copy) NSArray<NSDictionary *> * onlineUsers;


@end

@implementation NCIMManager {
    
    NSInteger _heartInterval;
}

+ (instancetype)sharedInstance
{
    static NCIMManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NCIMManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)connectLiveRoom {
    
    NSString *urlstr = [NSString stringWithFormat:@"http://114.116.146.138:8995"];
    NSURL* url = [[NSURL alloc] initWithString:urlstr];
    self.socketManager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @NO, @"compress": @YES,@"connectParams":@{@"userId":NCNLivingSDK.shareInstance.studentId,@"liveRoomId":NCNLivingSDK.shareInstance.liveRoomId,@"platform": @"ios"}}];
    SocketIOClient* socket = [self.socketManager defaultSocket];
    
  [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
      NSLog(@"socket connected");
  }];
    [socket on:@"connecting" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull emitter) {
        NSLog(@"%@",dataArray);
        
    }];

    [socket on:@"connect_failed" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull emitter) {
        NSLog(@"%@",dataArray);
        
    }];

    [socket on:@"error" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull emitter) {
        NSLog(@"%@",dataArray);
        
    }];


  [socket on:@"getUsers" callback:^(NSArray *data, SocketAckEmitter* ack) {
      
      if (data.count > 0) {
          if (self.liveRoomUsersRefreshedCallback) {
              self.liveRoomUsersRefreshedCallback(data.firstObject);
          }
          self.onlineUsers = data.firstObject;
      }
  }];

    [socket on:@"conflict" callback:^(NSArray<NSDictionary *> *data, SocketAckEmitter* ack) {
        NSLog(@"同一账号在另外一台设备上登录了。。。。。。");
        if (self.liveRoomSameUserEnterCallback) {
            self.liveRoomSameUserEnterCallback();
        }
        [self.socketIO disconnect];
    }];
    self.socketIO = socket;
  [socket connect];
    
    
    
}
- (void)disConectLiveRoom {
    
    [self.socketIO disconnect];
}


- (void)setupWithAppId:(NSInteger)sdkAppId
{
    TIMSdkConfig *sdkConfig = [[TIMSdkConfig alloc] init];
    sdkConfig.sdkAppId = (int)sdkAppId;
    sdkConfig.dbPath = TUIKit_DB_Path;
    sdkConfig.connListener = self;
    int result = [[TIMManager sharedInstance] initSdk:sdkConfig];
    if (result == 0) {
        NSLog(@"IMSDK 初始化成功！！");
    } else {
        NSLog(@"IMSDK 初始化失败！！");
    }
    [[TIMManager sharedInstance] addMessageListener:self];
    [self setUserConfig];
}

- (void)setupWithAppId:(NSInteger)sdkAppId logLevel:(TIMLogLevel)logLevel
{
    TIMSdkConfig *sdkConfig = [[TIMSdkConfig alloc] init];
    sdkConfig.sdkAppId = (int)sdkAppId;
    sdkConfig.dbPath = TUIKit_DB_Path;
    sdkConfig.logLevel = logLevel;
    sdkConfig.connListener = self;
    [[TIMManager sharedInstance] initSdk:sdkConfig];
    [[TIMManager sharedInstance] addMessageListener:self];
    [self setUserConfig];
}

- (void)setUserConfig
{
    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
    userConfig.disableAutoReport = YES;
//    userConfig.refreshListener = self;
    userConfig.messageRevokeListener = self;
    userConfig.uploadProgressListener = self;
    userConfig.groupEventListener = self;
//    userConfig.userStatusListener = self;
//    userConfig.friendshipListener = self;
    userConfig.messageUpdateListener = self;
//    userConfig.messageReceiptListener = self;
    [[TIMManager sharedInstance] setUserConfig:userConfig];
}

- (void)onRefreshConversations:(NSArray *)conversations
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMRefreshListener object:conversations];
}

- (void)startLoginForIM {

    NSAssert(self.accountID.length > 0, @"NCNLivingSDK 缺少IM 登录账号");
    NSAssert(self.password.length > 0, @"NCNLivingSDK  缺少IM 登录密码");

    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    [param setIdentifier:self.accountID];
    param.userSig = self.password;
    
//    param.userSig = @"eJyrVgrxCdZLrSjILEpVslIyNDU1NTIwUNIBC5elFgHFjPRg/OKU7MSCgswUJStDEwMDYyNzQ2MjiExmSmpeSWZaJliDsYGpgbGFMUxTZjpQrDIipdTfLay8MCy5JLMsJK0oKt+3PCnfIMDT1UXfPaLQJDxd38K8RNvEL9IWqrEkMxfoJENTC0tLEzNjY9NaAGevMS0=";
    //    param.userSig = [GenerateTestUserSig genTestUserSig:NCNLivingSDK.shareInstance.studentId];
    
    int result = [TIMManager.sharedInstance login:param succ:^{
        NSLog(@"IM login successful~~~~~");
        //登录成功后加入群聊
      
        [TIMManager.sharedInstance.friendshipManager getSelfProfile:^(TIMUserProfile *profile) {
            NCIMManager.sharedInstance.myselfProfile = profile;
        } fail:^(int code, NSString *msg) {
            
        }];
        [TIMManager.sharedInstance.friendshipManager getUsersProfile:@[NCNLivingSDK.shareInstance.teacherId] forceUpdate:false succ:^(NSArray<TIMUserProfile *> *profiles) {
            
            self.teacherProfile = profiles.firstObject;
            
        } fail:^(int code, NSString *msg) {
            
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onLoginSuccessful object:nil];
        
    } fail:^(int code, NSString *msg) {
        NSLog(@"IM  login failed  errormsg=%d errordesc=%@", code, msg);
    }];
    
    NSLog(@"登录初始化状态 %d", result);
    NSLog(@"当前IM登录状态 %ld",(long)TIMManager.sharedInstance.getLoginStatus);
    
    
}

- (void)logoutForIM {
    
    [TIMManager.sharedInstance logout:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
    self.accountID = nil;
    self.password = nil;
    self.teacherProfile = nil;
}

#pragma mark - TIMMessageListener
- (void)onNewMessage:(NSArray *)msgs
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMMessageListener object:msgs];
}

- (void)onRevokeMessage:(TIMMessageLocator *)locator
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMMessageRevokeListener object:locator];
}

- (void) onRecvMessageReceipts:(NSArray*)receipts
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onRecvMessageReceipts object:receipts];
}

- (void)onUploadProgressCallback:(TIMMessage *)msg elemidx:(uint32_t)elemidx taskid:(uint32_t)taskid progress:(uint32_t)progress
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"message", [NSNumber numberWithInt:progress], @"progress", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMUploadProgressListener object:dic];
}
- (void)onGroupTipsEvent:(TIMGroupTipsElem *)elem {
    
    if (elem.type == TIM_GROUP_TIPS_TYPE_INFO_CHANGE) {
        
        [elem.groupChangeList enumerateObjectsUsingBlock:^(TIMGroupTipsElemGroupInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.type == TIM_GROUP_INFO_CHANGE_GROUP_NOTIFICATION) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onGroupInfoChanged_Announcement object:obj.value];
                *stop = YES;
            }
            
        }];
       
    }
}

#pragma mark - user
- (void)onForceOffline
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMUserStatusListener object:[NSNumber numberWithInt:TUser_Status_ForceOffline]];
}

- (void)onReConnFailed:(int)code err:(NSString*)err
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMUserStatusListener object:[NSNumber numberWithInt:TUser_Status_ReConnFailed]];
}

- (void)onUserSigExpired
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMUserStatusListener object:[NSNumber numberWithInt:TUser_Status_SigExpired]];
}

#pragma mark - network

- (void)onConnSucc
{
    self.netStatus = TNet_Status_Succ;
    
}

- (void)onConnFailed:(int)code err:(NSString*)err
{
    self.netStatus = TNet_Status_ConnFailed;
}

- (void)onDisconnect:(int)code err:(NSString*)err
{
    self.netStatus = TNet_Status_Disconnect;
}

- (void)onConnecting
{
    self.netStatus = TNet_Status_Connecting;
}

- (void)setNetStatus:(TUINetStatus)netStatus
{
    _netStatus = netStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_TIMConnListener object:[NSNumber numberWithInt:netStatus]];
}

- (void)onAddFriends:(NSArray *)users
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onAddFriends object:users];
}

- (void)onDelFriends:(NSArray *)identifiers
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onDelFriends object:identifiers];
}

- (void)onFriendProfileUpdate:(NSArray *)profiles
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onFriendProfileUpdate object:profiles];
}

- (void)onAddFriendReqs:(NSArray *)reqs
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUIKitNotification_onAddFriendReqs object:reqs];
}


#pragma mark - TIMMessageUpdateListener
- (void)onMessageUpdate:(NSArray*) msgs
{

}

- (NSArray *)faceGroups {
    
    if (!_faceGroups) {
        
        NSArray *iconNames = @[@"[爱]", @"[白眼]", @"[闭嘴]", @"[大哭]", @"[大笑]", @"[愤怒]", @"[汗颜]", @"[机灵]",
        @"[惊吓]", @"[开心]", @"[恐惧]", @"[酷]", @"[困]", @"[难过]", @"[难受]", @"[亲吻]",
        @"[生病]", @"[吐舌]", @"[微笑]", @"[喜欢]", @"[喜极而泣]", @"[眼冒金星]", @"[阳光]", @"[音乐]"];
        NSMutableArray *faceGroups = [NSMutableArray array];
        //emoji group
        NSMutableArray *emojiFaces = [NSMutableArray array];
//        NSArray *emojis = [NSArray arrayWithContentsOfFile:TUIKitFace(@"emoji/emoji.plist")];
        for (int i = 0; i < 24; i++) {
            TFaceCellData *data = [[TFaceCellData alloc] init];
            NSString *path = [NSString stringWithFormat:@"%@/icons/%@",[[NSBundle ncn_sharedBundle] bundlePath],[NSString stringWithFormat:@"chat_emoticon_%d.png",i]];
            data.path = path;
            data.name = iconNames[i];
            [emojiFaces addObject:data];
        }
        if(emojiFaces.count != 0){
            TFaceGroup *emojiGroup = [[TFaceGroup alloc] init];
            emojiGroup.groupIndex = 0;
//            emojiGroup.groupPath = TUIKitFace(@"emoji/");
            emojiGroup.faces = emojiFaces;
            emojiGroup.rowCount = 3;
            emojiGroup.itemCountPerRow = 9;
            emojiGroup.needBackDelete = YES;
//            emojiGroup.menuPath = TUIKitFace(@"emoji/menu");
            [faceGroups addObject:emojiGroup];
        }
           
        _faceGroups = faceGroups.copy;
    }
    
    return _faceGroups;
    
}

- (NSArray<NSDictionary *> *)getOnlineUsers {
    
    [self.socketIO on:@"getUsers" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull emitter) {
        if (data.count > 0) {
            if (self.liveRoomUsersRefreshedCallback) {
                self.liveRoomUsersRefreshedCallback(data.firstObject);
            }
        }
    }];
    return self.onlineUsers;
}

@end
