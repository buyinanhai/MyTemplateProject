//
//  NCNCustomMessageUtil.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/20.
//

#import "NCNCustomMessageUtil.h"
#import <ImSDK/ImSDK.h>
@implementation NCNCustomMessageUtil


+ (TIMMessage *)customMessageForSendHandsUpWithOpen:(BOOL)isHandup {
    
    TIMMessage *message = [TIMMessage new];
    
    TIMCustomElem *custome = [TIMCustomElem new];
    NSDictionary *dict = @{@"bagCount":@"1",@"bagIndex":@"0",@"cmdType":@"7",@"cmdData":@{@"open":isHandup ? @"1" : @"0"}};
    custome.data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    
    [message addElem:custome];
    return message;
}

+ (TIMMessage *)customMessageForSendSign {
    
    TIMMessage *message = [TIMMessage new];
       
       TIMCustomElem *custome = [TIMCustomElem new];
       NSDictionary *dict = @{@"bagCount":@"1",@"bagIndex":@"0",@"cmdType":@"3",@"cmdData":@{@"deviceType": @"2"}};
       custome.data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
       
       [message addElem:custome];
       return message;
}

+ (TIMMessage *)customMessageForSendQuestionWithText:(NSString *)text {
    
    if (text.length == 0) return nil;
    
    TIMMessage *message = [TIMMessage new];
    
    TIMCustomElem *custome = [TIMCustomElem new];
    NSDictionary *dict = @{@"bagCount":@"1",@"bagIndex":@"0",@"cmdType":@"5",@"cmdData":@{@"askText": text, @"liveRoomId": NCNLivingSDK.shareInstance.liveRoomId}};
    custome.data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    
    [message addElem:custome];
    return message;
    
}

+ (TIMMessage *)customMessageForSendTestAnswerWithText:(NSString *)text {
    
    if (text.length == 0) return nil;
    
    TIMMessage *message = [TIMMessage new];
    
    TIMCustomElem *custome = [TIMCustomElem new];
    NSDictionary *dict = @{@"bagCount":@"1",@"bagIndex":@"0",@"cmdType":@"2",@"cmdData":@{@"questionAnswer": text}};
    custome.data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    
    [message addElem:custome];
    return message;
    
}

+ (TIMMessage *)customMessageForSendOnlineOrder {
    
    
    TIMMessage *message = [TIMMessage new];
    
    TIMCustomElem *custome = [TIMCustomElem new];
    NSDictionary *dict = @{@"bagCount":@"1",@"bagIndex":@"0",@"cmdType":@"26"};
    custome.data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    
    [message addElem:custome];
    return message;
       
}
@end
