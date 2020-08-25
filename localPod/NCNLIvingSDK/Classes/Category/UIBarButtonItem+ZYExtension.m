//
//  UIBarButtonItem+ZYExtension.m
//  Template
//
//  Created by 王志盼 on 15/10/8.
//  Copyright © 2015年 王志盼. All rights reserved.
//

#import "UIBarButtonItem+ZYExtension.h"
#import "YQDLeftImgBtn.h"

@implementation UIBarButtonItem (ZYExtension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)hightImageName  title:(NSString *)title target:(id)target action:(SEL)action
{
    YQDLeftImgBtn *btn = [YQDLeftImgBtn buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:kColor4 forState:UIControlStateNormal];
    [btn setTitle:title forState: UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightImageName] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn sizeToFit];
    btn.frame = CGRectMake(0, 0, 80, 40);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action btn:(UIButton *)btn
{
//    UIButton *btn = [[UIButton alloc] init];
    
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];

    [btn setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn sizeToFit];
    btn.frame = CGRectMake(0, 0, (btn.width >= 40 ? btn.width : 40) + 10, 40);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


+ (UIBarButtonItem *)itemWithTitle:(NSString *)title font:(CGFloat)font target:(UIViewController *)target action:(SEL)action textColor:(UIColor *)textColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn sizeToFit];
    btn.frame = CGRectMake(0, 0, btn.width >= 40 ? btn.width : 40, 40);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
