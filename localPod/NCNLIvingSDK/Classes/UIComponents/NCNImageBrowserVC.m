//
//  NCNImageBrowserVC.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/29.
//

#import "NCNImageBrowserVC.h"

@interface NCNImageBrowserVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) UIImage *currentImage;

@end

@implementation NCNImageBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
    // Do any additional setup after loading the view.
}

- (void)setupSubView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.imageView = [[UIImageView alloc] initWithImage:self.currentImage];
    self.view.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage living_imageWithNamed:@"closeBtn-another@3x"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(20);
        make.size.offset(35);
    }];
    
    
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.imageView.center = self.scrollView.center;
    self.scrollView.zoomScale = 1.0;
    
    CGFloat width = self.currentImage.size.width;
    CGFloat height = self.currentImage.size.height;
    if (height > self.view.height) {
        CGFloat ratio = self.view.height / height;
        height = self.view.height;
        width = width * ratio;
    } else if (width > self.view.width) {
        CGFloat ratio = self.view.width / width;
        width = self.view.width;
        height = height * ratio;
    }
    
    self.imageView.bounds = CGRectMake(0, 0, width, height);
    
}


+ (instancetype)imageBrowserWithImage:(UIImage *)image {
    
    NCNImageBrowserVC *vc = [NCNImageBrowserVC new];
    vc.currentImage = image;
    return vc;
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
    
}



- (void)backBtnClick {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
