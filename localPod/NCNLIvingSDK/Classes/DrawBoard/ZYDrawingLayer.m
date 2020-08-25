//
//  ZYDrawingLayer.m
//  ZYDrawBoard
//
//  Created by 王志盼 on 2018/5/31.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYDrawingLayer.h"
#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"

//#define ZYDRAWINGPATHWIDTH 2
#define ZYDRAWINGPATHWIDTH 1
#define ZYDRAWINGBUFFER 12
#define ZYDRAWINGORIGINCOLOR YQDColor(100, 100, 180, 1).CGColor
#define ZYDRAWINGSELECTEDCOLOR [UIColor redColor].CGColor
#define ZYMaxValue 999999

@interface ZYDrawingLayer ()

@property (nonatomic, assign) CGPoint startPoint;    /**< 起始坐标 */
@property (nonatomic, assign) CGPoint endPoint;    /**< 终点坐标 */

@property (nonatomic, assign) CGPoint lastTrianglePoint;    /**三角形最后一点 **/

@property (nonatomic, assign, readwrite) CGRect containRect;

@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
/**
 虚线layer
 */
@property (nonatomic, strong) CAShapeLayer *dashedLineLayer;
@property (nonatomic, strong) CALayer *imageLayer;
/**
 画图跟踪的贝叶斯曲线
 */
@property (nonatomic, strong) UIBezierPath *graphBezierPath;



@end

@implementation ZYDrawingLayer

- (instancetype)initWithPenColor:(UIColor *)color chooseColor:(uint32_t)chooseColor chooseWeight:(float)weight fillColor:(uint32_t)fillColor{
    if (self = [super init]) {
        //新加
//        chooseColor > 0?(self.strokeOriginColor = [UIColor colorWithHexInt:chooseColor]):(self.strokeOriginColor = color);
        self.strokeOriginColor = [UIColor colorWithHexInt:chooseColor];
        if (fillColor == 0) {
            self.fillOriginColor = UIColor.clearColor;
        } {
            self.fillOriginColor = [UIColor colorWithHexInt:fillColor];
        }
        self.lineJoin = kCALineJoinRound;
        self.lineCap = kCALineCapRound;
        self.strokeColor =  self.strokeOriginColor.CGColor;
        self.fillColor = self.fillOriginColor.CGColor;
        
        weight > 0 ?(self.lineWidth = weight):(self.lineWidth = ZYDRAWINGPATHWIDTH);
        
        self.isSelected = NO;
        
        self.minX = ZYMaxValue;
        self.minY = ZYMaxValue;
        self.maxX = -ZYMaxValue;
        self.maxY = -ZYMaxValue;
    }
    return self;
}


- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected == isSelected) return;
    _isSelected = isSelected;
    
    if (isSelected)
    {
        self.strokeColor =  [self.strokeOriginColor colorWithAlphaComponent:0.5].CGColor;
        self.fillColor = [self.fillOriginColor colorWithAlphaComponent:0.5].CGColor;
        //填充色透明的话，选中继续透明
        CGFloat R, G, B, A;
        long numComponents = CGColorGetNumberOfComponents(self.fillOriginColor.CGColor);
        if (numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(self.fillOriginColor.CGColor);
            R = components[0];
            G = components[1];
            B = components[2];
            A = components[3];
            if(A == 0)
            {
                self.fillColor = self.fillOriginColor.CGColor;
            }
        }
        //
        self.dashedLineLayer.hidden = false;
    }
    else
    {
//        self.strokeColor = self.fillColor = ZYDRAWINGORIGINCOLOR;
        self.strokeColor =   self.strokeOriginColor.CGColor;
        self.fillColor = self.fillOriginColor.CGColor;
        self.dashedLineLayer.hidden = true;
    }
    
}



+ (ZYDrawingLayer *)createLayerWithStartPoint:(CGPoint)startPoint penColor:(UIColor *)color chooseColor:(uint32_t)chooseColor chooseWeight:(float)weight layerSize:(CGSize)size {
    
    ZYDrawingLayer *layer = [[[self class] alloc] initWithPenColor:color chooseColor:chooseColor chooseWeight:weight fillColor:0];
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    
    layer.startPoint = startPoint;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineJoinStyle = kCGLineJoinRound;
    path.flatness = 0.1;
//    path.flatness = 0.6;
    [path moveToPoint:startPoint];
    layer.path = path.CGPath;
    
    [layer dealupXYWithPoint:startPoint];
    return layer;
}

