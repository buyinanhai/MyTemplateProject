//
//  ZYDrawTextField.m
//  YQD_Student_iPad
//
//  Created by 纤夫的爱 on 2018/10/11.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYDrawTextField.h"
#import "UIColor+Hex.h"

@implementation ZYDrawTextField
- (instancetype)init
{
    if (self = [super init])
    {
        //FiraSans-Bold //SimSun
        self.font = [UIFont fontWithName:@"SimSun" size:18];
        self.textColor = YQDColor(100, 100, 180, 1);
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = YQDColor(100, 100, 180, 1).CGColor;
        self.layer.borderWidth = 1;
        self.text = @"请点击输入";
    }
    return self;
}

- (instancetype)initWithFontColor:(uint32_t)chooseColor weight:(float)weight
{
    if (self = [super init])
    {
        
        self.chooseColor = chooseColor;
        self.weight = weight;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = YQDColor(100, 100, 180, 1).CGColor;
        self.layer.borderWidth = 1;
        self.text = @"请点击输入";
        
        //FiraSans-Bold //SimSun
//        self.font = [UIFont fontWithName:@"FiraSans-Bold" size:18];
//        self.textColor = YQDColor(100, 100, 180, 1);
        
        
        float fontWeight = self.weight*27 + 18.0;
        UIFont *font = [UIFont fontWithName:@"SimSun" size:(CGFloat)weight];
        self.font = font;
        
        self.textColor = [UIColor colorWithHexInt:self.chooseColor];
    }
    return self;
   
}

#pragma mark - 设置字体大小、颜色
- (void)setWeight:(float)weight
{
    _weight = weight;
    float fontWeight = weight*27 + 18.0;
    UIFont *font = [UIFont fontWithName:@"SimSun" size:(CGFloat)fontWeight];
    self.font = font;
}

- (void)setChooseColor:(uint32_t)chooseColor
{
    _chooseColor = chooseColor;
    self.textColor = [UIColor colorWithHexInt:chooseColor];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
