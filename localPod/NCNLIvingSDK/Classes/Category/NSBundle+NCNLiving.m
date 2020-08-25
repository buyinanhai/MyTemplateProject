//
//  NSBundle+NCNLiving.m
//  XYClassRoom
//
//  Created by 尹彦博 on 2020/4/16.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NSBundle+NCNLiving.h"

@implementation NSBundle (NCNLiving)

+ (NSBundle *)ncn_sharedBundle
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LiveResources" ofType:@"bundle" inDirectory:nil];
        bundle = [NSBundle bundleWithPath:path];
    }
    return bundle;
}

+ (UIImage *)living_loadImageWithName:(NSString *)name
{
    UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self ncn_sharedBundle] pathForResource:name ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)living_loadImageWithRalateURL:(NSString *)relateURL fileName:(NSString *)name {
  
    UIImage *image = nil;
    if (image == nil) {
        NSString *url =  [NSString stringWithFormat:@"%@/%@.png",[[[self ncn_sharedBundle] bundlePath] stringByAppendingPathComponent:relateURL],name];
        image = [[UIImage imageWithContentsOfFile:url] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
    
    
}
@end
