//
//  NCNNetwork.m
//  AFNetworking
//
//  Created by 汪宁 on 2020/5/7.
//

#import "NCNNetwork.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+Common.h"


@interface NCNNetwork ()
@property (nonatomic, strong) AFHTTPSessionManager *httpSession;


@end

@implementation NCNNetwork

+ (instancetype)shared {
    
    static NCNNetwork *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = NCNNetwork.new;
    });
    return instance;
}



+ (void)getLivingRoomInitialConfigWithLiveRoomID:(NSString *)roomID completed:(NetworkCompletedBlock)completed {
    
    [[[NCNNetwork shared] httpSession] GET:@"appApi/live/getConfig" parameters:@{@"liveRoom" : roomID} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:0];
        NSLog(@"getLivingRoomInitialConfigWithLiveRoomID：%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:0]);
        
        completed(nil, responseObject);
        NSLog(@"配置信息请求成功：  %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completed(error, nil);
    }];
    
    
}

+ (void)getLivingRoomIMInstructsWithLiveRoomID:(NSString *)roomID completed:(NetworkCompletedBlock)completed {
    
    [[[NCNNetwork shared] httpSession] GET:@"appApi/live/getImInstruct" parameters:@{@"liveRoomId" : roomID} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:0];
        NSLog(@"getLivingRoomIMInstructsWithLiveRoomID：%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:0]);
        
           completed(nil, responseObject);
           NSLog(@"配置信息请求成功：  %@",responseObject);
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           completed(error, nil);
       }];
    
}

+ (void)getLiveRoomParametersWithRoomID:(NSString *)roomID studentId:(NSString *)stuId companyId:(nonnull NSString *)companyId completed:(nonnull NetworkCompletedBlock)completed {
    
    NSDate *date = NSDate.date;
    NSTimeInterval time = [NSDate.date timeIntervalSince1970] * 1000;
    NSString *cryptContent = [NSString stringWithFormat:@"%@,%.0f",companyId,time];
    NSString *encryptStr = [NSString encryptUseDES2:cryptContent key:@"yuxin2016"];
    NSString *token = [NSString urlEncodeStr:encryptStr];
    [NCNNetwork.shared httpSession].requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameter = @{@"token":@"",@"liveRoomId":roomID,@"studentId":stuId,@"type":@3};
    
    [[[NCNNetwork shared] httpSession] POST:@"appApi/liveroom/student/enter" parameters:parameter headers:@{@"token":token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:0];
        NSLog(@"getLiveRoomParametersWithRoomID：%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:0]);
        completed(nil, responseObject);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        completed(error, nil);

    }];
    
}

- (void)setBaseURL:(NSString *)baseURL {
    _baseURL = baseURL;
    _httpSession = nil;
    [self httpSession];
}


- (AFURLSessionManager *)httpSession {
    
    if (!_httpSession) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _httpSession =  [[AFHTTPSessionManager alloc] initWithBaseURL:[
                                                                       NSURL URLWithString:self.baseURL]
        sessionConfiguration:config];
       
    }
    return _httpSession;
    
}
@end
