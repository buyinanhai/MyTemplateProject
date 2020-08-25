//
//  NSBundle+NCNLiving.h
//  XYClassRoom
//
//  Created by 尹彦博 on 2020/4/16.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (NCNLiving)

+ (NSBundle *)ncn_sharedBundle;

+ (UIImage *)living_loadImageWithName:(NSString *)name;


+ (UIImage *)living_loadImageWithRalateURL:(NSString *)relateURL fileName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
