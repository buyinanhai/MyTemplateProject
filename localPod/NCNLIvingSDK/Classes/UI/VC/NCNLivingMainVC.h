//
//  NCNLivingMainVC.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/24.
//  Copyright © 2020 子宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 直播主控制器
 */

@interface NCNLivingRoomModel : NSObject

@property (nonatomic, copy) NSString *studentId;

@property (nonatomic, copy) NSString *teacherId;
//腾讯IM登录密码
@property (nonatomic, copy) NSString *studentSignIdentifier;

@property (nonatomic, copy) NSString *liveRoomId;

@property (nonatomic, copy) NSString *groupChatId;

@property (nonatomic, copy) NSString *groupCodeId;

@property (nonatomic, copy) NSString *courseDesc;

@property (nonatomic, copy) NSString *subject;

@property (nonatomic, copy) NSString *teacherName;

///trtc 推流用的appid
@property (nonatomic, assign) UInt32 liveAppid;
///trtc 推流用的房间号  同聊天群一致
@property (nonatomic, assign) UInt32 tc_liveRoomid;
///trtc 推流用的密码
@property (nonatomic, copy) NSString *liveUserSign;

///im appid
@property (nonatomic, copy) NSString *IM_appId;


+ (instancetype)liveRoomModelWithDict:(NSDictionary *)dict;

@end

@interface NCNLivingMainVC : UIViewController

+ (instancetype)livingMainVCWithRoomModel:(NCNLivingRoomModel *)model;

@end

NS_ASSUME_NONNULL_END
