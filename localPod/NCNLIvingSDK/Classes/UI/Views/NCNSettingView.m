//
//  NCNSettingView.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/3.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNSettingView.h"

@interface NCNSettingView ()

@end

@implementation NCNSettingView {
    
    UISwitch *_switches[6];
    UIButton *_allBtns[10];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.grayColor;
        
        
        
        
    }
    return self;
}


+ (instancetype)settingView {
    
    NCNSettingView *view = [[[NSBundle mainBundle] loadNibNamed:@"NCNLivingSettingView" owner:nil options:nil] firstObject];
    [[view microphoneSwitch] setOn:kLivingSettingConfig.isOpenMicrophone];
    [[view cameraSwitch] setOn:kLivingSettingConfig.isOpenCamera];
    [[view beautySwitch] setOn:kLivingSettingConfig.isOpenBeauty];

    if (kLivingSettingConfig.capturePosition) {
        [[view cameraFrontBtn] setSelected:false];
        [[view cameraBehindBtn] setSelected:true];
        
    } else {
        [[view cameraFrontBtn] setSelected:true];
        [[view cameraBehindBtn] setSelected:false];
    }
    return view;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (int i = 11; i < 16; i ++) {
        UISwitch *st = [self viewWithTag:i];
        _switches[i - 11] = st;
        [st addTarget:self action:@selector(switchStateChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    for (int i = 21; i < 31; i ++) {
        UIButton *btn = [self viewWithTag:i];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        
        _allBtns[i - 21] = btn;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)updateButtonStateWithType:(NCNSettingChangedType)type isOpen:(BOOL)isOpen {
    
    switch (type) {
        case NCNSettingChangedType_camera:
            
           [[self cameraSwitch] setOn:isOpen];
            break;
        case NCNSettingChangedType_microphone:
          
            [[self microphoneSwitch] setOn:isOpen];
            break;
        default:
            break;
    }
    
}

- (void)makeButtonDisableWithType:(NCNSettingChangedType)type isOpen:(BOOL)isOpen {
    
    switch (type) {
        case NCNSettingChangedType_camera:
            
           [[self cameraSwitch] setUserInteractionEnabled:!isOpen];
            break;
        case NCNSettingChangedType_microphone:
          
            [[self microphoneSwitch] setUserInteractionEnabled:!isOpen];
            break;
        default:
            break;
    }
    
    
}

- (UISwitch *)microphoneSwitch {
    return [self viewWithTag:11];
}

- (UISwitch *)cameraSwitch {
    return [self viewWithTag:12];
}
- (UISwitch *)beautySwitch {
    return [self viewWithTag:13];
}
- (UISwitch *)backgroundAudioSwitch {
    return [self viewWithTag:14];
}
- (UISwitch *)pptAffectionSwitch {
    return [self viewWithTag:15];
}

- (UIButton *)cameraFrontBtn {
    return [self viewWithTag:25];
}
- (UIButton *)cameraBehindBtn {
    return [self viewWithTag:26];
}

- (void)switchStateChanged:(UISwitch *)sender {
    
    switch (sender.tag) {
        case 11:
            kLivingSettingConfig.isOpenMicrophone = sender.isOn;
            
            break;
        case 12:
            kLivingSettingConfig.isOpenCamera = sender.isOn;
            
            break;
        case 13:
            kLivingSettingConfig.isOpenBeauty = sender.isOn;
            break;
        default:
            break;
    }
    if (self.settingValueChangedCallback) {
        self.settingValueChangedCallback(sender.tag - 11, sender.isOn);
    }
               
}
- (void)btnClick:(UIButton *)sender {
    
    if (sender.isSelected) {
        return;
    }
    
    sender.selected = true;
        
    switch (sender.tag) {
        case 25:
            
            kLivingSettingConfig.capturePosition = false;
            [[self cameraBehindBtn] setSelected:false];
            break;
        case 26:
            kLivingSettingConfig.capturePosition = true;
            [[self cameraFrontBtn] setSelected:false];
            break;
            
        default:
            break;
    }
    if (self.settingValueChangedCallback && (sender.tag == 25 || sender.tag == 26)) {
        self.settingValueChangedCallback(NCNSettingChangedType_capturePosition, sender.tag  == 25 ? false : true);
    }
}

@end
