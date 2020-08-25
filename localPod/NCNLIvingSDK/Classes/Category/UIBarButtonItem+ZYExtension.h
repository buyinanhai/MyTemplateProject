//
//  UIBarButtonItem+ZYExtension.h
//  Template
//
//  Created by 王志盼 on 15/10/8.
//  Copyright © 2015年 王志盼. All rights reserved.
//  导航栏上左右两个按钮的生成

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZYExtension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)hightImageName  title:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title font:(CGFloat)font target:(UIViewController *)target action:(SEL)action textColor:(UIColor *)textColor;

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action btn:(UIButton *)btn;
@end
