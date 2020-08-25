//
//  NCLiveHeader.pch
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#ifndef NCLiveHeader_pch
#define NCLiveHeader_pch


#define kScreen_Width        [UIScreen mainScreen].bounds.size.width
#define kScreen_Height       [UIScreen mainScreen].bounds.size.height
#define kIs_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_IPhoneX (kScreen_Width >=375.0f && kScreen_Height >=812.0f && kIs_Iphone)

#define kStatusBar_Height    (kIs_IPhoneX ? (44.0):(20.0))
#define kTabBar_Height       (kIs_IPhoneX ? (49.0 + 34.0):(49.0))
#define kNavBar_Height       (44)
#define SLScreenZoomW (kScreen_Width / 375.0)
#define SLScreenZoomH (kScreen_Height / 667.0)

#define kSearchBar_Height    (55)
#define kBottom_SafeHeight   (kIs_IPhoneX ? (34.0):(0))
#define kTop_SafeHeight   (kIs_IPhoneX ? (22.0):(0))

#define kRGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define kRGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]
#define kRGBHEX(__color) [UIColor colorWithHexString:(__color)]
#define rgba(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define SLMainFontSize 14  // 主字体大小
#define SLCnrRadius 10
#define SLMargin 10
#define TitleColor rgba(68.0, 68.0, 68.0, 1.0) // #444444
#define MainTextColor rgba(253.0, 118.0, 50.0, 1.0) // #FD7632
#define BkgColor kRGBHEX(@"f6f6f6")  //246,246,246

#define MainColor rgba(255.0,169.0,78.0,1.0) // #FFA94E

#define kWeakSelf(type)  __weak typeof(type) weak##type = type

///画布宽高比
#define kDrawAspectRatio 1.77


#ifdef __OBJC__
#import "YQDColorMacro.h"
#import "UIView+Frame.h"
#import "NCDrawManager.h"
#import "NSBundle+NCNLiving.h"
#import "UIColor+Hex.h"
#import "UIFont+SizeFit.h"
#import "UIImage+Category.h"
#import "UIView+Extension.h"
#import <Masonry/Masonry.h>
#import "NCNLivingSDK.h"
#import "NCNLivingHUD.h"
#import "NCNLivingHelper.h"
#import "YJProgressHUD.h"
#endif
// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

#endif /* NCLiveHeader_pch */
