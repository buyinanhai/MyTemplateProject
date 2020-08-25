//
//  UIImage+Category.h
//  YQD_iPhone
//
//  Created by 王志盼 on 2017/7/25.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
/**
 *  根据图片名返回一张能自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *  根据一个颜色值反回一张纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color height:(CGFloat)height;

/**
 返回虚线image的方法
 */
+ (UIImage *)drawLineByImageView:(UIImageView *)imageView color:(UIColor *)color;


/**
 图片变灰
 */
+ (UIImage *)grayImage:(UIImage *)sourceImage;


/**
 等比例缩放图片
 */
+ (UIImage*)scaleToSize:(CGSize)size forImage:(UIImage *)image;


/**
 将图片裁剪为圆形
 */
+ (UIImage *)circleImage:(UIImage *)image;

+ (UIImage *)living_imageWithNamed:(NSString *)name;
@end
