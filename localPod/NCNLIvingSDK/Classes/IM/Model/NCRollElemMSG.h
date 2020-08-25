//
//  NCRollElemMSG.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCCustomeElemMSG.h"

NS_ASSUME_NONNULL_BEGIN

/**
 点名指令数据结构  已弃用
 */
@interface NCRollElemMSG : NCCustomeElemMSG

/**
 String    0 开始点名/ 1结束点名
 */
@property (nonatomic, copy) NSString *callTheRollOperation;
/**
 String    点名回应时长（S）
 */
@property (nonatomic, copy) NSString *callTheRollTime;
 
/**
 String    0: web / 1: android/ 2 ：iOS
 */
@property (nonatomic, copy) NSString *deviceType;
@end

NS_ASSUME_NONNULL_END
