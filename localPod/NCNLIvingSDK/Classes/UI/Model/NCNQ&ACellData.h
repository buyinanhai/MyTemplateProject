//
//  NCNQ&ACellData.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TIMMessage;
@interface NCNQ_ACellData : NSObject
@property (nonatomic, copy) NSString *askText;

@property (nonatomic, copy) NSString *askTime;
@property (nonatomic, copy) NSString *answerTime;

@property (nonatomic, copy) NSString *askName;
@property (nonatomic, copy) NSString *answerName;

@property (nonatomic, copy) NSString *answerText;

@property (nonatomic, copy) NSString *askId;
/**
 消息发送id
 */
@property (nonatomic, copy) NSString *sender;



@property (nonatomic, strong) TIMMessage *askElem;
@property (nonatomic, strong) TIMMessage *answerElem;

- (CGFloat)askContentHeight;

- (CGFloat)answerContentHeight;
@end

NS_ASSUME_NONNULL_END
