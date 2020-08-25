//
//  ZYMathGraphDock.m
//  YQD_Student_iPad
//
//  Created by 纤夫的爱 on 2018/10/22.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYMathGraphDock.h"
#import "UIColor+Hex.h"

@interface ZYMathGraphDock()
@property (nonatomic, strong) UIButton *selectmathGraphBtn;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation ZYMathGraphDock
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = kColor9;
        self.titleArray = @[@"直线",@"椭圆",@"圆",@"三角形",@"矩形"];
        [self setMyMastLayer];
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    for (int i=0; i<5; i++) {
        UIButton *mathGraphBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        mathGraphBtn.frame = CGRectMake(5, 10 + i*(10 +30), 50, 30);
//        mathGraphBtn.backgroundColor = [UIColor yellowColor];
        [mathGraphBtn addTarget:self action:@selector(clickMathBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        mathGraphBtn.tag = i;
        [mathGraphBtn setTitle:_titleArray[i] forState:(UIControlStateNormal)];
        mathGraphBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [mathGraphBtn setTitleColor:kColor2 forState:(UIControlStateNormal)];
        [mathGraphBtn setTitleColor:kColorWhite forState:(UIControlStateSelected)];
        [self addSubview:mathGraphBtn];
        
        if (mathGraphBtn.tag == 0) {//默认选中首个
            mathGraphBtn.selected = YES;
            self.selectmathGraphBtn = mathGraphBtn;
        }
    }
}

//设置蒙版
- (void)setMyMastLayer
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.backgroundColor = kColor9.CGColor;
    maskLayer.frame = CGRectMake(-5, 0, self.width+5, self.height);
//    maskLayer.strokeColor = kColorWhite.CGColor;
    maskLayer.fillColor = [UIColor colorWithHexString:@"#3F4143"].CGColor;
    maskLayer.lineWidth = 1;
    
    UIBezierPath *mainpath = [UIBezierPath bezierPath];
    [mainpath moveToPoint:(CGPoint){5,160}];
    [mainpath addLineToPoint:(CGPoint){0,165}];
    [mainpath addLineToPoint:(CGPoint){5,170}];
    [mainpath addLineToPoint:(CGPoint){5,self.height}];
    [mainpath addLineToPoint:(CGPoint){self.width+5,self.height}];
    [mainpath addLineToPoint:(CGPoint){self.width+5,0}];
    [mainpath addLineToPoint:(CGPoint){5,0}];
    [mainpath closePath];
    
    
    maskLayer.path = mainpath.CGPath;
    [self.layer addSublayer:maskLayer];
}

- (void)clickMathBtnAction:(UIButton*)btn
{
    _selectmathGraphBtn.selected = NO;
    btn.selected = !btn.selected;
    NSUInteger index = btn.tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mathGraphBtnCallBackWithTag:)])
    {
        [self.delegate mathGraphBtnCallBackWithTag:index];
    }
    
    _selectmathGraphBtn = btn;
}

@end
