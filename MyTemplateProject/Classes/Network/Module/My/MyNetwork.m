//
//  MyNetwork.m
//  ID贷
//
//  Created by apple on 2019/6/21.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "MyNetwork.h"
#import <AFNetworking.h>

@implementation MyNetwork


+ (instancetype)saveContactsWithMobiles:(NSString *)mobiles name:(NSString *)name name1:(NSString *)name1 mobile:(NSString *)mobile mobile1:(NSString *)mobile1 {
    
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/user/savephonelist";
    obj.dy_requestArgument = @{
                                @"mobile" : mobiles,
                                @"mobile1" : mobile,
                                @"name1" : name,
                                @"mobile2" : mobile1,
                                @"name2" : name1,
                                };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
}

+ (instancetype)getBankNameList {
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/bank/getbanktype";
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
}

+ (instancetype)getMyBankList {
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/bank/mybank";
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
}
+ (instancetype)setDefaultBankWithId:(NSString *)bankID {
    
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/bank/defaultbank";
    obj.dy_requestArgument = @{
                                @"id" : bankID
                                    
                                };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
}

+ (instancetype)modifyAvartar:(NSData *)dataImg nickname:(NSString *)nickname {
    
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/file/headimg";
//    if (dataImg != nil) {
//        
//    }
    obj.dy_constructingBodyBlock = ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:dataImg name:@"file" fileName:[NSString stringWithFormat:@"%ld.jpg", random() % 10000000] mimeType:@"JPG"];
        
    };
    obj.dy_requestArgument = @{
                                @"name" : nickname,
                                };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
}

+ (instancetype)saveBankWithBankID:(NSString *)bankid name:(NSString *)name cardId:(NSString *)cardId {
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/bank/savebank";
    obj.dy_requestArgument = @{
                                @"bankid" : bankid,
                                @"name" : name,
                                @"car":cardId
                                };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
}

+ (instancetype)uploadIMEIImage:(NSData *)data {
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/file/imeiimg";
    obj.dy_constructingBodyBlock = ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%ld.jpg", random() % 10000000] mimeType:@"JPG"];
        
    };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
}

+ (instancetype)uploadIdentifyImageFiles:(NSArray<NSData *> *)files name:(NSString *)name cardID:(NSString *)cardID {
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/file/rz";
    obj.dy_constructingBodyBlock = ^(id<AFMultipartFormData> formData) {

        [files enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:@"file" fileName:[NSString stringWithFormat:@"%ld.jpg",idx] mimeType:@"JPG"];
        }];
       
    };
    obj.dy_requestArgument = @{
                                @"name" : name,
                                @"idcar" : cardID
                                };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
    
}

+ (instancetype)getAuthorizations {
    
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/user/getauth";
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
}

+ (instancetype)getMyLoans {
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/apply/getapplylist";
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    return obj;
    
}

+ (instancetype)saveFeedBack:(NSString *)content
{
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/user/savefeedback";
    obj.dy_requestArgument = @{@"content":content};
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}


+ (instancetype)getUserInfo {
    MyNetwork *obj = [MyNetwork new];
    obj.dy_baseURL = kBaseURL;
    obj.dy_requestUrl = @"/user/getinfo";
    obj.dy_requestMethod = YTKRequestMethodGET;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}
@end
