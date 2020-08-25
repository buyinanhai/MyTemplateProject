//
//  NSTimer+ForbidRetain.m
//  YQD_Student_iPad
//
//  Created by 王志盼 on 2018/1/17.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "NSTimer+ForbidRetain.h"

@implementation NSTimer (ForbidRetain)
+ (NSTimer *)yqd_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)repeats block:(void(^)(void))block
{
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(yqd_block:) userInfo:block repeats:repeats];
}

+ (void)yqd_block:(NSTimer *)timer
{
    void(^tmpBlock)(void) = timer.userInfo;
    if (tmpBlock) tmpBlock();
}
@end
