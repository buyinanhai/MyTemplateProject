//
//  UIButton+ZYExtension.h
//  LiveApp
//
//  Created by 王志盼 on 2017/2/20.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZYExtension)


/**
 设置选中图片的btn
 */
+ (UIButton *)buttonForNoHighlightedWithTarget:(id)target action:(SEL)action normalImgName:(NSString *)normalImgName selectedImgName:(NSString *)selectedImgName;


/**
 主题色的btn
 */
+ (UIButton *)buttonForMainColorWithTarget:(id)target action:(SEL)action title:(NSString *)title;
@end
