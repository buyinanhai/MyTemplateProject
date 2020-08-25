//
//  UINavigationBar+backgroundColor.m
//  YQD_Student_iPad
//
//  Created by 王志盼 on 2018/2/6.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "UINavigationBar+backgroundColor.h"
#import <objc/runtime.h>

static char _overLayerKey;

@implementation UINavigationBar (backgroundColor)
- (void)yqd_setbgColor:(UIColor *)color
{
    if (!self.overLayer)
    {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        self.overLayer = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.width, self.height + 20)];
        self.overLayer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self insertSubview:self.overLayer atIndex:0];
    }
    self.overLayer.backgroundColor = color;
}


- (void)setOverLayer:(UIView *)overLayer
{
    objc_setAssociatedObject(self, &_overLayerKey, overLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)overLayer
{
    return objc_getAssociatedObject(self, &_overLayerKey);
}

@end
