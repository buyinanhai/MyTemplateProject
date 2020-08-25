//
//  NCNNetwork.h
//  AFNetworking
//
//  Created by 汪宁 on 2020/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//#define kBaseURL @"http://114.116.129.235:8082"

typedef void(^NetworkCompletedBlock)( NSError * _Nullable error, NSDictionary * _Nullable response);

@interface NCNNetwork : NSObject

@property (nonatomic, copy) NSString *baseURL;

+ (instancetype)shared;
/**
 获取直播间配置
 */
+ (void)getLivingRoomInitialConfigWithLiveRoomID:(NSString *)roomID completed:(NetworkCompletedBlock)completed;
/**
 获取IM指令信息
 */
+ (void)getLivingRoomIMInstructsWithLiveRoomID:(NSString *)roomID completed:(NetworkCompletedBlock)completed;

/**
 获取直播间必要参数
 */
+ (void)getLiveRoomParametersWithRoomID:(NSString *)roomID studentId:(NSString *)stuId companyId:(NSString *)companyId completed:(NetworkCompletedBlock)completed;


@end

NS_ASSUME_NONNULL_END
