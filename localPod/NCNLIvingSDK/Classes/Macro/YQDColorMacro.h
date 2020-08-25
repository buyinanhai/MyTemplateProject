//
//  YQDColorMacro.h
//  YQD_iPhone
//
//  Created by 王志盼 on 2017/7/25.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#ifndef YQDColorMacro_h
#define YQDColorMacro_h

#define defaultChooseColor @"#FFFF1900"

#define YQDColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//十六进制的颜色转为iOS可用的UIColor   UIColorFromRGB(0xff3c3c)
#define UIColorFromRGB(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

//#define kColorMain YQDColor(60, 132, 239, 1)
#define kColorMain YQDColor(248,84,21,1) //改为橙色

#define kColorMainOrg YQDColor(248,84,21,1)

//#define kColorTabTarNormal kColor1
#define kColorTabTarNormal YQDColor(168,171,178,1)

/**白色*/
#define kColorWhite [UIColor whiteColor]

/**字体黑色最深*/
#define kColor1 UIColorFromRGB(0x333333)

/**字体黑色中间*/
#define kColor2 UIColorFromRGB(0x666666)

/**字体黑色最浅*/
#define kColor4 UIColorFromRGB(0x999999)

/**灰色线条*/
#define kColor5 UIColorFromRGB(0xe6e6e6)

/**背景灰色*/
#define kColor6 UIColorFromRGB(0xf2f2f2)

/**直播导航栏颜色*/
#define kColor7 UIColorFromRGB(0x303740)

/**直播左侧划出颜色*/
#define kColor8 UIColorFromRGB(0x1b2129)

/**直播画板背景颜色*/
#define kColor9 UIColorFromRGB(0x2b3139)

/**导学案按钮颜色*/
#define kColorLecNor YQDColor(235, 235, 235, 1)

#define kColorLecPre YQDColor(214, 214, 214, 1)

#endif /* YQDColorMacro_h */
