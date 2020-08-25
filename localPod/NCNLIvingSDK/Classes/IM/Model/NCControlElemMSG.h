//
//  NCControlElemMSG.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCCustomeElemMSG.h"

NS_ASSUME_NONNULL_BEGIN

/**
 课件和白板页控制指令数据结构  打开关闭课件  暂时写在一块  懒
 */
@interface NCControlElemMSG : NCCustomeElemMSG


#pragma mark 新增白板页
/**
 背景颜色web
 */
@property (nonatomic, copy) NSString *Color;
/**
 背景颜色Android
 */
@property (nonatomic, copy) NSString *Color1;
/**
 背景图片
 */
@property (nonatomic, copy) NSString *image;

#pragma mark 控制打开/关闭整个ppt课件
/**
 1: 打开 / 0: 关闭
 */
@property (nonatomic, copy) NSString *optType;
/**
 课件名称
 */
@property (nonatomic, copy) NSString *fileName;
/**
 课件id
 */
@property (nonatomic, copy) NSNumber *id;
/**
 课件每页图片链接数组
    { imageUrl :     seq: 页码 }
 */
@property (nonatomic, copy) NSArray<NSDictionary *> *imageList;


#pragma mark 翻页
/**
 当前页动画步骤
 */
@property (nonatomic, copy) NSString *stepIndex;
/**
 页面类型（0白板/1课件页）
 */
@property (nonatomic, copy) NSString *pageType;
/**
 当前页码
 */
@property (nonatomic, copy) NSString *pageIndex;




@end

NS_ASSUME_NONNULL_END
