//
//  NCPushLiveView.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/11.
//  Copyright © 2020 子宁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCLiveView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 推流显示的view
 */
@interface NCLivePushView : NCLiveView

@property (nonatomic, copy) NSString *teacherID;
/**
 为了降低延迟 需要显示远端的老师流  老师窗口的直播显示view
 */
@property (nonatomic, weak) UIView *teacherShowView;


+ (instancetype)pushViewWithLiveRoom:(NSString *)url appid:(UInt32)appid userSign:(NSString *)sign roomId:(UInt32)roomid;


- (void)startToLive;
- (void)stopToLive;

- (void)openMircphone:(BOOL)isOpen;
- (void)openCamera:(BOOL)isOpen;
- (void)openBeauty:(BOOL)isOpen;

/**
 0 : front   1  : behind
 */
- (void)changeCapturePosition:(BOOL)position;


@end

NS_ASSUME_NONNULL_END
