//
//  UIFont+SizeFit.m
//  TCWatch
//
//  Created by RSN on 2017/6/8.
//  Copyright © 2017年 newcloudnet. All rights reserved.
//



@implementation UIFont (SizeFit)

+(UIFont *)font:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

+(UIFont *)boldFont:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:size];
}

+(UIFont *)mediumFont:(CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

// 正常
+(UIFont *)systemFontOfFloorfScaleSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:(fontSize + floorf(SLScreenZoomW) - 1)];
}

+(UIFont *)systemFontOfCeilfScaleSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:(fontSize + ceilf(SLScreenZoomW) - 1)];
}

// bold
+(UIFont *)boldSystemFontOfFloorfScaleSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:(fontSize + floorf(SLScreenZoomW) - 1)];
}

+(UIFont *)boldSystemFontOfCeilfScaleSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:(fontSize + ceilf(SLScreenZoomW) - 1)];
}


//PingFangSC-Medium
+(UIFont *)mediumSystemFontOfFloorfScaleSize:(CGFloat)fontSize {
    CGFloat s = fontSize + floorf(SLScreenZoomW) - 1;
    UIFont *f = [UIFont systemFontOfSize:s weight:UIFontWeightMedium];
    return f;
}

+(UIFont *)mediumSystemFontOfCeilfScaleSize:(CGFloat)fontSize {
    CGFloat s = fontSize + floorf(SLScreenZoomW) - 1;
    UIFont *f = [UIFont systemFontOfSize:s weight:UIFontWeightMedium];
    return f;
}

// 根据屏幕宽度递增
+(UIFont *)systemFontIncrement:(CGFloat)fontSize {
    
    int add = 0;
    if (SLScreenZoomW == 1) {
        add = 1;
    }else if (SLScreenZoomW > 1) {
        add = 2;
    }
    
    return [UIFont systemFontOfSize:(fontSize + add)];
}


+(UIFont *)boldSystemFontIncrement:(CGFloat)fontSize {
    
    int add = 0;
    if (SLScreenZoomW == 1) {
        add = 1;
    }else if (SLScreenZoomW > 1) {
        add = 2;
    }
    
    return [UIFont boldSystemFontOfSize:(fontSize + add)];
}


+(UIFont *)mediumSystemFontIncrement:(CGFloat)fontSize {
    int add = 0;
    if (SLScreenZoomW == 1) {
        add = 1;
    }else if (SLScreenZoomW > 1) {
        add = 2;
    }
    return [UIFont systemFontOfSize:(fontSize + add) weight:UIFontWeightMedium];
}


+ (UIFont *)systemFontOfSize:(CGFloat)fontSize weight:(UIFontWeight)weight ceilfScale:(BOOL)cl {
    if (cl) {
        fontSize = fontSize + ceilf(SLScreenZoomW) - 1;
    }else {
        fontSize = fontSize + floorf(SLScreenZoomW) - 1;
    }
    
    UIFont *f = [UIFont systemFontOfSize:fontSize weight:weight];
    return f;
}

+ (UIFont *)fontName:(NSString *)name size:(CGFloat)fontSize ceilfScale:(BOOL)cl {
    if (cl) {
        fontSize = fontSize + ceilf(SLScreenZoomW) - 1;
    }else {
        fontSize = fontSize + floorf(SLScreenZoomW) - 1;
    }
    
    UIFont *f = [UIFont fontWithName:name size:fontSize];
    return f;
}


@end
