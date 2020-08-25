//
//  UIFont+SizeFit.h
//  TCWatch
//
//  Created by RSN on 2017/6/8.
//  Copyright © 2017年 newcloudnet. All rights reserved.
//



/** 主要用来实现不同屏幕宽度，最小屏 中大屏 最大屏之间字号增加关系。
    是两个较小屏字号一样，还是两个较大屏字号一样 */

#import <UIKit/UIKit.h>

#define FontScaleF(x) [UIFont systemFontOfFloorfScaleSize:(x)]
#define FontScaleC(x) [UIFont systemFontOfCeilfScaleSize:(x)]

#define FontScaleF_B(x) [UIFont boldSystemFontOfFloorfScaleSize:(x)]
#define FontScaleC_B(x) [UIFont boldSystemFontOfCeilfScaleSize:(x)]

#define FontScaleF_M(x) [UIFont mediumSystemFontOfFloorfScaleSize:(x)]
#define FontScaleC_M(x) [UIFont mediumSystemFontOfCeilfScaleSize:(x)]


@interface UIFont (SizeFit)

/** 固定字体大小 */
+(UIFont *)font:(CGFloat)size;
+(UIFont *)boldFont:(CGFloat)size;
+(UIFont *)mediumFont:(CGFloat)size;

/** 375,414 字号为fontSize 320为fontSize-1 */
+(UIFont *)systemFontOfFloorfScaleSize:(CGFloat)fontSize;
/** 375,320 字号为fontSize 414为fontSize+1 */
+(UIFont *)systemFontOfCeilfScaleSize:(CGFloat)fontSize;

/** Bold 375,414 字号为fontSize 320为fontSize-1 */
+(UIFont *)boldSystemFontOfFloorfScaleSize:(CGFloat)fontSize;
/** Bold 375,320 字号为fontSize 414为fontSize+1 */
+(UIFont *)boldSystemFontOfCeilfScaleSize:(CGFloat)fontSize;

/** Medium 375,414 字号为fontSize 320为fontSize-1 */
+(UIFont *)mediumSystemFontOfFloorfScaleSize:(CGFloat)fontSize;
/** Medium 375,320 字号为fontSize 414为fontSize+1 */
+(UIFont *)mediumSystemFontOfCeilfScaleSize:(CGFloat)fontSize;

/** 根据屏幕宽度递增(+1) */
+(UIFont *)systemFontIncrement:(CGFloat)fontSize;
/** 根据屏幕宽度递增 bold */
+(UIFont *)boldSystemFontIncrement:(CGFloat)fontSize;
/** 根据屏幕宽度递增 Medium  */
+(UIFont *)mediumSystemFontIncrement:(CGFloat)fontSize;



/** 获取不同字重的系统字体 */
+ (UIFont *)systemFontOfSize:(CGFloat)fontSize weight:(UIFontWeight)weight ceilfScale:(BOOL)cl;
/** 根据字体名获取字体 */
+ (UIFont *)fontName:(NSString *)name size:(CGFloat)fontSize ceilfScale:(BOOL)cl;


@end