- (void)movePathWithEndPoint:(CGPoint)endPoint {
    [self movePathWithEndPoint:endPoint isSelected:self.isSelected];
}

//- (void)movePathWithStartPoint:(CGPoint)startPoint {
//    [self movePathWithStartPoint:startPoint isSelected:self.isSelected];
//}

//- (void)movePathWithPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint {
//    CGPoint startPoint = CGPointMake(self.startPoint.x+currentPoint.x-previousPoint.x, self.startPoint.y+currentPoint.y-previousPoint.y);
//    CGPoint endPoint = CGPointMake(self.endPoint.x+currentPoint.x-previousPoint.x, self.endPoint.y+currentPoint.y-previousPoint.y);
//    [self movePathWithStartPoint:startPoint endPoint:endPoint isSelected:self.isSelected];
//}

//- (void)movePathWithStartPoint:(CGPoint)startPoint isSelected:(BOOL)isSelected {
//    [self movePathWithStartPoint:startPoint endPoint:self.endPoint isSelected:isSelected];
//}

- (void)movePathWithEndPoint:(CGPoint)endPoint isSelected:(BOOL)isSelected{
    [self movePathWithStartPoint:self.startPoint endPoint:endPoint isSelected:isSelected];
}

//- (void)movePathWithPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint isSelected:(BOOL)isSelected {
//    CGPoint startPoint = CGPointMake(self.startPoint.x+currentPoint.x-previousPoint.x, self.startPoint.y+currentPoint.y-previousPoint.y);
//    CGPoint endPoint = CGPointMake(self.endPoint.x+currentPoint.x-previousPoint.x, self.endPoint.y+currentPoint.y-previousPoint.y);
//    [self movePathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
//}

// 移动
- (void)moveGrafiitiPathPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint {
    self.maxX += currentPoint.x - previousPoint.x;
    self.minX += currentPoint.x - previousPoint.x;
    self.maxY += currentPoint.y - previousPoint.y;
    self.minY += currentPoint.y - previousPoint.y;
    
    if (_dashedLineLayer == nil)
    {
        [self dashedLineLayer];
    }
    
    
    self.startPoint = CGPointMake(self.startPoint.x + currentPoint.x - previousPoint.x, self.startPoint.y + currentPoint.y - previousPoint.y);
    self.endPoint = CGPointMake(self.endPoint.x + currentPoint.x - previousPoint.x, self.endPoint.y + currentPoint.y - previousPoint.y);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.path];
    [path applyTransform:CGAffineTransformMakeTranslation(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)];
    self.path = path.CGPath;
    
    path = [UIBezierPath bezierPathWithCGPath:_dashedLineLayer.path];
    [path applyTransform:CGAffineTransformMakeTranslation(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)];
    _dashedLineLayer.path = path.CGPath;
    if(self.imageLayer)
    {
        //关闭隐式动画
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        CGPoint point =  self.imageLayer.position;
        point = CGPointMake(point.x+ currentPoint.x - previousPoint.x, point.y + currentPoint.y - previousPoint.y);
        //self.imageLayer.frame = CGRectMake(point.x, point.y, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height);
        self.imageLayer.position = point;
        [CATransaction commit];
    }
    
   _dashedLineLayer.hidden = !self.isSelected;
    
}

- (void)movePathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint isSelected:(BOOL)isSelected {
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    self.isSelected = isSelected;
    [self moveGraffitiPathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
    [self dealupXYWithPoint:startPoint];
    [self dealupXYWithPoint:endPoint];
}


//- (void)moveArrowPathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint isSelected:(BOOL)isSelected {
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:startPoint];
//    [path addLineToPoint:endPoint];
//    [path appendPath:[self createArrowWithStartPoint:startPoint endPoint:endPoint]];
//    self.path = path.CGPath;
//}

//- (void)moveLinePathWithStartPoint:(CGPoint)startPoint
//                          endPoint:(CGPoint)endPoint
//                        isSelected:(BOOL)isSelected {
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:startPoint];
//    [path addLineToPoint:endPoint];
//    self.path = path.CGPath;
//}

//- (void)moveRulerArrowPathWithStartPoint:(CGPoint)startPoint
//                                endPoint:(CGPoint)endPoint
//                              isSelected:(BOOL)isSelected {
//    self.path = [self createRulerArrowWithStartPoint:startPoint endPoint:endPoint length:0].CGPath;
//}

