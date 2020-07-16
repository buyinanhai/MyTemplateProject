//
//  MyNetwork.h
//  ID贷
//
//  Created by apple on 2019/6/21.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "DYBaseNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyNetwork : DYBaseNetwork


/** 保存通讯录
 *  @param mobiles 手机号码和姓名的json字符串{name:xxx,phone:xxx}
 *
 */
+ (instancetype)saveContactsWithMobiles:(NSString *)mobiles name:(NSString *)name name1:(NSString *)name1 mobile:(NSString *)mobile mobile1:(NSString *)mobile1;


/** 设置默认银行卡
 *
 * @param bankID 银行卡id
 *
 */
+ (instancetype)setDefaultBankWithId:(NSString *)bankID;

/** 获取银行卡名称列表
 *
 *
 */
+ (instancetype)getBankNameList;


/** 获取我的银行卡李彪
 *
 *
 */
+ (instancetype)getMyBankList;


/** 保存银行卡
 *
 * @param bankid 银行卡类型id
 *
 */
+ (instancetype)saveBankWithBankID:(NSString *)bankid name:(NSString *)name cardId:(NSString *)cardId;

/** 修改头像或昵称
 *
 *
 */

+ (instancetype)modifyAvartar:(NSData *)dataImg nickname:(NSString *)nickname;


/** 上传手机识别码图片
 *
 *
 */
+ (instancetype)uploadIMEIImage:(NSData *)data;


/** 上传身份证的照片
 *
 * @param files 0.jpg：身份证正面，1.bjpg：身份证反面，2.jpg：手持身份证照
 *
 */
+ (instancetype)uploadIdentifyImageFiles:(NSArray<NSData *> *)files name:(NSString *)name cardID:(NSString *)cardID;

/**获取认证信息*/
+ (instancetype)getAuthorizations;

/**获取我的贷款列表*/
+ (instancetype)getMyLoans;

//保存反馈意见
+ (instancetype)saveFeedBack:(NSString *)content;


/**获取个人基本信息*/
+ (instancetype)getUserInfo;
@end

NS_ASSUME_NONNULL_END
