//
//  NCExamElemMSG.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCCustomeElemMSG.h"

NS_ASSUME_NONNULL_BEGIN

/**
 测验指令数据结构
 */
@interface NCExamElemMSG : NCCustomeElemMSG

/**
     String    0 开始测验/ 1结束测验 / 2 公布答案
 */
@property (nonatomic, copy) NSString *examinationOperation;
/**
     String    测验试卷url
 */
@property (nonatomic, copy) NSString *examinationUrl;
/**
     String    未定义
 */
@property (nonatomic, copy) NSString *answer;
@end

NS_ASSUME_NONNULL_END
