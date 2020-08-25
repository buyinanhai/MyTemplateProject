//
//  LineLayer.m
//  YQD_Student_iPad
//
//  Created by 陈嘉杰 on 2018/11/3.
//  Copyright © 2018 牛师帮. All rights reserved.
//

#import "LineLayer.h"
#import "CALayer+CanvasProperty.h"


@interface LineLayer()
@property (nonatomic,strong) NSMutableArray* pointList;
@end

@implementation LineLayer

+ (LineLayer*)createLine:(NSString*)lId withColor:(UIColor *)color withWeight:(float)weight
{
    LineLayer* layer = [[[self class] alloc] initWithColor:color withWeight:weight];
    [layer setLId:lId];
    [layer setIsSelected:NO];
    [layer setColor:color];
    return layer;
}

- (instancetype)initWithColor:(UIColor *)color withWeight:(float)weight{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.strokeColor = color.CGColor;
        self.fillColor = nil;
        self.lineJoin = kCALineJoinRound;
        self.lineCap = kCALineCapRound;
        self.lineWidth = 5*weight +1;
    }
    return self;
}

-(void) lineWithPointList:(NSMutableArray<NSString*>*)pointList
{
    if(pointList.count<1)
        return;
    int index = 0;
    UIBezierPath *path;
    if(!self.path)
    {
        path = [UIBezierPath bezierPath];
        path.lineJoinStyle = kCGLineJoinRound;
        path.lineCapStyle = kCGLineCapRound;
        path.flatness = 0.1;
        CGPoint startPoint = CGPointFromString(pointList[0]);
        [path moveToPoint:startPoint];
        [self dealupContainRect:startPoint];
        index = 1;
    }
    else
    {
        path = [UIBezierPath bezierPathWithCGPath:self.path];
        index = 0;
    }
    for (; index<pointList.count; index++)
    {
        CGPoint point = CGPointFromString(pointList[index]);
        [path addLineToPoint:point];
        [self dealupContainRect:point];
    }
    self.path = path.CGPath;
}

-(void)moveLayer:(CGSize)offsetDistance
{

    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.path];
    [path applyTransform:CGAffineTransformMakeTranslation(offsetDistance.width , offsetDistance.height)];
    self.path = path.CGPath;
    [self offsetContainRect:offsetDistance];
    if(self.isSelected)
        [self offsetDashedLineLayer:offsetDistance];
}

-(void)select:(BOOL)isSelected
{
    if (self.isSelected == isSelected)
        return;
    self.isSelected = isSelected;
    self.dashedLineLayer.hidden = !isSelected;
    if (isSelected) {
        self.strokeColor = SELECTED_COLOR;
        [self updateDashedLineLayer];
    }
    else
    {
        self.strokeColor = self.color.CGColor;
    }
}


@end
