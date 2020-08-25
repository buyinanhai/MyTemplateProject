//
//  NCLiveView.m
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCLiveView.h"



@interface NCLiveView ()

@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, strong) UILabel *symbol;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UISwipeGestureRecognizer *upswipeGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *downswipeGesture;


@end
@implementation NCLiveView {
    
    UIPanGestureRecognizer *_panGesture;
    UISwipeGestureRecognizer *_upswipeGesture;
    UISwipeGestureRecognizer *_downswipeGesture;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
        _panGesture = pan;
        [self addGestureRecognizer:pan];
        self.backgroundColor = UIColor.blackColor;
        [self sl_setCornerRadius:5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.symbol];
        [self.symbol mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(3);
        }];
        self.state = NCLivingViewStateSmall;
        [self addSubview:self.activityView];
        [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
        }];
       
        [self addGestureRecognizer:self.upswipeGesture];
        [self addGestureRecognizer:self.downswipeGesture];
        [_panGesture requireGestureRecognizerToFail:self.upswipeGesture];
        [_panGesture requireGestureRecognizerToFail:self.downswipeGesture];
    }
    return self;
}

- (void)onTapGesture {
  
    if (self.didClickLivingCallback) {
        self.didClickLivingCallback();
    }
}

- (void)onSwipeGesture:(UISwipeGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onSwipeGestureCallBack) {
            self.onSwipeGestureCallBack(sender.direction);
        }
    }
   
    
}
- (void)onPanGesture:(UIPanGestureRecognizer *)gesture {
    
    if (self.state == NCLivingViewStateBig) {
        return;
    }
//    CGFloat screenWidth = self.oritention == NCLivingViewOritention_landscape ? kScreen_Height : kScreen_Width;
//    CGFloat screenHeight = self.oritention == NCLivingViewOritention_landscape ? kScreen_Width : kScreen_Height;
    CGFloat screenWidth = kScreen_Width;
       CGFloat screenHeight = kScreen_Height;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
//            [self pause];
            self.originalFrame = self.frame;
            break;
        case UIGestureRecognizerStateChanged:
            
        {
            CGPoint point = [gesture translationInView:self.superview];
            CGRect newFrame = self.frame;
            CGFloat newX = self.originalFrame.origin.x + point.x;
            CGFloat newY = self.originalFrame.origin.y + point.y;
            if (newX < 0) {
                newFrame.origin.x = kLiving_margin;
                newFrame.origin.y = newY;
                self.frame = newFrame;
            } else if (newY < 0) {
                newFrame.origin.x = newX;
                newFrame.origin.y = kLiving_margin;
                self.frame = newFrame;
            } else if ((newX + self.width) > screenWidth) {
                
                newFrame.origin.x = screenWidth - self.width - kLiving_margin;
                newFrame.origin.y = newY;
                self.frame = newFrame;
                
            } else if((newY + self.height) > screenHeight) {
                newFrame.origin.x = newX;
                newFrame.origin.y = screenHeight - self.height - kLiving_margin;
            } else {
                newFrame.origin.x = newX;
                newFrame.origin.y = newY;
            }
            self.frame = newFrame;
        }
            
            break;
        case UIGestureRecognizerStateEnded:

            [self lastConfirmPosition];

            break;
        case UIGestureRecognizerStateCancelled:
            
            [self lastConfirmPosition];
            break;
            
        default:
            break;
    }
    
    
}

- (void)lastConfirmPosition {
    CGFloat screenWidth = kScreen_Width;
    
    CGRect newFrame = self.frame;
    
    newFrame.origin.x = [self judgeFrameAtWhichSide] == 0 ? kLiving_margin : screenWidth - self.width - kLiving_margin;
    if (newFrame.origin.y < 0) {
        newFrame.origin.y = 0;
    } else if (CGRectGetMaxY(newFrame) > kScreen_Height) {
        newFrame.origin.y = kScreen_Height - newFrame.size.height;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
//        [self start];
        self.originalFrame = self.frame;
    }];
    
}




