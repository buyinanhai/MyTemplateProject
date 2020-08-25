//
//  NCNLivingHelper.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/29.
//

#import "NCNLivingHelper.h"
#import <ImSDK/ImSDK.h>

@implementation NCNLivingHelper
+ (NSString *)genImageName:(NSString *)uuid
{
    int sdkAppId = [[TIMManager sharedInstance] getGlobalConfig].sdkAppId;
    NSString *identifier = [[TIMManager sharedInstance] getLoginUser];
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%d_%@_image_%@", sdkAppId, identifier, uuid];
    return name;
}


+ (NSString *)im_errorMsgWithCode:(int)code defaultErrMsg:(nonnull NSString *)defaultErr {
    
    NSDictionary *errorDict = @{
        
        @"10010" : @"群组已被解散！",
        @"10017" : @"你已经被老师禁言！",
        @"10031" : @"只能撤回两分钟以内的消息！",
//        @"10031" : @"群组不存在",
        
    };
    NSString *result = errorDict[[NSString stringWithFormat:@"%d",code]];
    if (result.length == 0) {
        result = defaultErr;
    }
    return result;
    
}
@end
