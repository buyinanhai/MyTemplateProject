//
//  UIButton+ZYExtension.m
//  LiveApp
//
//  Created by 王志盼 on 2017/2/20.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "UIButton+ZYExtension.h"

@implementation UIButton (ZYExtension)
+ (UIButton *)buttonForNoHighlightedWithTarget:(id)target action:(SEL)action normalImgName:(NSString *)normalImgName selectedImgName:(NSString *)selectedImgName
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)buttonForMainColorWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = true;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [btn setBackgroundColor:kColorMain];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