//- (void)moveRulerLinePathWithStartPoint:(CGPoint)startPoint
//                               endPoint:(CGPoint)endPoint
//                             isSelected:(BOOL)isSelected {
//    self.path = [self createRulerLinePathWithEndPoint:endPoint andStartPoint:startPoint length:0].CGPath;
//}

//画
- (void)moveGraffitiPathWithStartPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint
                            isSelected:(BOOL)isSelected {
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.path];
    [path addLineToPoint:endPoint];
    [path moveToPoint:endPoint];
    self.path = path.CGPath;

}

//- (UIBezierPath *)createRulerLinePathWithEndPoint:(CGPoint)endPoint andStartPoint:(CGPoint)startPoint length:(CGFloat)length
//{
//    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//    bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:startPoint];
//    CGFloat angle = [self angleWithFirstPoint:startPoint andSecondPoint:endPoint];
//    CGPoint pointMiddle = CGPointMake((startPoint.x+endPoint.x)/2, (startPoint.y+endPoint.y)/2);
//    CGFloat offsetX = length*cos(angle);
//    CGFloat offsetY = length*sin(angle);
//    CGPoint pointMiddle1 = CGPointMake(pointMiddle.x-offsetX, pointMiddle.y-offsetY);
//    CGPoint pointMiddle2 = CGPointMake(pointMiddle.x+offsetX, pointMiddle.y+offsetY);
//    [bezierPath addLineToPoint:pointMiddle1];
//    [bezierPath moveToPoint:pointMiddle2];
//    [bezierPath addLineToPoint:endPoint];
//    [bezierPath moveToPoint:endPoint];
//    angle = [self angleEndWithFirstPoint:startPoint andSecondPoint:endPoint];
//    CGPoint point1 = CGPointMake(endPoint.x+10*sin(angle), endPoint.y+10*cos(angle));
//    CGPoint point2 = CGPointMake(endPoint.x-10*sin(angle), endPoint.y-10*cos(angle));
//    [bezierPath addLineToPoint:point1];
//    [bezierPath addLineToPoint:point2];
//    CGPoint point3 = CGPointMake(point1.x-(endPoint.x-startPoint.x), point1.y-(endPoint.y-startPoint.y));
//    CGPoint point4 = CGPointMake(point2.x-(endPoint.x-startPoint.x), point2.y-(endPoint.y-startPoint.y));
//    [bezierPath moveToPoint:point3];
//    [bezierPath addLineToPoint:point4];
//    [bezierPath setLineWidth:4];
//
//    return bezierPath;
//}

//- (UIBezierPath *)createRulerArrowWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint length:(CGFloat)length {
//    CGFloat angle = [self angleWithFirstPoint:startPoint andSecondPoint:endPoint];
//    CGPoint pointMiddle = CGPointMake((startPoint.x+endPoint.x)/2, (startPoint.y+endPoint.y)/2);
//    CGFloat offsetX = length*cos(angle);
//    CGFloat offsetY = length*sin(angle);
//    CGPoint pointMiddle1 = CGPointMake(pointMiddle.x-offsetX, pointMiddle.y-offsetY);
//    CGPoint pointMiddle2 = CGPointMake(pointMiddle.x+offsetX, pointMiddle.y+offsetY);
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:startPoint];
//    [path addLineToPoint:pointMiddle1];
//    [path moveToPoint:pointMiddle2];
//    [path addLineToPoint:endPoint];
//    [path appendPath:[self createArrowWithStartPoint:pointMiddle1 endPoint:startPoint]];
//    [path appendPath:[self createArrowWithStartPoint:pointMiddle2 endPoint:endPoint]];
//    return path;
//}

