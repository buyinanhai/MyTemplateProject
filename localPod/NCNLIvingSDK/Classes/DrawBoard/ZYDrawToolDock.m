//
//  ZYDrawToolDock.m
//  YQD_Teach_iPad
//
//  Created by 纤夫的爱 on 2018/10/19.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYDrawToolDock.h"
#import "UIColor+Hex.h"
#import "ZYFontSizeSlider.h"
#define penWidth 28
#define colorBtnWidth 29
//#define gap (self.width - 4*penWidth - 5*colorBtnWidth)/10.0

//#define gap (self.width - 4*penWidth - 5*colorBtnWidth - 2*30)/10.0

@interface ZYDrawToolDock()<ZYFontSizeSliderDelegate>
@property (nonatomic, strong) NSArray          *colorArr;
@property (nonatomic, strong) NSArray          *fillColorArr;
@property (nonatomic, strong) NSArray          *penImageNameArr;
@property (nonatomic, strong) NSArray          *penWeightArr;
@property (nonatomic, strong) UIButton         *selectPenBtn;
@property (nonatomic, strong) CAShapeLayer     *selectColorLayer;
@property (nonatomic, strong) CAShapeLayer     *selectFillColorLayer;
@property (nonatomic, strong) ZYFontSizeSlider *slider;
@property (nonatomic, strong) UIBezierPath     *bezierPath;
@property (nonatomic, strong) UIView *fillColorView ;


@property (nonatomic, strong) UIBezierPath     *maskPath;
@property (nonatomic, strong) CAShapeLayer     *maskLayer;
@end

@implementation ZYDrawToolDock

//- (instancetype)initWithItems:(NSArray *)items {
//    if (self = [super init]) {
//        [self setUpSubViews];
//    }
//
//    return self;
//}

- (CAShapeLayer *)selectColorLayer
{
    if (!_selectColorLayer)
    {
        _selectColorLayer = [self creatSelectLayer];
    }
    return _selectColorLayer;
}

- (CAShapeLayer*)selectFillColorLayer
{
    if(!_selectFillColorLayer)
    {
        _selectFillColorLayer = [self creatSelectLayer];
    }
    return _selectFillColorLayer;
}

-(CAShapeLayer *)creatSelectLayer
{
    CAShapeLayer* selectLayer = [CAShapeLayer layer];
    selectLayer.bounds = CGRectMake(0, 0, 20, 20);
    selectLayer.lineWidth = 2;
    selectLayer.strokeColor = kColor9.CGColor;
    selectLayer.fillColor = nil;
    [selectLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:4.f],
      [NSNumber numberWithInt:2.f],nil]];
    //        self.bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10) radius:4 startAngle:0 endAngle:360 clockwise:YES] ;
    self.bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 20, 20)] ;
    selectLayer.contentsScale = 2*[UIScreen mainScreen].scale;
    selectLayer.path = self.bezierPath.CGPath;
    //--------
    selectLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    selectLayer.shouldRasterize = YES;
    return selectLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //        self.backgroundColor = [UIColor colorWithHexString:@"#3F4143"];
        //        self.penImageNameArr = @[@""];
        //  #6464B4 、#FFFFFF、#00FF00、#FF0000、#FFFF00
        //        self.colorArr = @[YQDColor(100, 100, 180, 1),[UIColor whiteColor],[UIColor greenColor],[UIColor redColor],[UIColor yellowColor]];
        //        self.colorArr = @[@"#6464B4",@"#FFFFFF",@"#00FF00",@"#FF0000",@"#FFFF00"];
        self.colorArr = @[@"#FFFF1900",@"#FFF85415",@"#FFFFE400",@"#FF00FF90",@"#FF01E2FC",@"#FF1E6DFF",@"#FFC908F9",@"#FFFFFFFF",@"#FFB3B3B3",@"#FF000000"];
        self.fillColorArr = @[@"#00000000",@"#FFFF1900",@"#FFF85415",@"#FFFFE400",@"#FF00FF90",@"#FF01E2FC",@"#FF1E6DFF",@"#FFC908F9",@"#FFFFFFFF",@"#FFB3B3B3"];
        self.penWeightArr = @[@0.0,@0.1,@0.5,@1.0];
        [self setMyMaskLayer];
        [self setUpSubViews];
    }
    
    return self;
}

