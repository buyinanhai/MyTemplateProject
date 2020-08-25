//
//  ZYDrawingLayer.h
//  ZYDrawBoard
//
//  Created by 王志盼 on 2018/5/31.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
//type 0：直线 1：椭圆 2：圆 3：三角 4：矩形

typedef enum : NSUInteger {
   GraphTypeStraightLine = 0,
    GraphTypeEllipse = 1,
    GraphTypeRound = 2,
    GraphTypeTriangle =3,
    GraphTypeRectangle = 4,
    GraphTypeImage = 5,
    GraphTypeStrightLineArrow = 6,
    ///多边形
    GraphTypePolygon = 7,
} GraphType;


@interface ZYDrawingLayer : CAShapeLayer

@property (nonatomic, copy) NSString *lId;

@property (nonatomic, assign) BOOL isSelected;    /**< 是否选中 */
@property (nonatomic, assign, readonly) CGRect containRect;
@property (nonatomic, assign, readonly) CGRect containBox;//完整包围盒子
@property (nonatomic, strong) UIColor *strokeOriginColor;
@property (nonatomic, strong) UIColor *fillOriginColor;

@property (nonatomic, assign) BOOL isTriangle;/*是否是三角*/
@property (nonatomic, assign) BOOL isLastStepOfTriangle;/*是否三角还剩最后一步未完成*/
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) CGFloat pointpXRatio;


/*
 color:             默认笔迹颜色
 chooseColor:       已经选择的颜色 -- （或者从历史笔迹里获得的颜色）
 weight:            笔迹的宽度 -- （当前iOS默认为1，qt默认为0）
 */

+ (ZYDrawingLayer *)createLayerWithStartPoint:(CGPoint)startPoint penColor:(UIColor *)color chooseColor:(uint32_t)chooseColor chooseWeight:(float)weight layerSize:(CGSize)size;

//- (void)movePathWithStartPoint:(CGPoint)startPoint;
- (void)movePathWithEndPoint:(CGPoint)EndPoint;
//- (void)movePathWithPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint;

//- (void)movePathWithStartPoint:(CGPoint)startPoint isSelected:(BOOL)isSelected;
//- (void)movePathWithEndPoint:(CGPoint)EndPoint isSelected:(BOOL)isSelected;
//- (void)movePathWithPreviousPoint:(CGPoint)previousPoint
//                     currentPoint:(CGPoint)currentPoint
//                       isSelected:(BOOL)isSelected;

- (void)moveGrafiitiPathPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint;

+ (ZYDrawingLayer*)createLayerWithImage:(CGRect)imageSize withUrl:(NSString*)imageUrl;
- (void)changeImageLayerSize:(CGRect)imageSize;
-(void)changeImageLayerEndPoint:(CGPoint)endPoint;


/*
 数学画图方法
 type 0：直线 1：椭圆 2：圆 3：三角 4：矩形
 */
+ (ZYDrawingLayer *)createMathGraphWithStartPoint:(CGPoint)startPoint chooseColor:(uint32_t)chooseColor fillColor:(uint32_t)fillColor chooseWeight:(float)weight type:(GraphType)type;

/*图形画作移动过程跟踪*/
- (void)moveMathGraphWithCurrentPoint:(CGPoint)point;

/*图形画完提笔*/
- (void)finishMathGraphWithEndPoint:(CGPoint)endPoint;

/*三角第二步*/
- (void)graphTriangleLastStepWithCurrentPoint:(CGPoint)point;

/*三角第二步 --- 移动中*/
- (void)graphTriangleLastMoveWithCurrentPoint:(CGPoint)point;


@end