- (int)judgeFrameAtWhichSide {
    
   CGFloat screenWidth = kScreen_Width;

    if (self.centerX <= (screenWidth * 0.5)) {
        return 0;
    }
    return 1;
}

- (void)prepareZoomToBigFrame:(CGRect)frame {
    
    [self addGestureRecognizer:self.upswipeGesture];
    [self addGestureRecognizer:self.downswipeGesture];
    [_panGesture requireGestureRecognizerToFail:self.upswipeGesture];
    [_panGesture requireGestureRecognizerToFail:self.downswipeGesture];
   
}

- (void)prepareZoomToSmallFrame:(CGRect)frame {
    
    [self removeGestureRecognizer:self.upswipeGesture];
    [self removeGestureRecognizer:self.downswipeGesture];
    self.upswipeGesture = nil;
    self.downswipeGesture = nil;
  
}

- (void)prepareRatateOritentionLandscape {
    
    if (self.state == NCLivingViewStateSmall) {
        self.smallOriginalFrame = self.frame;
    } else if (self.state == NCLivingViewStateBig) {
        self.portraitFrame = self.frame;
        self.parentView = self.superview;
        self.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);

    }
//    CGRect rectInWindow = [self convertRect:self.bounds toView:UIApplication.sharedApplication.keyWindow];
//    [self removeFromSuperview];
//    self.frame = rectInWindow;
//    [UIApplication.sharedApplication.keyWindow addSubview:self];
//
//    [UIView animateWithDuration:0.25 animations:^{
//
//        self.transform = CGAffineTransformMakeRotation(M_PI_2);
//
//        self.bounds = CGRectMake(0, 0, self.superview.height, self.superview.width);
//        self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
//
//    } completion:^(BOOL finished) {
//
//    }];
    
}

- (void)prepareRatateOritentionPortrait {
    

    
    if (self.state == NCLivingViewStateSmall) {
        self.frame = self.smallOriginalFrame;
    } else if (self.state == NCLivingViewStateBig) {
        self.frame = self.portraitFrame;
    }
    
//    CGRect originalFrame = [self convertRect:self.blankFrame toView:UIApplication.sharedApplication.keyWindow];
//    [UIView animateWithDuration:0.25 animations:^{
//
//        self.frame = originalFrame;
//        self.transform = CGAffineTransformIdentity;
//
//
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        self.frame = self.blankFrame;
//        [self.parentView addSubview:self];
//        [self.superview sendSubviewToBack:self];
//
//    }];
    
    
}


- (void)toastTip:(NSString *)toastInfo {
    [YJProgressHUD showMessage:toastInfo inView:UIApplication.sharedApplication.keyWindow];
}



- (void)setLeftTopSymbol:(NSString *)symbol {
    
    self.symbol.text = symbol;
}

- (void)pause {
    
    
}

- (void)start {
    
}

- (void)stop {
    
    
}


- (UILabel *)symbol {
    
    if (!_symbol) {
        _symbol = [UILabel new];
        _symbol.textColor = UIColor.whiteColor;
        _symbol.font = [UIFont boldSystemFontOfSize:10];
    }
    return _symbol;
    
}

- (UIActivityIndicatorView *)activityView {
    
    if (!_activityView) {
        _activityView = [UIActivityIndicatorView new];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
    }
    return _activityView;
}

- (UISwipeGestureRecognizer *)upswipeGesture {
    
    if (!_upswipeGesture) {
        _upswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
        _upswipeGesture.direction = UISwipeGestureRecognizerDirectionUp;

    }
    return _upswipeGesture;
    
}

- (UISwipeGestureRecognizer *)downswipeGesture {
    
    if (!_downswipeGesture) {
        _downswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
        _downswipeGesture.direction = UISwipeGestureRecognizerDirectionDown;

    }
    return _downswipeGesture    ;
    
}
@end
