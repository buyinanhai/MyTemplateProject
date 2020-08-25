//
//  NCNLivingSettingConfig.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCNLivingSettingConfig : NSObject


@property (nonatomic, assign) BOOL isOpenMicrophone;
@property (nonatomic, assign) BOOL isOpenCamera;
@property (nonatomic, assign) BOOL isOpenBeauty;
/**
 0 : front   1  : behind
 */
@property (nonatomic, assign) BOOL capturePosition;


@end

NS_ASSUME_NONNULL_END
