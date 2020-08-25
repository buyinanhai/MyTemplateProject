//
//  NCCustomMessage.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 自定义的消息模型
 */
@class NCCustomElemEntityMessage;
@interface NCCustomMessage : NSObject

@property (nonatomic, copy) NSString *message_client_time;

@property (nonatomic, copy) NSString *message_conv_id;

@property (nonatomic, copy) NSString *message_conv_type;

@property (nonatomic, copy) NSString *message_custom_int;

@property (nonatomic, copy) NSString *message_custom_str;

@property (nonatomic, copy) NSArray<NCCustomElemEntityMessage *> *message_elem_array;

@property (nonatomic, copy) NSString *message_sender;



@end

NS_ASSUME_NONNULL_END