//- (UIBezierPath *)createArrowWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
//    CGPoint controllPoint = CGPointZero;
//    CGPoint pointUp = CGPointZero;
//    CGPoint pointDown = CGPointZero;
//    CGFloat distance = [self distanceBetweenStartPoint:startPoint endPoint:endPoint];
//    CGFloat distanceX = 8.0 * (ABS(endPoint.x - startPoint.x) / distance);
//    CGFloat distanceY = 8.0 * (ABS(endPoint.y - startPoint.y) / distance);
//    CGFloat distX = 4.0 * (ABS(endPoint.y - startPoint.y) / distance);
//    CGFloat distY = 4.0 * (ABS(endPoint.x - startPoint.x) / distance);
//    if (endPoint.x >= startPoint.x)
//    {
//        if (endPoint.y >= startPoint.y)
//        {
//            controllPoint = CGPointMake(endPoint.x - distanceX, endPoint.y - distanceY);
//            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
//            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
//        }
//        else
//        {
//            controllPoint = CGPointMake(endPoint.x - distanceX, endPoint.y + distanceY);
//            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
//            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
//        }
//    }
//    else
//    {
//        if (endPoint.y >= startPoint.y)
//        {
//            controllPoint = CGPointMake(endPoint.x + distanceX, endPoint.y - distanceY);
//            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
//            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
//        }
//        else
//        {
//            controllPoint = CGPointMake(endPoint.x + distanceX, endPoint.y + distanceY);
//            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
//            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
//        }
//    }
//    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
//    [arrowPath moveToPoint:endPoint];
//    [arrowPath addLineToPoint:pointDown];
//    [arrowPath addLineToPoint:pointUp];
//    [arrowPath addLineToPoint:endPoint];
//    return arrowPath;
//}

//- (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
//{
//    CGFloat xDist = (endPoint.x - startPoint.x);
//    CGFloat yDist = (endPoint.y - startPoint.y);
//    return sqrt((xDist * xDist) + (yDist * yDist));
//}

//- (CGFloat)angleWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint
//{
//    CGFloat dx = secondPoint.x - firstPoint.x;
//    CGFloat dy = secondPoint.y - firstPoint.y;
//    CGFloat angle = atan2f(dy, dx);
//    return angle;
//}

//- (CGFloat)angleEndWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint
//{
//    CGFloat dx = secondPoint.x - firstPoint.x;
//    CGFloat dy = secondPoint.y - firstPoint.y;
//    CGFloat angle = atan2f(fabs(dy), fabs(dx));
//    if (dx*dy>0) {
//        return M_PI-angle;
//    }
//    return angle;
//}


- (CGRect)containRect
{
    CGFloat minX = self.minX - 2;
    CGFloat minY = self.minY - 2;
    CGFloat maxX = self.maxX + 2;
    CGFloat maxY = self.maxY + 2;
    CGFloat width = maxX - minX;
    CGFloat height = maxY - minY;
    return CGRectMake(minX, minY, width, height);
}

- (CGRect)containBox
{
    CGFloat width = self.maxX - self.minX;
    CGFloat height = self.maxY - self.minY;
    return CGRectMake(self.minX, self.minY, width, height);
}

- (CAShapeLayer *)dashedLineLayer
{
    
    if (!_dashedLineLayer)
    {
        _dashedLineLayer = [CAShapeLayer layer];
        [self addSublayer:_dashedLineLayer];
    }
    CGFloat minX = self.minX - 2;
    CGFloat minY = self.minY - 2;
    CGFloat maxX = self.maxX + 2;
    CGFloat maxY = self.maxY + 2;
    CGFloat width = maxX - minX;
    CGFloat height = maxY - minY;
    //layer
    _dashedLineLayer.frame = CGRectMake(minX, minY, width, height);
    [_dashedLineLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    //设置虚线的颜色 - 颜色请必须设置
    [_dashedLineLayer setStrokeColor:ZYDRAWINGORIGINCOLOR];
    
    //设置虚线的高度
    [_dashedLineLayer setLineWidth:1.0f];
    
    //设置类型
    [_dashedLineLayer setLineJoin:kCALineJoinRound];
    
    /*
     10.f=每条虚线的长度
     3.f=每两条线的之间的间距
     */
    [_dashedLineLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:6.f],
      [NSNumber numberWithInt:3.f],nil]];
    
    // Setup the path
    CGMutablePathRef path1 = CGPathCreateMutable();
    
    CGPathMoveToPoint(path1, NULL,0, 0);
    
    CGPathAddLineToPoint(path1, NULL, width, 0);
    
    CGPathAddLineToPoint(path1, NULL, width, height);
    
    CGPathAddLineToPoint(path1, NULL, 0, height);
    
    CGPathAddLineToPoint(path1, NULL, 0, 0);
    [_dashedLineLayer setPath:path1];
    
    CGPathRelease(path1);
    
    _dashedLineLayer.hidden = true;
    
    return _dashedLineLayer;
}

- (void)dealupXYWithPoint:(CGPoint)point
{
    self.maxX = MAX(self.maxX, point.x);
    self.maxY = MAX(self.maxY, point.y);
    self.minX = MIN(self.minX, point.x);
    self.minY = MIN(self.minY, point.y);
}