- (void)setMyMaskLayer
{
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 65)];
    back.backgroundColor = [UIColor colorWithHexString:@"#3F4143"];
    back.layer.cornerRadius = 2.0;
    [self addSubview:back];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    //    maskLayer.backgroundColor = [UIColor redColor].CGCrolor;
    maskLayer.frame = CGRectMake(0, -5, self.width + 30, 5);
    //    maskLayer.cornerRadius = 2.0;
    
    //    maskLayer.fillColor = nil;
    maskLayer.fillColor = [UIColor colorWithHexString:@"#3F4143"].CGColor;
    
    //    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    //    maskLayer.lineWidth = 1;
    //    [maskLayer setLineDashPattern:
    //    [NSArray arrayWithObjects:[NSNumber numberWithInt:2.f],
    //     [NSNumber numberWithInt:2.f],nil]];
    
    UIBezierPath *mainpath = [UIBezierPath bezierPath];
    
    [mainpath moveToPoint:(CGPoint){10,5}];
    [mainpath addLineToPoint:(CGPoint){15,0}];
    
    [mainpath addLineToPoint:(CGPoint){20,5}];
    [mainpath closePath];
    
    //    UIBezierPath *lastPath = [UIBezierPath bezierPath];
    //    [lastPath moveToPoint:CGPointMake(15, 0)];
    //
    //    [lastPath addLineToPoint:(CGPoint){20,5}];
    //    [mainpath appendPath:lastPath];
    
    
    
    maskLayer.path = mainpath.CGPath;
    [self.layer addSublayer:maskLayer];
    
    self.maskLayer = maskLayer;
    //    self.maskPath = mainpath;
}

- (void)moveToX:(CGFloat)x{
    
    UIBezierPath *mainpath = [UIBezierPath bezierPath];
    //    [mainpath moveToPoint:(CGPoint){x,0}];
    //    [mainpath addLineToPoint:(CGPoint){x+5,-5}];
    //    [mainpath addLineToPoint:(CGPoint){x+10,0}];
    //    [mainpath closePath];
    
    
    [mainpath moveToPoint:(CGPoint){x,5}];
    [mainpath addLineToPoint:(CGPoint){x+5,0}];
    [mainpath addLineToPoint:(CGPoint){x+10,5}];
    [mainpath closePath];
    
    //    UIBezierPath *lastPath = [UIBezierPath bezierPath];
    //    [lastPath moveToPoint:CGPointMake(x+5, 0)];
    //
    //    [lastPath addLineToPoint:(CGPoint){x+10,5}];
    //    [mainpath appendPath:lastPath];
    
    self.maskLayer.path = mainpath.CGPath;
}


- (void)setUpSubViews
{
    [self setUpColorViews];
    [self setUpSlider];
    [self setUpFillColorViews];
}

- (void)setUpSlider
{
    ZYFontSizeSlider *slider = [[ZYFontSizeSlider alloc] initWithFrame:CGRectMake(0, 68, self.width, 40)];
    slider.delegate = self;
    [self addSubview:slider];
    self.slider = slider;
}

/*
 - (void)setUpPenViews
 {
 
 for (int i = 0; i<4; i++)
 {
 UIButton *penBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
 penBtn.frame = CGRectMake(30 + gap*(i+1) + penWidth*i, 40, penWidth, 60);
 penBtn.backgroundColor = [UIColor yellowColor];
 [penBtn addTarget:self action:@selector(clickPenAction:) forControlEvents:(UIControlEventTouchUpInside)];
 penBtn.tag = i + 2000;
 [self addSubview:penBtn];
 
 if (penBtn.tag == 2000) {//默认选中首个
 penBtn.frame =CGRectMake(30 + gap*(i+1) + penWidth*i, 10, penWidth, 60);
 self.selectPenBtn = penBtn;
 }
 
 }
 }
 */

