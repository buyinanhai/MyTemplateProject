//
//  DYSwitch.m
//  LFLiveKit
//
//  Created by 汪宁 on 2020/4/29.
//

#import "DYSwitch.h"

@implementation DYSwitch

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    self.transform = CGAffineTransformMakeScale(scale, scale);
}
@end
