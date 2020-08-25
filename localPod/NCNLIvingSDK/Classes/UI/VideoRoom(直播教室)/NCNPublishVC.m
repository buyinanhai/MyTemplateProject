//
//  NCNPublishVC.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/18.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNPublishVC.h"
#import "NCNPublishView.h"

@interface NCNPublishVC ()<PublishViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation NCNPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)setNav {
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"发布问题";
    UIButton *publishBtn = [[UIButton alloc]init];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    publishBtn.titleLabel.font = [UIFont systemFontOfSize:SLMainFontSize+1];
    [publishBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publishBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage living_imageWithNamed:@"leftArrow@3x"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
}

- (void)setUI {
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8);
        } else {
            make.top.offset(8);
            // Fallback on earlier versions
        }
        make.left.offset(8);
        make.right.offset(-8);
        make.height.offset(150);
    }];
//    NCNPublishView *publishView = [NCNPublishView showPublishView];
//    [self.view addSubview:publishView];
//    publishView.delegate = self;
//    [publishView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.mas_equalTo(self.view).inset(10);
//        make.height.mas_equalTo(150);
//    }];
}

- (void)didClickEmojialBtnInPublishView:(NCNPublishView *)publishView {
    NSLog(@"%s",__func__);
}
- (void)didClickPhotoBtnInPublishView:(NCNPublishView *)publishView{
    NSLog(@"%s",__func__);
}
- (void)didClickAttramentBtnInPublishView:(NCNPublishView *)publishView{
    NSLog(@"%s",__func__);
}

- (void)publishBtnClick {
    NSLog(@"%s",__func__);
    if (self.publishBtnClickCallback) {
        self.publishBtnClickCallback(self,self.textView.text);
    }
}

- (void)backBtnClick {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

- (UITextView *)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor colorWithHexString:@"#F3F4FB"];
        _textView.font = [UIFont systemFontOfSize:17];
    }
    return _textView;
    
}
@end
