//
//  NCNLivingSDK.m
//  XYClassRoom
//
//  Created by 尹彦博 on 2020/4/16.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNLivingSDK.h"
#import "NCIMManager.h"
#import "TXLiteAVSDK.h"

@interface NCNLivingSDK ()<TXLiveBaseDelegate>


@end
@implementation NCNLivingSDK


+ (instancetype)shareInstance {
    
    static NCNLivingSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = NCNLivingSDK.new;
        NCNLivingSettingConfig *config = [NCNLivingSettingConfig new];
        config.isOpenBeauty = true;
        config.isOpenMicrophone = true;
        config.isOpenCamera = true;
        config.capturePosition = false;
        instance.settingConfig = config;
        [instance createCachePath];
    });
    return instance;
}

+ (void)setupWithTcentIM_AppID:(NSString *)appid {
    
    [NCIMManager.sharedInstance setupWithAppId:[appid integerValue]];
    [TXLiveBase setConsoleEnabled:NO];
    [[TXLiveBase sharedInstance] setDelegate:NCNLivingSDK.shareInstance];
   
    //test
//    [NCNLivingSDK.shareInstance setGroupId:@"CHAT_993216"];
//    [NCNLivingSDK.shareInstance setTeacherId:@"131038"];
//    [NCNLivingSDK.shareInstance setStudentId:@"3050383"];
//    [NCNLivingSDK.shareInstance setGroupCodeId:@"CODE_993216"];

}
+ (void)initializeTencentLiveSDKWithAppid:(UInt32)appid sign:(NSString *)sign {
    
//    [TXLiveBase setAppID:appid];
//    [TXLiveBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/9d9355753c91eb0e1019279cf4eee1d4/TXLiveSDK.licence" key:@"65dc345136a3c6351044c03a9cfa5f5e"];
   
    
    
        
}

- (void)onLog:(NSString *)log LogLevel:(int)level WhichModule:(NSString *)module {
    
    NSLog(@"TXLiveBase: %@",log);
    
}

- (void)createCachePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建聊天图片存储文件
    if(![fileManager fileExistsAtPath:TUIKit_Image_Path]){
        [fileManager createDirectoryAtPath:TUIKit_Image_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
}
- (void)classRoomEnded {
    self.config = [NCNLiveConfig new];
    
}
@end
