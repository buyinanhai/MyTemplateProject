//
//  NCNLiveLansacpeMaskView.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/14.
//

#import "NCNLiveLansacpeMaskView.h"
#import "NCNSpeakView.h"
#import "NCNQuestionAskView.h"
#import "NCNMemberView.h"
#import "NCNAnnouncementView.h"
#import "NCNSettingView.h"
@interface NCNLiveLansacpeMaskView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *subContentView;

@property (nonatomic, weak) UIView *currentShowView;


@end

@implementation NCNLiveLansacpeMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self setupSubview];
    
    return self;
    
}


- (void)setupSubview {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn setBackgroundColor:self.backgroundColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    
    [self addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.equalTo(self).multipliedBy(0.35);
    }];
    
    
    self.titleLabel = UILabel.new;
    self.titleLabel.text = @"标题";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(20);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.right.offset(-8);
        make.height.offset(1.0);
        make.top.offset(45);
    }];
  
    self.subContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.subContentView.clipsToBounds = true;
    [self.contentView addSubview:self.subContentView];
    [self.subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(50);
    }];

    
}

- (void)showWithTitle:(NSString *)title subView:(UIView *)view {
    if ([title isEqualToString:@"设置"]) {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.offset(0);
            make.width.equalTo(self).multipliedBy(0.5);
            
        }];
    } else {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.offset(0);
            make.width.equalTo(self).multipliedBy(0.4);
            
        }];
    }
    if ([title isEqualToString:@"在线成员"]) {
        self.subContentView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(self.titleLabel.frame));
    } else {
        self.subContentView.transform = CGAffineTransformIdentity;
    }
    [self layoutIfNeeded];
    self.currentShowView = view;
    self.titleLabel.text = title;
    
    [self.subContentView addSubview:view];
    view.frame = self.subContentView.bounds;
    if (view.class == NCNMemberView.class) {
         [(NCNMemberView *)view willApear];
        
    }
   
    
}
- (void)btnClick {
    

    
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = true;
        self.transform = CGAffineTransformMakeTranslation(0, -self.height);

    }];
    
}

- (CGSize)intrinsicContentSize {
    
    return UIScreen.mainScreen.bounds.size;
    
}

- (NSArray<UIView *> *)allShowViews {
    
    return self.subContentView.subviews;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
