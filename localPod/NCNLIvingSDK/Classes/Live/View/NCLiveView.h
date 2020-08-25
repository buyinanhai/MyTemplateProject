//
//  NCLiveView.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kLiving_margin 5



typedef enum : NSUInteger {
    NCLivingViewStateSmall = 0,
    NCLivingViewStateBig,
    NCLivingViewStateMoving,
} NCLivingViewState;


typedef enum : NSUInteger {
    NCLivingViewOritention_portrait,
    NCLivingViewOritention_rotating,
    NCLivingViewOritention_landscape,
    
} NCLivingViewOritention;

NS_ASSUME_NONNULL_BEGIN


@protocol NCLivingProtocal <NSObject>


@optional
- (void)start;
- (void)pause;
- (void)stop;

@end

@protocol NCLivingViewDelegate <NSObject>


@end


@interface NCLiveView : UIView <NCLivingProtocal>


@property (nonatomic, assign) CGRect portraitFrame;
@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, assign) CGRect smallOriginalFrame;


@property (nonatomic, copy) void (^didClickLivingCallback)(void);
@property (nonatomic, copy) void (^onSwipeGestureCallBack)(UISwipeGestureRecognizerDirection direction);


@property (nonatomic, assign) NCLivingViewState state;

@property (nonatomic, assign) NCLivingViewOritention oritention;


@property (nonatomic, weak) id<NCLivingViewDelegate> delegate;

@property (nonatomic, weak) UIViewController *belongVC;

/**
 设置左上角的标记符号
 */
- (void)setLeftTopSymbol:(NSString *)symbol;
/**
 变大
 */
- (void)prepareZoomToBigFrame:(CGRect)frame;
/**
 变小
 */
- (void)prepareZoomToSmallFrame:(CGRect)frame;

/**
 横屏
 */
- (void)prepareRatateOritentionLandscape;
/**
 竖屏
 */
- (void)prepareRatateOritentionPortrait;

- (void)toastTip:(NSString *)toastInfo;


- (UIActivityIndicatorView *)activityView;

@end

NS_ASSUME_NONNULL_END
