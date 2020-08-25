//
//  NCCustomElemArrayMessage.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class NCCustomMessageData;

/**
 自定义消息的具体elem
 */
@interface NCCustomElemEntityMessage : NSObject
@property (nonatomic, assign) int elem_type;

@property (nonatomic, strong) NCCustomMessageData *message;

@property (nonatomic, copy) NSString *custom_elem_desc;

@property (nonatomic, copy) NSString *ecustom_elem_ext;

@property (nonatomic, copy) NSString *custom_elem_sound;

@end

NS_ASSUME_NONNULL_END
