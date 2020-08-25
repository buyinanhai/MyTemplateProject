//
//  UIColor+Hex.h
//  YQD_Student_iPad
//
//  Created by 纤夫的爱 on 2018/10/19.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]


NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//从进制int到颜色
+ (UIColor *)colorWithHexInt:(uint32_t)color;

//从hexstring到uint32_t
+ (uint32_t)transferHexToUIntWithHexString:(NSString *)hexStr;



// UIColor转#ffffff格式的字符串
+ (NSString *)hexStringFromColor:(UIColor *)color;


- (uint32_t)transferHexToInt;
@end

NS_ASSUME_NONNULL_END
