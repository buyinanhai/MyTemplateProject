//
//  NCNCategoryStripView.m
//  XYClassRoom
//
//  Created by lzh on 2018/7/19.
//  Copyright © 2018年 newcloudnet. All rights reserved.
//

#import "NCNCategoryStripView.h"
#import "UIView+Extension.h"

@interface NCNCategoryStripView ()

@property (strong,nonatomic) NSMutableArray *categoryBtns;
@property (weak,nonatomic) UIButton *selectedBtn;
@property (strong,nonatomic) UIView *slider;
@property (assign,nonatomic) BOOL layoutReady;

@property (assign,nonatomic) BOOL needScr;  ///< 如果按钮没铺满，就不需要滚动了 默认YES

@end



@implementation NCNCategoryStripView


-(void)setSliderH:(CGFloat)sliderH {
    _sliderH = sliderH;
    _slider.y += _slider.height - sliderH;
    _slider.height = sliderH;
}

-(void)setCategoryNames:(NSArray *)categoryNames {

    if (!categoryNames) {
        while (self.subviews.count) {
            [self.subviews.lastObject removeFromSuperview];
        }
        _categoryNames = categoryNames;
        [_categoryBtns removeAllObjects];
        return ;
    }
    
    if (_categoryNames) {
        NSUInteger oldCt = _categoryNames.count;
        NSUInteger newCt = categoryNames.count;
        _categoryNames = categoryNames;
        if (oldCt > newCt) {
            [self.categoryBtns enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj.tag+1 > newCt) {
                    [self.categoryBtns removeObjectAtIndex:idx];
                    [obj removeFromSuperview];
                }else {
                    [self setBtn:obj title:categoryNames[idx] at:idx];
                }
            }];
            
        }else if (newCt > oldCt) {
           [self addCtgBtnsFromIndex:oldCt];
        }
        
        self.layoutReady = NO;
        [self setNeedsLayout];
        [self layoutIfNeeded];
        return ;
    }
    
    _categoryNames = categoryNames;
    [self addCtgBtnsFromIndex:0];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.needEvenly = YES;
        self.needScr = YES;
        self.btnGap = 5.0;
        self.sliderH = 3;
    }
    return self;
}


- (void)addCtgBtnsFromIndex:(int)index {

    [self.categoryNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < index) {
            [self setBtn:self.categoryBtns[idx] title:obj at:idx];
            return ; // 跳下一个
        }
        
        UIButton *btn = [UIButton new];
        if (self.btnCornerRadius > 0) {
            btn.layer.cornerRadius = self.btnCornerRadius;
            btn.layer.masksToBounds = YES;
        }
        
        if (idx == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
        }
        
        [self setBtn:btn title:obj at:idx];
        [btn addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.categoryBtns addObject:btn];
        [self addSubview:btn];
    }];

    if (!_slider) {
        [self addSubview:self.slider];
    }

}

