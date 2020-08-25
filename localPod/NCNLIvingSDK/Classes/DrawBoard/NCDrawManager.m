//
//  NCDrawManager.m
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/14.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCDrawManager.h"

@implementation NCDrawManager

+ (instancetype)ShareInstance {
    
    static NCDrawManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [NCDrawManager new];
    });
    
    return manager;
}
- (instancetype)init {
    
    self = [super init];
    
    self.chooseColor = defaultChooseColor;
    self.fillColor = UIColor.redColor;
    self.weight = 1;
    self.permission = false;
    return self;
}
@end
