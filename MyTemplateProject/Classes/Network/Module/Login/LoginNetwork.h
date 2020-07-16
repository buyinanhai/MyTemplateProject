//
//  LoginNetwork.h
//  ID贷
//
//  Created by apple on 2019/6/19.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "DYBaseNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginNetwork : DYBaseNetwork


/** 登录
 *
 * @param appName app名称 == yn
 *
 */
+ (instancetype)loginWithMobile:(NSString *)mobile time:(NSString *)timeStamp md5:(NSString *)md5 app:(NSString *)appName model:(NSString *)phoneType version:(NSString *)version imei:(NSString *)uuid;
@end

NS_ASSUME_NONNULL_END
