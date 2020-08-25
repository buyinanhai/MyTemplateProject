//
//  ZYFontSizeSlider.m
//  YQD_Student_iPad
//
//  Created by 纤夫的爱 on 2018/10/23.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYFontSizeSlider.h"
#import "UIColor+Hex.h"
@interface ZYFontSizeSlider()
@property (nonatomic,strong) UISlider *slider;
@end
@implementation ZYFontSizeSlider
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 2.0;
        self.backgroundColor = [UIColor colorWithHexString:@"#3F4143"];
        [self setUpViews];
    }
    return self;
}



- (void)setUpViews{
    UIView *sBall = [[UIView alloc] initWithFrame:CGRectMake(10, 12, 4, 4)];
    sBall.layer.cornerRadius = 2;
    sBall.backgroundColor = [UIColor colorWithHexString:@"#1F2124"];

    UIView *bBall = [[UIView alloc] initWithFrame:CGRectMake(self.width - 10, 10, 8, 8)];
    bBall.layer.cornerRadius = 4;
    bBall.backgroundColor = [UIColor colorWithHexString:@"#1F2124"];
    
    UISlider *slider = [[UISlider alloc] init];
    slider.frame = CGRectMake(20, 0, self.width - 40, 30);
    [slider addTarget:self action:@selector(sliderValue:) forControlEvents:(UIControlEventValueChanged)];
    
    slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#606366"];
    slider.maximumTrackTintColor = [UIColor colorWithHexString:@"#606366"];
    
    [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:(UIControlStateNormal)];
    
    slider.layer.cornerRadius = 4.0;
    slider.layer.masksToBounds = YES;

    
    self.slider = slider;
    
    [self addSubview:sBall];
    [self addSubview:bBall];
    [self addSubview:slider];
}

- (void)sliderValue:(UIControl *)object
{
    UISlider *slide = (UISlider *)object;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendCurrentSliderValue:)])
    {
        [self.delegate sendCurrentSliderValue:slide.value];
    }
}

@end
