//
//  NCNCustomMessageUtil.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TIMMessage;
@interface NCNCustomMessageUtil : NSObject



/**
 发送举手指令
 */

+ (TIMMessage *)customMessageForSendHandsUpWithOpen:(BOOL)isHandup;

/**
 发送回复点到指令
 */

+ (TIMMessage *)customMessageForSendSign;


/**
 发送问题指令
 */

+ (TIMMessage *)customMessageForSendQuestionWithText:(NSString *)text;


/**
 发送提交答案
 */

+ (TIMMessage *)customMessageForSendTestAnswerWithText:(NSString *)text;

/**
 发送在线指令给老师
 */

+ (TIMMessage *)customMessageForSendOnlineOrder;
@end

NS_ASSUME_NONNULL_END
