//
//  NCDrawElemMSG.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCCustomeElemMSG.h"

NS_ASSUME_NONNULL_BEGIN

/**
 批注指令的数据结构
 */
@interface NCDrawElemMSG : NCCustomeElemMSG

/**
 ItemId    string    图形Id（唯一标识）
 */
@property (nonatomic, copy) NSString *itemId;

/**
 itemType    string    批注类型（见批注类型表）
 0    画笔
 1    直线
 2    单向箭头
 3    矩形
 4    圆形
 5    五边形
 6    梯形
 7    菱形
 8    三角形
 9    平行四边形
 10    文本框
 */
@property (nonatomic, copy) NSString *itemType;
/**
pageIndex    string    所属页码

*/
@property (nonatomic, copy) NSString *pageIndex;
/**
pageType    string    页面类型（0白板/1课件页）

*/
@property (nonatomic, copy) NSString *pageType;
/**
itemX    string    X坐标

*/
@property (nonatomic, copy) NSString *itemX;
/**
itemY    string    Y坐标

*/
@property (nonatomic, copy) NSString *itemY;
/**
itemWidth    string    宽度

*/
@property (nonatomic, copy) NSString *itemWidth;
/**
itemHeight    string    高度

*/
@property (nonatomic, copy) NSString *itemHeight;
/**
itemRotate    string    旋转角度

*/
@property (nonatomic, copy) NSString *itemRotate;
/**
penColor    String    web画笔颜色（边框颜色）

*/
@property (nonatomic, copy) NSString *penColor;

/**
penColor    String    android画笔颜色（边框颜色） 十六进制颜色值

*/
@property (nonatomic, copy) NSString *penColor1;
/**
brushColor    String    web填充颜色

*/
@property (nonatomic, copy) NSString *brushColor;
/**
brushColor    String    android填充颜色 十六进制颜色值

*/
@property (nonatomic, copy) NSString *brushColor1;

/**
penWidth    string    画笔宽度

*/
@property (nonatomic, copy) NSString *penWidth;
/**
itemText    String    文本内容

*/
@property (nonatomic, copy) NSString *itemText;
/**
pointList    string    笔迹点集（图形顶点）

*/
@property (nonatomic, copy) NSArray *pointList;

/**
位置 X

*/
@property (nonatomic, copy) NSString *posX;
/**
位置  Y

*/
@property (nonatomic, copy) NSString *posY;
/**
位置   Z

*/
@property (nonatomic, copy) NSString *posZ;

@property (nonatomic, copy) NSString *fontSize;

@property (nonatomic, copy) NSString *pixelSize;


//是否粗体
@property (nonatomic, copy) NSString *fontBold;

/**
 是否为新消息
    在画图的时候 如果是历史 可以在原有的layer上继续画   但是如果是新消息 则删除原有的layer 重新画
 */
@property (nonatomic, assign) BOOL isNewMsg;



@end

NS_ASSUME_NONNULL_END
