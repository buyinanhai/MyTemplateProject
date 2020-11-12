//
//  NSDate+dy_extension.m
//  ID贷
//
//  Created by apple on 2019/6/24.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "NSDate+dy_extension.h"

@implementation NSDate (dy_extension)


+ (NSTimeInterval)dy_dateStrToIntervalWithDateStr:(NSString *)dateStr dateFormat:(NSString *)format {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [formatter dateFromString:dateStr];
    
    return date.timeIntervalSince1970 * 1000;
}

+ (NSString *)dy_timeStampToDateStrWithInterval:(NSTimeInterval)interval dataFormat:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:interval / 1000];
    
    return [formatter stringFromDate:date];
    
}

+ (NSString *)dy_transformDateFormat:(NSDate *)update{
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:update];
    return destDateString;
}
@end
