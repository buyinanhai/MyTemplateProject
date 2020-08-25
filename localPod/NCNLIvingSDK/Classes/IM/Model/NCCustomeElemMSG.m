//
//  NCCustomElemMSG.m
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCCustomeElemMSG.h"

@implementation NCCustomeElemMSG


+ (instancetype)customElemMSGWithDict:(NSDictionary *)dict {
    
    NCCustomeElemMSG *elem = [self new];
    
    if (dict.classForCoder == NSDictionary.class) {
        
        [elem setValuesForKeysWithDictionary:dict];
    } else {
        elem.cmdData = dict;
    }
    
    return elem;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


+ (UIColor *)getColorFromColorString:(NSString *)str {
    
    UIColor *color = nil;
    if (str.length  == 0) {
        return color;
    }
    str = [str stringByReplacingOccurrencesOfString:@"rgba(" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSArray *rgba = [str componentsSeparatedByString:@","];
    if (rgba.count == 4) {
        color = rgba([rgba[0] floatValue], [rgba[1] floatValue], [rgba[2] floatValue], [rgba[3] floatValue]);
        return color;
    }
    return color;
}
@end
