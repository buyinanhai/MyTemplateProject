//
//  NCNLivingSDK.h
//  XYClassRoom
//
//  Created by 尹彦博 on 2020/4/16.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCNLiveConfig.h"
#import "NCNLivingSettingConfig.h"
NS_ASSUME_NONNULL_BEGIN


#define kLivingConfig NCNLivingSDK.shareInstance.config
#define kLivingSettingConfig NCNLivingSDK.shareInstance.settingConfig

@interface NCNLivingSDK : NSObject

@property (nonatomic, strong) NCNLiveConfig *config;

@property (nonatomic, strong) NCNLivingSettingConfig *settingConfig;

@property (nonatomic, copy) NSString *groupId;

/**
 接收指令的群
 */
@property (nonatomic, copy) NSString *groupCodeId;

@property (nonatomic, copy) NSString *studentId;

@property (nonatomic, copy) NSString *liveRoomId;


/**
 用于给老师发送问答
 */
@property (nonatomic, copy) NSString *teacherId;



+ (instancetype)shareInstance;

/**
 appid: 腾讯IM  appid
 liveAppID： 腾讯云直播 appid
 */
+ (void)setupWithTcentIM_AppID:(NSString *)appid;

/**
 每进入直播间都要初始化一次
 */
+ (void)initializeTencentLiveSDKWithAppid:(UInt32)appid sign:(NSString *)sign ;
- (void)classRoomEnded;

@end

NS_ASSUME_NONNULL_END
