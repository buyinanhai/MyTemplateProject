//
//  NCNTestChooseView.m
//  LFLiveKit
//
//  Created by 汪宁 on 2020/5/6.
//

#import "NCNTestChooseView.h"
#import "DYButton.h"
#import "NCAnswerElemMSG.h"

@interface NCNTestChooseView ()
@property (nonatomic, weak) UIButton *lastClickBtn;


@end

@implementation NCNTestChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setupTestContent {
    
    NSArray *titles = [self.elemMsg.questionOptions componentsSeparatedByString:@","];

    [self.testContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        CGFloat width = titles.count * 50 + (titles.count - 1) * 10;
        if (titles.count > 5) {
            make.left.offset(0);
            self.testContentView.contentSize = CGSizeMake(width, 0);
        } else {
            make.width.offset(width);
        }
    }];
    for (NSString *title in titles) {
        UIButton *btn = [self createChooseButtonWithTitle:title];
        CGFloat size = 50;
        NSInteger index = [titles indexOfObject:title];
        btn.frame = CGRectMake(index * (50 + 5), 0, size, size);
        [self.testContentView addSubview:btn];
    }
    
}

- (UIButton *)createChooseButtonWithTitle:(NSString *)title {
    
    DYButton *btn = [DYButton buttonWithType:UIButtonTypeCustom];
    
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    btn.dy_intrinsicContentSize = CGSizeMake(50, 50);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [btn dy_setBackgroundColor:[UIColor colorWithHexString:@"#FF8A0C"] forState:UIControlStateSelected];
    [btn dy_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn sl_setBorderWidth:1.5 borderColor:[[UIColor colorWithHexString:@"#FF8A0B"] CGColor] cornerR:25];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)btnClick:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
  
    if (self.timeIsExhausted) {
        return;
    }
  
    BOOL canSubmit = [self getMultipulAnswer].length > 0;
    [self canSubmit:canSubmit];
    
}
- (NSString *)getMultipulAnswer {
    
    NSMutableString *answers = @"".mutableCopy;
    for (UIButton *btn in self.testContentView.subviews) {
        
        if (btn.classForCoder == DYButton.class) {
            
            if (btn.isSelected) {
                [answers appendString:btn.titleLabel.text];
                [answers appendString:@","];
            }
        }
    }
    if (answers.length > 0) {
        [answers deleteCharactersInRange:NSMakeRange(answers.length - 1, 1)];
    }
    return answers.copy;
}
- (void)confirmBtnClick:(UIButton *)sender {
    
    if (self.submitAnswerCallback) {
        self.submitAnswerCallback(self, [self getMultipulAnswer]);
    }
    
}
@end
