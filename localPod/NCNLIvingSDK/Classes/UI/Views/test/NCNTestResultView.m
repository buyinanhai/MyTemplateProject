//
//  NCNTestResultView.m
//  LFLiveKit
//
//  Created by 汪宁 on 2020/5/6.
//

#import "NCNTestResultView.h"
#import "dybutton.h"
#import "NCAnswerElemMSG.h"


@interface NCNTestResultView ()
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UILabel *answerLabel;

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation NCNTestResultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    self.backgroundColor = rgba(0, 0, 0, 0.3);
    
    UIView *contentView = UIView.new;
    contentView.backgroundColor = UIColor.clearColor;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(293);
        make.height.offset(200);
    }];
    self.contentView = contentView;
   
    [self setMiddleView];
    [self setBottomView];
}

- (void)setMiddleView {
    
    UIView *middleView = UIView.new;
    middleView.backgroundColor = UIColor.whiteColor;
    [middleView sl_setCornerRadius:10];
    [self.contentView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(-50);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [closeBtn setImage:[UIImage living_imageWithNamed:@"test-close@3x"] forState:UIControlStateNormal];
    [middleView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(30);
        make.right.offset(-6);
        make.top.offset(6);
    }];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    [middleView addSubview:label];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我的答案" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];

    label.attributedText = string;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(15);
    }];

    
    self.scrollView = UIScrollView.new;
//    NSArray *array = @[@"A",@"B",@"C"];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(50);
        make.center.offset(0);
        make.width.offset(self.contentView.width);
    }];

    
    
 
}

- (UIButton *)createAnswerButtonWithTitle:(NSString *)title {
    
    DYButton *btn = [DYButton buttonWithType:UIButtonTypeCustom];
    
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    btn.dy_intrinsicContentSize = CGSizeMake(50, 50);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.textColor = UIColor.whiteColor;
    [btn dy_setBackgroundColor:[UIColor colorWithHexString:@"#FF8A0B"] forState:UIControlStateNormal];
    [btn sl_setBorderWidth:1.5 borderColor:[[UIColor colorWithHexString:@"#FF8A0B"] CGColor] cornerR:25];
    btn.enabled = false;
    
    return btn;
}

- (void)setBottomView {
    
    UIView *bottomView = UIView.new;
    bottomView.backgroundColor = UIColor.whiteColor;
    [bottomView sl_setCornerRadius:10];
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(42);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"正确答案:" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    label.attributedText = string;
    [bottomView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    
    UILabel *answerLabel = [[UILabel alloc] init];
    answerLabel.textColor = [UIColor colorWithRed:28/255.0 green:210/255.0 blue:105/255.0 alpha:1.0];
    answerLabel.font = [UIFont boldSystemFontOfSize:20];
    answerLabel.text = @"A D ✅ ❎";
    self.answerLabel = answerLabel;
    [bottomView addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(label.mas_right).offset(8);
        make.centerY.offset(0);
    }];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage living_imageWithNamed:@"test-result-image@3x"]];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.offset(20);
        make.width.offset(104);
        make.height.offset(92);
    }];
    
}

- (void)closeBtnClick {
    
    [self removeFromSuperview];
    
}
- (void)showOnView:(UIView *)view elemMsg:(nonnull NCAnswerElemMSG *)msg {
    
    NSArray *array = [msg.myAnswer componentsSeparatedByString:@","];
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat width = array.count * 50 + (array.count - 1) * 10;
        if (array.count > 5) {
            make.left.offset(0);
            self.scrollView.contentSize = CGSizeMake(width, 0);
        } else {
            make.width.offset(width);
        }
        
    }];
    for (NSString *title in array) {
          UIButton *btn  = [self createAnswerButtonWithTitle:title];
        CGFloat size = 50;
        NSInteger index = [array indexOfObject:title];
        btn.frame = CGRectMake(index * (50 + 5), 0, size, size);
        [self.scrollView addSubview:btn];
    }
    self.answerLabel.text = msg.questionAnswer;
    if (view == nil) {
        view = UIApplication.sharedApplication.keyWindow;
    }
    
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [view bringSubviewToFront:self];
    
}

@end
