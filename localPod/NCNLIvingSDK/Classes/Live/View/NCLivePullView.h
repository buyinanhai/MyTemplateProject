//
//  NCLivePullView.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/11.
//  Copyright © 2020 子宁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCLiveView.h"
NS_ASSUME_NONNULL_BEGIN

/**
 拉流显示的view
 */
@interface NCLivePullView : NCLiveView


+ (instancetype)pullViewWithLiveRoom:(NSString *)url;

/**
 暂停老师直播流 显示远端实时流
 */
- (UIView *)stopTeacherLivingToPlayRemoteLiving;
/**
 重新播放老师直播流
 */
- (void)replayTeacherLiving;
@end

NS_ASSUME_NONNULL_END
