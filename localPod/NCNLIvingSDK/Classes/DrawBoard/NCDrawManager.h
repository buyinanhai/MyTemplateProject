//
//  NCDrawManager.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/14.
//  Copyright © 2020 子宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDrawTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCDrawManager : NSObject
@property (copy, nonatomic) NSString *chooseColor;
@property (assign, nonatomic) UIColor *fillColor;
@property (assign, nonatomic) float weight;

@property (strong, nonatomic) ZYDrawTextField *txField;

@property (assign, nonatomic) BOOL permission;//全局房间操作权限

//对方激光笔
@property (strong, nonatomic) UIImageView *laserImage;

/*全局变量*/
+ (instancetype)ShareInstance;
@end

NS_ASSUME_NONNULL_END
