//
//  NCNSettingView.h
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/3.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "DYTemplate/DYScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@class DYScrollView;
typedef enum : NSUInteger {
    NCNSettingChangedType_microphone = 0,
    NCNSettingChangedType_camera,
    NCNSettingChangedType_beauty,
    NCNSettingChangedType_capturePosition
} NCNSettingChangedType;

@interface NCNSettingView : DYScrollView

@property (nonatomic, copy) void(^settingValueChangedCallback)(NCNSettingChangedType style, BOOL isOpen);


+ (instancetype)settingView;


- (void)updateButtonStateWithType:(NCNSettingChangedType)type isOpen:(BOOL)isOpen;
- (void)makeButtonDisableWithType:(NCNSettingChangedType)type isOpen:(BOOL)isOpen;

@end

NS_ASSUME_NONNULL_END
