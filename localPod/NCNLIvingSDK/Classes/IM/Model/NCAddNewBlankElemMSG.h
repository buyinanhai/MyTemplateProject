//
//  NCAddNewBlankElemMSG.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/7.
//

#import "NCCustomeElemMSG.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCAddNewBlankElemMSG : NCCustomeElemMSG

/**
 背景图片
 */
@property (nonatomic, copy) NSString *image;
/**
 
 */
@property (nonatomic, copy) NSString *itemId;
/**
 白板索引
 */
@property (nonatomic, copy) NSString *pageIndex;
/**
 白板背景颜色
 */
@property (nonatomic, copy) NSString *Color;

@end

NS_ASSUME_NONNULL_END
