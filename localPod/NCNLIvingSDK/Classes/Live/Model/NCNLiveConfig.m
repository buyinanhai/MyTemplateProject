//  Created by hansen 



#import "NCNLiveConfig.h" 

@implementation NCNLiveConfig 

+ (instancetype)liveConfigWithDict:(NSDictionary *)dict {
    
    NCNLiveConfig *config = [NCNLiveConfig new];
    [config setValuesForKeysWithDictionary:dict];
    config.courseData = [NCNCourseData courseDataWithDict:dict[@"courseData"]];
    if (dict.allKeys.count == 0) {
        //如果接口数据为空  不能举手
        config.isHandup = @"0";
    }
   
    return config;
    
}

- (instancetype)init {
    
    self = [super init];
    
    return self;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