- (void)setBtn:(UIButton *)btn title:(NSString *)name at:(int)idx {
    
    UIFont *font = self.textFont ? self.textFont : FontScaleC(SLMainFontSize);
    UIFont *fontS = self.textFontSelected ? self.textFontSelected : FontScaleC(SLMainFontSize);
    UIColor *textColorN = self.textColorNormal ? self.textColorNormal : TitleColor;
    UIColor *textColorS = self.textColorSelected ? self.textColorSelected : MainTextColor;
    
    if (self.selectColorArr && self.selectColorArr.count > 0) {
        int colIdx = idx % (self.selectColorArr.count);
        textColorS = self.selectColorArr[colIdx];
    }
    
    if (self.textGap > 0 || self.selectColorArr || self.textFontSelected) {
        NSDictionary *attrND = @{NSKernAttributeName:@(self.textGap),
                                 NSForegroundColorAttributeName:textColorN,
                                 NSFontAttributeName:font
                                 };
        NSDictionary *attrSD = @{NSKernAttributeName:@(self.textGap),
                                 NSForegroundColorAttributeName:textColorS,
                                 NSFontAttributeName:fontS
                                 };
        NSAttributedString *attrNStr= [[NSAttributedString alloc] initWithString:name attributes:attrND];
        NSAttributedString *attrSStr= [[NSAttributedString alloc] initWithString:name attributes:attrSD];
        [btn setAttributedTitle:attrNStr forState:UIControlStateNormal];
        [btn setAttributedTitle:attrSStr forState:UIControlStateSelected];
    }else {
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:textColorN forState:UIControlStateNormal];
        [btn setTitleColor:textColorS forState:UIControlStateSelected];
    }
    
    btn.tag = idx;
    btn.titleLabel.font = font;
    [btn sizeToFit];
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (_categoryBtns.count < 1 || self.layoutReady) {
        return ;
    }
    
    self.layoutReady = YES;
    CGFloat btnY = 0;
    __block CGFloat totalW = 0;
    CGFloat btnH = self.height;
    
    [_categoryBtns enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [btn sizeToFit];
        CGFloat btnW = CGRectGetWidth(btn.bounds) + 2*self.btnGap;
        if (self.minBtnW > btnW) {
            btnW = self.minBtnW;
        }
        btn.frame = CGRectMake(totalW, btnY, btnW, btnH);
        totalW += btnW;
        
    }];
    totalW += 10;
    CGFloat plusW = 0;
    if (self.needEvenly && totalW < self.width - 5) {
        plusW = (self.width - totalW) / _categoryBtns.count;
        totalW = 0;
        
        [_categoryBtns enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat btnW = btn.width + plusW;
            btn.frame = CGRectMake(totalW, btnY, btnW, btnH);
            totalW += btnW;

        }];
        
        self.contentSize = CGSizeMake(self.width, 0);
    }else {
        self.contentSize = CGSizeMake(totalW, 0);
    }
    
    if (totalW < self.width - 5) {
        self.needScr = NO;
    }else {
        self.needScr = YES;
    }
    
    CGFloat x = (self.selectedBtn.width - self.sliderWidth) * 0.5;
    _slider.frame = CGRectMake(x, self.height - self.sliderH, self.sliderWidth, self.sliderH);
}


- (void)clickCategoryButton:(UIButton *)sender {
    NSLog(@"点击了分类 %zd",sender.tag);

    if ([self.actionDelegate respondsToSelector:@selector(categoryStripView:selectedButton:)]) {
        kWeakSelf(self);
        [self.actionDelegate categoryStripView:weakself selectedButton:sender.tag];
    }
    [self moveTo:sender.tag];
    
}



- (void)moveTo:(NSInteger)idx {
    
    self.selectedBtn.selected = NO;
    self.selectedBtn.backgroundColor = [UIColor clearColor];
    
    UIColor *btnSltC = self.btnColorSelected ? self.btnColorSelected : [UIColor clearColor];
    UIButton *btn = self.categoryBtns[idx];
    btn.selected = YES;
    btn.backgroundColor = btnSltC;
    self.selectedBtn = btn;
    
    if (self.needScr) {        
        CGFloat offsetX = btn.center.x - self.frame.size.width * 0.5;
        if (offsetX < 0) {
            offsetX = 0;
        }else {
            CGFloat maxOffsetX = self.contentSize.width - self.frame.size.width;
            if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        }
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat sldX = (btn.width - self.sliderWidth) * 0.5 + btn.width * idx;
            CGRect newFrame = self.slider.frame;
            newFrame.origin.x = sldX;
            self.slider.frame = newFrame;
            if (self.selectColorArr) {
                _slider.backgroundColor = self.selectColorArr[idx % self.selectColorArr.count];
            }
        }];
    });
    
}

- (NSInteger)getSelectedIndex {
    return self.selectedBtn.tag;
}

#pragma mark - lazy
-(UIView *)slider {
    if (!_slider) {
        _slider = [[UIView alloc] init];
        // 初始第一个是选中状态，x 值为10
        CGFloat btnW = self.sliderWidth;
       
        _slider.frame = CGRectMake(10, self.height - 3, btnW, 3);
        
        if (self.selectColorArr) {
            _slider.backgroundColor = self.selectColorArr[0];
        }else {
            _slider.backgroundColor = MainTextColor;
        }
    }
    return _slider;
}

-(NSMutableArray *)categoryBtns {
    if (!_categoryBtns) {
        _categoryBtns = [NSMutableArray array];
    }
    return _categoryBtns;
}

- (CGFloat)sliderWidth {
    
    if (_sliderWidth > 0) {
        return _sliderWidth;
    }
    return 12;
}

@end
