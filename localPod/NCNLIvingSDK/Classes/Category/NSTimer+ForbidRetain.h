//
//  NSTimer+ForbidRetain.h
//  YQD_Student_iPad
//
//  Created by 王志盼 on 2018/1/17.
//  Copyright © 2018年 王志盼. All rights reserved.
//  防止定时循环引用

#import <Foundation/Foundation.h>

@interface NSTimer (ForbidRetain)
+ (NSTimer *)yqd_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)repeats block:(void(^)(void))block;
@end
