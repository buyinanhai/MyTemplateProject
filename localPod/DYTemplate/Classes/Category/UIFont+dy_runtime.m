//
//  UIFont+UIFont_dy_runtime.m
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/13.
//  Copyright © 2020 汪宁. All rights reserved.
//

#import "UIFont+dy_runtime.h"
#import <objc/runtime.h>
#define kUINormalScreen  375 // UI设计原型图的手机尺寸宽度(6), 6p的--414
@implementation UIFont (dy_runtime)

+ (void)load {
    // 获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    // 获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = [UIFont adjustFont:fontSize];
    
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPad && (UIScreen.mainScreen.bounds.size.width < UIScreen.mainScreen.bounds.size.height)) {
        newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width / kUINormalScreen];
    }
    return newFont;
}

@end