-(void)dealupXYWithGraphSharpPoint:(CGPoint)point
{
    self.maxX = MAX(self.startPoint.x, point.x);
    self.maxY = MAX(self.startPoint.y, point.y);
    self.minX = MIN(self.startPoint.x, point.x);
    self.minY = MIN(self.startPoint.y, point.y);
}

-(void)dealupXYWithSize:(CGRect)size
{
    self.maxX = size.origin.x+ size.size.width;
    self.maxY = size.origin.y +size.size.height;
    self.minX = size.origin.x;
    self.minY = size.origin.y;
}

- (BOOL)isEqual:(ZYDrawingLayer *)object
{
    if (object == nil || ![object isMemberOfClass:[ZYDrawingLayer class]]) return false;
    if (self == object || [object.lId isEqualToString:self.lId]) return true;
    return false;
}



/*
 数学画图方法
 type 0：直线 1：椭圆 2：圆 3：三角 4：矩形
 */

//数学画图画笔开始
//数学画图画笔开始
+ (ZYDrawingLayer *)createMathGraphWithStartPoint:(CGPoint)startPoint chooseColor:(uint32_t)chooseColor fillColor:(uint32_t)fillColor chooseWeight:(float)weight type:(GraphType)type
{
    ZYDrawingLayer *layer = [[[self class] alloc] initWithPenColor:0 chooseColor:chooseColor chooseWeight:weight fillColor:fillColor];
    
    layer.startPoint = startPoint;
    layer.type = type;
    type == GraphTypeTriangle ? (layer.isTriangle =YES):(layer.isTriangle = NO);
    [layer dealupXYWithPoint:startPoint];
    return layer;
    
}


/*图形画作移动过程跟踪*/
- (void)moveMathGraphWithCurrentPoint:(CGPoint)point //这里可以做效果处理
{
    [self dealupXYWithGraphSharpPoint:point];
    
    CGFloat minX = MIN(self.startPoint.x, point.x);
    CGFloat minY = MIN(self.startPoint.y, point.y);
    CGFloat width = fabs(point.x - self.startPoint.x);
    CGFloat height = fabs(point.y - self.startPoint.y);
    
    CGRect rect =  CGRectMake(minX, minY, width, height);
    CGFloat minWidth = MIN(width, height);
    
    //[self graphStraightline:point];
    
    switch (self.type)
    {
        case GraphTypeStraightLine:
            [self graphStraightline:point];
            break;
        case GraphTypeEllipse:
            [self graphOval:rect];
            break;
        case GraphTypeRound:
            [self graphCircle:CGPointMake(minX, minY) radius:minWidth];
            //[self graphRectangle:rect];
            break;
        case GraphTypeTriangle:
            [self graphTriangle:point];
            break;
        case GraphTypeRectangle:
            [self graphRectangle:rect];
            break;
            
        case GraphTypeStrightLineArrow:
            
            [self graphStrightLineArrow:point];
            break;
            
       
            
        default:
            break;
    }
}

/*数学画图画笔结束*/
- (void)finishMathGraphWithEndPoint:(CGPoint)endPoint
{
    
    [self dealupXYWithPoint:endPoint];

    self.endPoint = endPoint;
    
    CGFloat minX = MIN(self.startPoint.x, self.endPoint.x);
    CGFloat minY = MIN(self.startPoint.y, self.endPoint.y);
    CGFloat width = fabs(self.endPoint.x - self.startPoint.x);
    CGFloat height = fabs(self.endPoint.y - self.startPoint.y);
    
    CGRect rect =  CGRectMake(minX, minY, width, height);
    CGFloat minWidth = MIN(width, height);
    
//    UIBezierPath *graphPath = [UIBezierPath bezierPathWithRect:CGRectMake(minX, minY, width, height)];
    switch (self.type)
    {
        case GraphTypeStraightLine:
            [self graphStraightline:endPoint];
            break;
        case GraphTypeEllipse:
            [self graphOval:rect];
            break;
        case GraphTypeRound:
            [self graphCircle:CGPointMake(minX, minY) radius:minWidth];
            break;
        case GraphTypeTriangle:
            [self graphTriangle:endPoint];
            break;
        case GraphTypeRectangle:
            [self graphRectangle:rect];
            break;
        case GraphTypeStrightLineArrow:
            
            [self graphStrightLineArrow:endPoint];
            break;
        default:
            break;
    }
    
}

/*直线*/
- (void)graphStraightline:(CGPoint)endpoint
{
    UIBezierPath *graphPath = [UIBezierPath bezierPath];
    [graphPath moveToPoint:self.startPoint];
    [graphPath addLineToPoint:endpoint];
    self.path = graphPath.CGPath;

}

