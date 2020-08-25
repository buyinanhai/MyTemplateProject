//
//  NSString+CheckNull.h
//  YQD_Student_iPad
//
//  Created by ChenJiajie on 2018/7/31.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(CheckNull)
+ (NSString *)isNullToString:(id)string;
+ (BOOL)isNull:(id)string;
@end
