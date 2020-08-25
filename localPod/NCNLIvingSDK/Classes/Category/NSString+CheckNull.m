//
//  NSString+CheckNull.m
//  YQD_Student_iPad
//
//  Created by ChenJiajie on 2018/7/31.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "NSString+CheckNull.h"

@implementation NSString(CheckNull)

+(BOOL)isNull:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"] || [string isEqual:@"<null>"])
    {
        return YES;
        
        
    }else
    {
        
        return NO;
    }
}
+ (NSString *)isNullToString:(id)string
{
    if ([self isNull:string])
    {
        return @"";
        
    }else
    {
        
        return (NSString *)string;
    }
}
@end