/**
 画单向箭头
 */
- (void)graphStrightLineArrow:(CGPoint)endpoint {
    
    UIBezierPath *graphPath = [UIBezierPath bezierPath];
    [graphPath moveToPoint:self.startPoint];
    [graphPath addLineToPoint:endpoint];
    CGFloat distance = 40 * self.pointpXRatio;
    
    //弧度
    CGFloat radian = (60 * M_PI) / 180;

    //正切
    CGFloat y1=(endpoint.y - self.startPoint.y);
    CGFloat x1=(endpoint.x - self.startPoint.x);
    CGFloat tangent = -atan2(y1, x1);

    //右边线
    CGFloat point3x = endpoint.x + distance * sin(tangent - radian);
    CGFloat point3y = endpoint.y + distance * cos(tangent - radian);
    [graphPath addLineToPoint:CGPointMake(point3x, point3y)];
    [graphPath moveToPoint:endpoint];
    
    //左边线
    CGFloat point4x = endpoint.x + distance * sin(tangent + M_PI + radian);
    CGFloat point4y = endpoint.y + distance * cos(tangent + M_PI + radian);
    [graphPath addLineToPoint:CGPointMake(point4x, point4y)];

    self.path = graphPath.CGPath;
    
}

/*椭圆*/
- (void)graphOval:(CGRect)rect
{
    UIBezierPath *graphPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    self.path = graphPath.CGPath;

}
/*圆*/
- (void)graphCircle:(CGPoint)originPoint radius:(CGFloat)radius
{
    CGRect rect = CGRectMake(originPoint.x, originPoint.y, radius, radius);
    
    UIBezierPath *graphPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    self.path = graphPath.CGPath;
}
/*矩形*/
- (void)graphRectangle:(CGRect)rect
{
    UIBezierPath *graphPath = [UIBezierPath bezierPathWithRect:rect];
    self.path = graphPath.CGPath;

}

/*三角形第一步画直线*/
- (void)graphTriangle:(CGPoint)endPoint
{
    UIBezierPath *graphPath = [UIBezierPath bezierPath];
    [graphPath moveToPoint:self.startPoint];
    [graphPath addLineToPoint:endPoint];
    self.path = graphPath.CGPath;
}

/*三角第二步 ---- 移动中*/
- (void)graphTriangleLastMoveWithCurrentPoint:(CGPoint)point {
//    self.lastTrianglePoint = point;
    UIBezierPath *graphPath = [UIBezierPath bezierPath];
    [graphPath moveToPoint:self.startPoint];
    [graphPath addLineToPoint:self.endPoint];
    [graphPath addLineToPoint:point];
    [graphPath closePath];
    self.path = graphPath.CGPath;
    
}

/*三角第二步*/
- (void)graphTriangleLastStepWithCurrentPoint:(CGPoint)point {
    self.lastTrianglePoint = point;
    
    [self dealupXYWithPoint:point];
    
    UIBezierPath *graphPath = [UIBezierPath bezierPath];
    [graphPath moveToPoint:self.startPoint];
    [graphPath addLineToPoint:self.endPoint];
    [graphPath addLineToPoint:point];
    [graphPath closePath];
    self.path = graphPath.CGPath;

}

+(ZYDrawingLayer*)createLayerWithImage:(CGRect)imageSize withUrl:(NSString *)imageUrl
{
    ZYDrawingLayer* superLayer = [[ZYDrawingLayer alloc]init];
    CALayer* layer = [[CALayer alloc]init];
    layer.frame = imageSize;
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage* img = [UIImage imageWithData:imageData];
    layer.contents = (__bridge id)([img CGImage]);
    [superLayer addSublayer:layer];
     superLayer.startPoint = imageSize.origin;
    superLayer.imageLayer = layer;
    superLayer.type = GraphTypeImage;
    return superLayer;
}

-(void)changeImageLayerEndPoint:(CGPoint)endPoint
{
    self.endPoint = endPoint;
    [self dealupXYWithGraphSharpPoint:endPoint];
    self.imageLayer.frame = CGRectMake(self.minX, self.minY, self.maxX-self.minX, self.maxY-self.minY);
}
-(void)changeImageLayerSize:(CGRect)imageSize
{
    self.imageLayer.frame = imageSize;
    [self dealupXYWithSize:imageSize];
}

@end
