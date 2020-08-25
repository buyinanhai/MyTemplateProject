//
//  NCCustomElemMSG.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自定义消息elem的超类 ， 实例化出具体对应的数据模型
 */
@interface NCCustomeElemMSG : NSObject

@property (nonatomic, copy) id cmdData;


+ (instancetype)customElemMSGWithDict:(NSDictionary *)dict;

+ (UIColor *)getColorFromColorString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
