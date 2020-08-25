//
//  UIView+Extension.m
//  
//
//  Created by Fire on 15/7/27.
//  Copyright (c) 2015年 Fire. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)


- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}


- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}


- (void)setCenterX:(CGFloat)centerX{
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (CGSize)size{
    return self.frame.size;
}

-(CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (UIView *)alignParentCenter
{
    return [self alignParentCenter:CGPointMake(0, 0)];
}

- (UIView *)alignParentCenter:(CGPoint)margin
{
    CGRect sbounds = self.superview.bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(sbounds), CGRectGetMidY(sbounds));
    center.x += margin.x;
    center.y += margin.y;
    self.center = center;
    return self;
}

// 控件在父控控件中的位置
// 水平居中
// 只影响其坐标位置，不影响其大小
- (UIView *)layoutParentHorizontalCenter
{
    CGPoint center = CGPointZero;
    CGRect srect = self.superview.bounds;
    center.x = CGRectGetMidX(srect);;
    center.y = self.center.y;
    self.center = center;
    return self;
}

- (UIView *)alignParentBottomWithMargin:(CGFloat)margin
{
    CGRect superBounds = self.superview.bounds;
    CGRect rect = self.frame;
    rect.origin.y = superBounds.origin.y + superBounds.size.height - margin - rect.size.height;
    self.frame = rect;
    return self;
}

// 居中
- (UIView *)layoutParentCenter
{
    CGRect rect = self.superview.bounds;
    self.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    return self;
}


- (UIView *)move:(CGPoint)vec
{
    CGPoint c = self.center;
    c.x += vec.x;
    c.y += vec.y;
    self.center = c;
    return self;
}

- (void)sl_setBorderWidth:(CGFloat)width borderColor:(CGColorRef)color cornerR:(CGFloat)cornerR {
    self.layer.borderWidth = width;
    self.layer.borderColor = color;
    self.layer.cornerRadius = cornerR;
    self.layer.masksToBounds = YES;
}

- (void)sl_setCornerRadius:(CGFloat)cornerR {
    self.layer.cornerRadius = cornerR;
    self.layer.masksToBounds = YES;
}

+ (UIView *)sl_line {
    UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 0.5)];
    l.backgroundColor = kRGB(233, 233, 233);
    return l;
}

+ (UIView *)sl_getDotView:(UIColor *)col width:(CGFloat)w {
    if (!col) {
        col = kRGBHEX(@"FF4500");
    }
    
    if (w < 0.01) {
        w = 10.0;
    }
    
    UIView *v = [[UIView alloc] init];
    v.bounds = CGRectMake(0, 0, w, w);
    v.layer.cornerRadius = w * 0.5;
    v.layer.masksToBounds = YES;
    v.backgroundColor = col;
    
    return v;
}

-(UIView *)addBadge:(UIColor *)col {
    
    UIView *dot = [self viewWithTag:60007];
    if (dot) {
        return dot;
    }
    CGFloat w = 8.0;
    dot = [UIView sl_getDotView:col width:w];
    dot.tag = 60007;
    CGFloat dx = self.width - w;
    dot.frame = CGRectMake(dx, w, w, w);
    [self addSubview:dot];
    return dot;
}

-(void)removeBadge {

    UIView *dot = [self viewWithTag:60007];
    [dot removeFromSuperview];
}

-(void)setShadow {
    [self setShadowColor:[UIColor colorWithWhite:0.8 alpha:1.0] shadowR:5.0 cornerR:0];
}


-(void)setShadowColor:(UIColor *)c shadowR:(CGFloat)sr cornerR:(CGFloat)cr {
    
    
    self.layer.shadowColor = c.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,-1);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = sr;
    self.layer.cornerRadius = cr;

}

+ (instancetype)viewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (UIViewController *)mm_viewController {
    UIView *view = self;
    while (view) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        view = view.superview;
      }
    return nil;
}

- (void)living_addShadowWithCornerRadius:(CGFloat)cornerRadius {
    
    self.layer.shadowColor = [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:0.2].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,-1);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 5;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = false;
    
}

static CGFloat rRadii = 8.0f;//默认圆角大小
- (void)living_addCornersAndShadow {
    [self living_addCorners:UIRectCornerAllCorners rRadii:rRadii shadowLayer:NULL];
}

- (void)living_addCorners:(UIRectCorner)corners
       shadowLayer:(void (^)(CALayer * shadowLayer))shadowLayer{
    
    [self living_addCorners:corners rRadii:rRadii shadowLayer:shadowLayer];
}
- (void)living_addCorners:(UIRectCorner)corners
            rRadii:(CGFloat)rRadii{
    
    [self living_addCorners:corners rRadii:rRadii shadowLayer:^(CALayer * shadowLayer) {
        shadowLayer.shadowOpacity = 0.25;
        shadowLayer.shadowOffset = CGSizeZero;
        shadowLayer.shadowRadius = 10;
    }];
}

- (void)living_addCorners:(UIRectCorner)corners
            rRadii:(CGFloat)rRadii
       shadowLayer:(nullable void (^)(CALayer * shadowLayer))shadowLayer{
    
    UIView * aview = self;
    CGSize cornerRadii = CGSizeMake(rRadii, rRadii);
    
    //前面的裁剪
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [UIBezierPath bezierPathWithRoundedRect:aview.bounds
    byRoundingCorners:corners cornerRadii:cornerRadii].CGPath;
    aview.layer.mask = mask;
   
    //后面的那个
    if(!aview.superview) return;
    UIView * draftView = [[UIView alloc] initWithFrame:aview.frame];
    draftView.backgroundColor = aview.backgroundColor;
    [aview.superview insertSubview:draftView belowSubview:aview];
    
    if(shadowLayer){
        shadowLayer(draftView.layer);
    }else{
        draftView.layer.shadowOpacity = 0.25;
        draftView.layer.shadowOffset = CGSizeZero;
        draftView.layer.shadowRadius = 10;
    }
    
    draftView.backgroundColor = nil;
    draftView.layer.masksToBounds = NO;
    
    CALayer *cornerLayer = [CALayer layer];
    cornerLayer.frame = draftView.bounds;
    cornerLayer.backgroundColor = aview.backgroundColor.CGColor;

    CAShapeLayer *lay = [CAShapeLayer layer];
    lay.path = [UIBezierPath bezierPathWithRoundedRect:aview.bounds
    byRoundingCorners:corners cornerRadii:cornerRadii].CGPath;
    cornerLayer.mask = lay;
    [draftView.layer addSublayer:cornerLayer];
}




@end
