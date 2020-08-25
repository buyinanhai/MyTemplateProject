//
//  TUIKit.h
//  TUIKit
//
//  Created by kennethmiao on 2018/10/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//
/** 腾讯云 TUIKit
 *
 *
 *  本类依赖于腾讯云 IM SDK 实现
 *  TUIKit 中的组件在实现 UI 功能的同时，调用 IM SDK 相应的接口实现 IM 相关逻辑和数据的处理
 *  您可以在TUIKit的基础上做一些个性化拓展，即可轻松接入IM SDK
 *
 *
 */

#import <Foundation/Foundation.h>
#import "THeader.h"
#import <ImSDK/ImSDK.h>

/**
 *  TUIKit用户状态枚举
 *
 *  TUser_Status_ForceOffline   用户被强制下线
 *  TUser_Status_ReConnFailed   用户重连失败
 *  TUser_Status_SigExpired     用户身份（usersig）过期
 */
typedef NS_ENUM(NSUInteger, TUIUserStatus) {
    TUser_Status_ForceOffline,
    TUser_Status_ReConnFailed,
    TUser_Status_SigExpired,
};

/**
 *  TUIKit网络状态枚举
 *
 *  TNet_Status_Succ        连接成功
 *  TNet_Status_Connecting  正在连接
 *  TNet_Status_ConnFailed  连接失败
 *  TNet_Status_Disconnect  断开链接
 */
typedef NS_ENUM(NSUInteger, TUINetStatus) {
    TNet_Status_Succ,
    TNet_Status_Connecting,
    TNet_Status_ConnFailed,
    TNet_Status_Disconnect,
};


//notification
#define TUIKitNotification_TIMRefreshListener @"TUIKitNotification_TIMRefreshListener"
#define TUIKitNotification_TIMMessageListener @"TUIKitNotification_TIMMessageListener"
#define TUIKitNotification_TIMMessageRevokeListener @"TUIKitNotification_TIMMessageRevokeListener"
#define TUIKitNotification_TIMUploadProgressListener @"TUIKitNotification_TIMUploadProgressListener"
#define TUIKitNotification_TIMUserStatusListener @"TUIKitNotification_TIMUserStatusListener"
#define TUIKitNotification_TIMConnListener @"TUIKitNotification_TIMConnListener"
#define TUIKitNotification_onAddFriends @"TUIKitNotification_onAddFriends"
#define TUIKitNotification_onDelFriends @"TUIKitNotification_onDelFriends"
#define TUIKitNotification_onFriendProfileUpdate @"TUIKitNotification_onFriendProfileUpdate"
#define TUIKitNotification_onAddFriendReqs @"TUIKitNotification_onAddFriendReqs"
#define TUIKitNotification_onRecvMessageReceipts @"TUIKitNotification_onRecvMessageReceipts"
#define TUIKitNotification_onChangeUnReadCount @"TUIKitNotification_onChangeUnReadCount"

#define TUIKitNotification_onLoginSuccessful @"TUIKitNotification_onLoginSuccessful"
/**
 群公告修改
 */
#define TUIKitNotification_onGroupInfoChanged_Announcement @"TUIKitNotification_onGroupInfoChanged_Announcement" 

@class NCCustomeElemMSG;
@interface NCIMManager : NSObject
@property (nonatomic, strong) TIMUserProfile *myselfProfile;
@property (nonatomic, strong) TIMUserProfile *teacherProfile;

@property (nonatomic, copy) NSString *accountID;
@property (nonatomic, copy) NSString *password;


/**
 在线成员列表刷新
 {
     liveRoomId = 41557701a2ac4966b1c61f29635f3f3a;
     platform = ios;
     socketId = "YvS7Hn9-qcWpiU20AAAN";
     userId = 3050383;
 }
 */
@property (nonatomic, copy) void(^liveRoomUsersRefreshedCallback)(NSArray<NSDictionary *> *users);
/**
 同一账号在另外一台设备进入直播间
 */
@property (nonatomic, copy) void(^liveRoomSameUserEnterCallback)(void);
/**
 *  共享实例
 */
+ (instancetype)sharedInstance;

/**
 *  设置sdkAppId，以便您能进一步接入IM SDK
 */
- (void)setupWithAppId:(NSInteger)sdkAppId;

- (void)startLoginForIM;

- (void)logoutForIM;

/**
 socketIO 的连接
 */
- (void)connectLiveRoom;
/**
socketIO 的断开连接
*/
- (void)disConectLiveRoom;

/**
 *  设置sdkAppId，logLevel
 */
- (void)setupWithAppId:(NSInteger)sdkAppId logLevel:(TIMLogLevel)logLevel;

/**
 表情组
 */
- (NSArray *)faceGroups;

- (NSArray<NSDictionary *> *)getOnlineUsers;

- (TUINetStatus)netStatus;
@end
