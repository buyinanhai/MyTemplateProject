//
//  ZYTextLayer.m
//  YQD_Student_iPad
//
//  Created by 王志盼 on 2018/6/29.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYTextLayer.h"
#import "UIColor+Hex.h"
#define ZYDRAWINGORIGINCOLOR YQDColor(100, 100, 180, 1).CGColor
#define ZYDRAWINGSELECTEDCOLOR [UIColor redColor].CGColor
#define ZYMaxValue 999999

@interface ZYTextLayer()

//选中后的虚线
@property (nonatomic, strong) CAShapeLayer *dashedLineLayer;
@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, assign) CGPoint startPoint;    /**< 起始坐标 */
@property (nonatomic, assign) CGPoint endPoint;    /**< 终点坐标 */


@end

@implementation ZYTextLayer
//初始化
- (instancetype)initWithFontColor:(uint32_t)chooseColor weight:(float)weight
{
    if (self = [super init])
    {
        self.minX = ZYMaxValue;
        self.minY = ZYMaxValue;
        self.maxX = -ZYMaxValue;
        self.maxY = -ZYMaxValue;
        self.chooseColor = chooseColor;
        self.weight = weight;
        [self commitInit];
    }
    return self;
}


//- (instancetype)init
//{
//    if (self = [super init]){
//        
//        self.minX = ZYMaxValue;
//        self.minY = ZYMaxValue;
//        self.maxX = -ZYMaxValue;
//        self.maxY = -ZYMaxValue;
//        [self commitInit];
//    }
//    return self;
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commitInit];
}

- (void)commitInit
{
//    self.font = kFont30;
    //    self.userInteractionEnabled = false;
    
//    self.font = [UIFont fontWithName:@"SimSun" size:13];
//    self.userInteractionEnabled = YES;
//
//    self.layer.masksToBounds = YES;
//    //加换行
//    self.numberOfLines = 0;
//
//
//    self.textColor = YQDColor(100, 100, 180, 1);
//    self.textAlignment = NSTextAlignmentLeft;
    float fontWeight = self.weight*27 + 18.0;
    UIFont *font = [UIFont fontWithName:@"SimSun" size:(CGFloat)fontWeight];
//    UIFont *font = [UIFont systemFontOfSize:(CGFloat)fontWeight];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    
    self.font = fontRef;
    self.fontSize = font.pointSize;
    
//    self.foregroundColor = YQDColor(100, 100, 180, 1).CGColor;
    self.foregroundColor = [UIColor colorWithHexInt:self.chooseColor].CGColor;
    
    //将显示模糊变清新 -- 需要比较内存占用量
    self.contentsScale = [UIScreen mainScreen].scale;
    
    //自动换行
    self.wrapped = YES;
    
}


- (BOOL)isEqual:(ZYTextLayer *)object
{
    if (object == nil || object.lId == nil || object.lId.length == 0) return false;
    
    if ([object.lId isEqualToString:self.lId]) return true;
    
    return false;
}


//- (CGRect)containRect
//{
//    CGFloat minX = self.minX - 2;
//    CGFloat minY = self.minY - 2;
//    CGFloat maxX = self.maxX + 2;
//    CGFloat maxY = self.maxY + 2;
//    CGFloat width = maxX - minX;
//    CGFloat height = maxY - minY;
//    return CGRectMake(minX, minY, width, height);
//}

- (void)setIsSelected:(BOOL)isSelected {
    
    if (_isSelected == isSelected) return;
    _isSelected = isSelected;
    
    if (isSelected)
    {
//        self.strokeColor = self.fillColor = ZYDRAWINGSELECTEDCOLOR;
        self.dashedLineLayer.hidden = false;
    }
    else
    {
        self.dashedLineLayer.hidden = true;
    }
}

- (CAShapeLayer *)dashedLineLayer
{
    
    if (!_dashedLineLayer)
    {
        _dashedLineLayer = [CAShapeLayer layer];
        [self addSublayer:_dashedLineLayer];
    }
//    CGFloat minX = self.minX - 2;
//    CGFloat minY = self.minY - 2;
//    CGFloat maxX = self.maxX + 2;
//    CGFloat maxY = self.maxY + 2;
//    CGFloat width = maxX - minX;
//    CGFloat height = maxY - minY;
    
    CGFloat minX = self.bounds.origin.x - 2;
    CGFloat minY = self.bounds.origin.y - 2;
    CGFloat maxX = self.bounds.origin.x  + 2 + self.bounds.size.width;
    CGFloat maxY = self.bounds.origin.y  + 2 + self.bounds.size.height;
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


- (void)moveGrafiitiPathPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint {
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.path];
//    [path applyTransform:CGAffineTransformMakeTranslation(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)];
//    self.path = path.CGPath;
    
    //去掉隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    
    self.position = CGPointMake(self.position.x + currentPoint.x - previousPoint.x, self.position.y + currentPoint.y - previousPoint.y);
    
    [CATransaction commit];
    
    _dashedLineLayer.hidden = !self.isSelected;
}

//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    
//    self.startPoint = frame.origin;
//}
@end
