//
//  NCQAElemMSG.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCCustomeElemMSG.h"

NS_ASSUME_NONNULL_BEGIN

/**
 问答指令数据结构
 */
@interface NCQAElemMSG : NCCustomeElemMSG

/**
     String    0 提问/ 1回答
 */
@property (nonatomic, copy) NSString *askOperation;
/**
     String    对应问题的消息ID，值为0时表示新问题
 */
@property (nonatomic, copy) NSString *askId;
/**
     String    提问/回答的内容
 */
@property (nonatomic, copy) NSString *askText;

@property (nonatomic, copy) NSString *liveRoomId;


@end

NS_ASSUME_NONNULL_END
