//
//  LineLayer.h
//  YQD_Student_iPad
//
//  Created by 陈嘉杰 on 2018/11/3.
//  Copyright © 2018 牛师帮. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineLayer : CAShapeLayer

/**
 LineLayer对象的创建方法

 @param lId lId
 @param color 颜色
 @param weight 粗细
 @return LineLayer对象
 */
+ (LineLayer*)createLine:(NSString*)lId withColor:(UIColor *)color withWeight:(float)weight;

/**
 压入LineLayer里的点

 @param pointList 点的列表
 */
-(void)lineWithPointList:(NSMutableArray<NSString*>*)pointList;


/**
 移动LineLayer

 @param offsetDistance 移动的距离
 */
-(void)moveLayer:(CGSize)offsetDistance;

/**
 选中

 @param isSelected 是否选中
 */
-(void)select:(BOOL)isSelected;

-(void)offsetDashedLineLayer:(CGSize)offsetDistance;

@end

NS_ASSUME_NONNULL_END
