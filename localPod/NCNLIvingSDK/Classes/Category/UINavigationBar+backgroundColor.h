//
//  UINavigationBar+backgroundColor.h
//  YQD_Student_iPad
//
//  Created by 王志盼 on 2018/2/6.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (backgroundColor)
@property (nonatomic, strong) UIView *overLayer;

- (void)yqd_setbgColor:(UIColor *)color;
@end
