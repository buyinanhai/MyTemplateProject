//
//  UIView+Extension.h
//
//
//  Created by Fire on 15/7/27.
//  Copyright (c) 2015年 Fire. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (assign,nonatomic,readonly) CGFloat maxX;
@property (assign,nonatomic,readonly) CGFloat maxY;
@property (readonly) UIViewController *mm_viewController;  //self Responder UIViewControler


- (UIView *)alignParentCenter;
- (UIView *)alignParentCenter:(CGPoint)margin;
/** 控件在父控控件中的位置,水平居中 */
- (UIView *)layoutParentHorizontalCenter;
- (UIView *)alignParentBottomWithMargin:(CGFloat)margin;
/** 居中 */
- (UIView *)layoutParentCenter;
/** 左上角移至vec */
- (UIView *)move:(CGPoint)vec;

- (void)sl_setBorderWidth:(CGFloat)width borderColor:(CGColorRef)color cornerR:(CGFloat)cornerR;

- (void)sl_setCornerRadius:(CGFloat)cornerR;

/** 获取一个小圆点。位置要另外设置 */
+ (UIView *)sl_getDotView:(UIColor *)col width:(CGFloat)w;
/** 右上角加一个小圆点 */
-(UIView *)addBadge:(UIColor *)col;
-(void)removeBadge;

/** 线。位置要另外设置 */
+ (UIView *)sl_line;


- (void)living_addShadowWithCornerRadius:(CGFloat)cornerRadius;

/* 设置阴影 默认灰，幅度5.0，不切圆角 */
-(void)setShadow;
-(void)setShadowColor:(UIColor *)c shadowR:(CGFloat)sr cornerR:(CGFloat)cr;

+ (instancetype)viewFromXib;



- (void)living_addCornersAndShadow;

- (void)living_addCorners:(UIRectCorner)corners
       shadowLayer:(void (^)(CALayer * shadowLayer))shadowLayer;

- (void)living_addCorners:(UIRectCorner)corners
            rRadii:(CGFloat)rRadii;

/*
@param corners 圆角设置
@param rRadii 圆角设置
@return shadowLayer 阴影设置
*/
- (void)living_addCorners:(UIRectCorner)corners
            rRadii:(CGFloat)rRadii
       shadowLayer:(nullable void (^)(CALayer * shadowLayer))shadowLayer;


@end
