//
//  CALayer+CanvasProperty.m
//  YQD_Student_iPad
//
//  Created by 陈嘉杰 on 2018/11/7.
//  Copyright © 2018 牛师帮. All rights reserved.
//
#import "CALayer+CanvasProperty.h"
#import <objc/runtime.h>



static NSString *lIdKey = @"lIdKey";
static NSString *isSelectedKey = @"isSelectedKey";
static NSString *containRectKey = @"containRectKey";
static NSString *colorKey = @"colorKey";
static NSString *dashedLineLayerKey = @"dashedLineLayerKey";
@implementation CALayer(CanvasProperty)
#pragma mark - getter setter
@dynamic lId;
@dynamic isSelected;
@dynamic containRect;
@dynamic color;
@dynamic dashedLineLayer;

-(NSString*)lId
{
    return objc_getAssociatedObject(self, &lIdKey);
}

- (void)setLId:(NSString *)lId{

    objc_setAssociatedObject(self, &lIdKey, lId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(BOOL)isSelected
{
    return [objc_getAssociatedObject(self, &isSelectedKey) boolValue];
}

-(void)setIsSelected:(BOOL)isSelected
{
    objc_setAssociatedObject(self, &isSelectedKey,[NSNumber numberWithBool:isSelected], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGRect)containRect
{
    return CGRectFromString(objc_getAssociatedObject(self, &containRectKey));
}

-(void)setContainRect:(CGRect)containRect
{
    objc_setAssociatedObject(self, &containRectKey, NSStringFromCGRect(containRect), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor*)color
{
    return objc_getAssociatedObject(self, &colorKey);
}

-(void)setColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &colorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



#pragma mark -

-(void)dealupContainRect:(CGPoint)point
{
    if(!objc_getAssociatedObject(self, &containRectKey))
    {
        CGRect rect = CGRectMake(point.x, point.y, 0, 0);
        [self setContainRect:rect];
    }
    else
    {
        CGPoint minPoint = self.containRect.origin;
        CGPoint maxPoint = CGPointMake(minPoint.x+self.containRect.size.width, minPoint.y+self.containRect.size.height);
        minPoint = CGPointMake(MIN(minPoint.x,point.x), MIN(minPoint.y, point.y));
        maxPoint = CGPointMake(MAX(maxPoint.x, point.x), MAX(maxPoint.y,point.y));
        CGRect rect = CGRectMake(minPoint.x, minPoint.y, maxPoint.x-minPoint.x, maxPoint.y-minPoint.y);
        [self setContainRect:rect];
    }
}

-(void)offsetContainRect:(CGSize)offsetDistance
{
    CGRect rect = CGRectOffset(self.containRect, offsetDistance.width, offsetDistance.height);
    [self setContainRect:rect];
}

-(CAShapeLayer*)dashedLineLayer
{
    if(!objc_getAssociatedObject(self, &dashedLineLayerKey))
    {
        CAShapeLayer* dashedLayer = [CAShapeLayer layer];
        [self addSublayer:dashedLayer];
        objc_setAssociatedObject(self, &dashedLineLayerKey, dashedLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [dashedLayer setFillColor:[[UIColor clearColor] CGColor]];
        [dashedLayer setStrokeColor:[[UIColor redColor] CGColor]];
        //设置虚线的高度
        [dashedLayer setLineWidth:1.0f];
        //设置类型
        [dashedLayer setLineJoin:kCALineJoinRound];
        [dashedLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:6.f],[NSNumber numberWithInt:3.f],nil]];
        dashedLayer.frame = self.containRect;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-2, -2, self.containRect.size.width+4, self.containRect.size.height+4)];
        [dashedLayer setPath:path.CGPath];
    }
    return objc_getAssociatedObject(self, &dashedLineLayerKey);
}

-(void)offsetDashedLineLayer:(CGSize)offsetDistance
{
    UIBezierPath* path = [UIBezierPath bezierPathWithCGPath:self.dashedLineLayer.path];
    [path applyTransform:CGAffineTransformMakeTranslation(offsetDistance.width , offsetDistance.height)];
    self.dashedLineLayer.path = path.CGPath;
}

-(void)updateDashedLineLayer
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-2, -2, self.containRect.size.width+4, self.containRect.size.height+4)];
    self.dashedLineLayer.path = path.CGPath;
}

@end
