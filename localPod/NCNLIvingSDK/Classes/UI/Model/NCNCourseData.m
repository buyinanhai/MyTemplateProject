//
//  NCNCourseData.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/8.
//

#import "NCNCourseData.h"

@implementation NCNCourseData


+ (instancetype)courseDataWithDict:(NSDictionary *)dict {
    
    NCNCourseData *data = [NCNCourseData new];
    
    [data setValuesForKeysWithDictionary:dict];
    
    return data;
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end