- (void)setUpColorViews
{
    int lineMax = 5;
    CGFloat gap = (self.width - 5*colorBtnWidth)/6;
    
    for (int i = 0; i<10; i++)
    {
        UIButton *colorBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //        colorBtn.frame = CGRectMake(30 + 4*penWidth + gap*(i+1) + colorBtnWidth*(i-4), 38, colorBtnWidth, colorBtnWidth);
        colorBtn.frame = CGRectMake(gap + i%5*gap + i%5*colorBtnWidth,2+(i/lineMax)*(2+colorBtnWidth), colorBtnWidth, colorBtnWidth);
        
        colorBtn.backgroundColor =
        [UIColor colorWithHexString:self.colorArr[i]];
        [colorBtn addTarget:self action:@selector(clickColorBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        colorBtn.tag = i + 2000;
        [self addSubview:colorBtn];
        
        if (colorBtn.tag == 2000)
        {//默认选中第一个颜色
            [colorBtn.layer addSublayer:self.selectColorLayer];
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _selectColorLayer.position = CGPointMake(colorBtn.width/2, colorBtn.width/2);
            [CATransaction commit];
            
            
        }
        
    }
    
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [self setFillColorViewHidden:YES];
}

-(void)setFillColorViewHidden:(BOOL)hidden
{
    [_fillColorView setHidden:hidden];
}

- (void)setUpFillColorViews
{
    UIView *fillColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 111, self.width, 90)];
    fillColorView.backgroundColor = [UIColor colorWithHexString:@"#3F4143"];
    fillColorView.layer.cornerRadius = 2.0;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 25)];
    label.text = @"填充";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    UIFont* font = [UIFont systemFontOfSize:14];
    label.font = font;
    [fillColorView addSubview:label];
    int lineMax = 5;
    CGFloat gap = (self.width - 5*colorBtnWidth)/6;
    
    for (int i = 0; i<10; i++)
    {
        UIButton *fillColorBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //        colorBtn.frame = CGRectMake(30 + 4*penWidth + gap*(i+1) + colorBtnWidth*(i-4), 38, colorBtnWidth, colorBtnWidth);
        fillColorBtn.frame = CGRectMake(gap + i%5*gap + i%5*colorBtnWidth,27+(i/lineMax)*(2+colorBtnWidth), colorBtnWidth, colorBtnWidth);
        
        fillColorBtn.backgroundColor =
        [UIColor colorWithHexString:self.fillColorArr[i]];
        if(i==0)
        {
            fillColorBtn.backgroundColor = [UIColor whiteColor];
            // 线的路径
            UIBezierPath *linePath = [UIBezierPath bezierPath];
            // 起点
            [linePath moveToPoint:CGPointMake(fillColorBtn.frame.size.width,0)];
            [linePath addLineToPoint:CGPointMake(0, fillColorBtn.frame.size.height)];
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            lineLayer.lineWidth = 2;
            lineLayer.strokeColor = [UIColor redColor].CGColor;
            lineLayer.path = linePath.CGPath;
            lineLayer.fillColor = nil; // 默认为blackColor
            [fillColorBtn.layer addSublayer:lineLayer];
        }
        [fillColorBtn addTarget:self action:@selector(clickFillColorBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        fillColorBtn.tag = i + 3000;
        [fillColorView addSubview:fillColorBtn];
        
        if (fillColorBtn.tag == 3000)
        {//默认选中第一个颜色
            [fillColorBtn.layer addSublayer:self.selectFillColorLayer];
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _selectFillColorLayer.position = CGPointMake(fillColorBtn.width/2, fillColorBtn.width/2);
            [CATransaction commit];
            
            
        }
        
    }
    _fillColorView = fillColorView;
    [self addSubview:_fillColorView];
    
    
}



- (void)clickPenAction:(UIButton*)btn
{
    
    if (_selectPenBtn == btn)
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            btn.y = 20;
        } completion:^(BOOL finished) {
            btn.y = 10;
        }];
        
    }
    else
    {
        
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
            
            _selectPenBtn.y = 40;
            btn.y = 10;
            
        } completion:^(BOOL finished) {
            _selectPenBtn = btn;
        }];
        
        
        NSUInteger penIndex = btn.tag - 2000;
        NSNumber *value = self.penWeightArr[penIndex];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(penBtnCallBackWithPenWeight:)])
        {
            [self.delegate penBtnCallBackWithPenWeight:[value floatValue]];
        }
    }
    
}

- (void)clickColorBtnAction:(UIButton*)btn
{
    [_selectColorLayer removeFromSuperlayer];
    [btn.layer addSublayer:_selectColorLayer];
    
    _selectColorLayer.path = self.bezierPath.CGPath;//下动画
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"]; checkAnimation.duration = 0.25f; checkAnimation.fromValue = @(0.0f); checkAnimation.toValue = @(1.0f);
    //    checkAnimation.delegate = self;
    [_selectColorLayer addAnimation:checkAnimation forKey:@"checkAnimation"];
    
    NSUInteger colorIndex = btn.tag - 2000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorBtnCallBackWithColorHex:)])
    {
        [self.delegate colorBtnCallBackWithColorHex:self.colorArr[colorIndex]];
    }
    
}

- (void)clickFillColorBtnAction:(UIButton*)btn
{
    [_selectFillColorLayer removeFromSuperlayer];
    [btn.layer addSublayer:_selectFillColorLayer];
    
    _selectFillColorLayer.path = self.bezierPath.CGPath;//下动画
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"]; checkAnimation.duration = 0.25f; checkAnimation.fromValue = @(0.0f); checkAnimation.toValue = @(1.0f);
    //    checkAnimation.delegate = self;
    [_selectFillColorLayer addAnimation:checkAnimation forKey:@"checkAnimation"];
    
    NSUInteger colorIndex = btn.tag - 3000;
    UIColor * fillColor = [UIColor colorWithHexString:self.fillColorArr[colorIndex]];
    [NCDrawManager ShareInstance].fillColor = fillColor;
    
}


#pragma mark - 滑块代理
- (void)sendCurrentSliderValue:(float)value
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(penBtnCallBackWithPenWeight:)])
    {
        [self.delegate penBtnCallBackWithPenWeight:value];
    }
}

@end
