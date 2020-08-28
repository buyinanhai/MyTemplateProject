//
//  WDButton.m
//  国学
//
//  Created by 老船长 on 2017/11/22.
//  Copyright © 2017年 汪宁. All rights reserved.
//


#import "DYButton.h"

@interface DYButton ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *,UIColor *> *backgroundColorCache;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,UIColor *> *borderColorCache;

@end

@implementation DYButton


- (void)setText:(NSString *)text {
    [self setTitle:text forState:UIControlStateNormal];
}
- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}
- (void)setTextColor:(UIColor *)textColor {
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)setSeleText:(NSString *)text {
    [self setTitle:text forState:UIControlStateSelected];
}
- (void)setSeleImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateSelected];
}
- (void)setSeleTextColor:(UIColor *)textColor {
    [self setTitleColor:textColor forState:UIControlStateSelected];
}

- (void)setHighlightText:(NSString *)text {
    [self setTitle:text forState:UIControlStateHighlighted];
}
- (void)setHighlightImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateHighlighted];
}
- (void)setHighlightTextColor:(UIColor *)textColor {
    [self setTitleColor:textColor forState:UIControlStateHighlighted];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.direction == 1) {
        CGSize titleSize = self.titleLabel.bounds.size;
        CGSize imageSize = self.imageView.bounds.size;
        CGFloat interval = 0.1;
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + self.margin, -(titleSize.width + interval))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width + interval), 0, 0)];
    } else if (self.direction == 2) {
        CGSize titleSize = self.titleLabel.bounds.size;
        CGSize imageSize = self.imageView.bounds.size;
        self.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width, 0, -titleSize.width + -self.margin);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
    } else if (self.direction == 3) {
        [self.titleLabel sizeToFit];
        self.imageView.frame = self.bounds;
        self.titleLabel.frame = self.imageView.frame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self bringSubviewToFront:self.titleLabel];
    }
}


- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    _masksToBounds = masksToBounds;
    self.layer.masksToBounds = masksToBounds;
}


//如果是外面设置就是针对于normal的state
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColorCache[@(UIControlStateNormal)] = backgroundColor;
    [super setBackgroundColor:backgroundColor];
}
- (void)setSelectedBackColor:(UIColor *)selectedBackColor {
    
    _selectedBackColor = selectedBackColor;
    
    [self dy_setBackgroundColor:selectedBackColor forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    UIColor *selectColor = self.backgroundColorCache[@(UIControlStateSelected)];
    
    if (selectColor && selected) {
        super.backgroundColor = selectColor;
    } else if (self.backgroundColorCache[@(UIControlStateNormal)] && !selected) {
        super.backgroundColor = self.backgroundColorCache[@(UIControlStateNormal)];
    }
    if (self.borderColorCache[@(UIControlStateSelected)] && selected) {
        [self dy_setBorderColor:self.borderColorCache[@(UIControlStateSelected)] forState:UIControlStateSelected];
    } else if (self.borderColorCache[@(UIControlStateNormal)] && !selected) {
        
        [self dy_setBorderColor:self.borderColorCache[@(UIControlStateNormal)] forState:UIControlStateNormal];
    }
}


- (void)dy_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    
    self.backgroundColorCache[@(state)] = backgroundColor;
    if (state == self.state) {
        self.backgroundColor = backgroundColor;
    }
    
}

- (void)dy_setBorderColor:(UIColor *)color forState:(UIControlState)state {

    self.borderColorCache[@(state)] = color;
    if (state == self.state) {
        self.layer.borderColor = [color CGColor];
    }
    
    
}
- (CGSize)intrinsicContentSize {
    
    if (self.dy_intrinsicContentSize.width > 0 || self.dy_intrinsicContentSize.height > 0) {
        return self.dy_intrinsicContentSize;
    }
    
    return [super intrinsicContentSize];
}


- (NSMutableDictionary<NSNumber *,UIColor *> *)backgroundColorCache {
    
    if (!_backgroundColorCache) {
        _backgroundColorCache = [NSMutableDictionary new];
    }
    return _backgroundColorCache;
    
}

- (NSMutableDictionary<NSNumber *,UIColor *> *)borderColorCache {
    
    if (!_borderColorCache) {
        _borderColorCache = [NSMutableDictionary new];
    }
    return _borderColorCache;
}



@end
