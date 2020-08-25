//
//  CALayer+CanvasProperty.h
//  YQD_Student_iPad
//
//  Created by 陈嘉杰 on 2018/11/2.
//  Copyright © 2018 牛师帮. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define SELECTED_COLOR [UIColor redColor].CGColor

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (CanvasProperty)
//LayerID
@property (nonatomic, copy) NSString *lId;
//是否被选中 --- 删除前确认是否选中
@property (nonatomic, assign) BOOL isSelected;
//包围盒
@property (nonatomic, assign) CGRect containRect;
//设定的颜色
@property(nonatomic) UIColor* color;
//包围盒Layer
@property (nonatomic, strong) CAShapeLayer *dashedLineLayer;
/**
 计算包围盒的范围

 @param point 最近收到点
 */
-(void)dealupContainRect:(CGPoint)point;

/**
 计算偏移后的包围盒范围

 @param offsetDistance 偏移的距离
 */
-(void)offsetContainRect:(CGSize)offsetDistance;

/**
 偏移包围盒
 offsetContainRect后再重新算一次包围盒Layer可以做到偏移包围盒，但是速度太慢，移动时会出现延迟。只能直接移动包围盒

 @param offsetDistance 偏移距离
 */
-(void)offsetDashedLineLayer:(CGSize)offsetDistance;
-(void)updateDashedLineLayer;
@end

NS_ASSUME_NONNULL_END
