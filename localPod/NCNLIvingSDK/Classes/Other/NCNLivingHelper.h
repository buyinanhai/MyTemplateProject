//
//  NCNLivingHelper.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCNLivingHelper : NSObject
+ (NSString *)genImageName:(NSString * _Nullable)uuid;

+ (NSString *)im_errorMsgWithCode:(int)code defaultErrMsg:(NSString *)defaultErr;
@end

NS_ASSUME_NONNULL_END
