//
//  NCAnswerElemMSG.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCCustomeElemMSG.h"

NS_ASSUME_NONNULL_BEGIN

/**
 答题器指令数据结构
 */
@interface NCAnswerElemMSG : NCCustomeElemMSG

/**
 String    1 开始（发布）答题/ 0结束答题   时间到了会受到结束答题
 */
@property (nonatomic, copy) NSString *questionOperation;
    
/**
 String    答题时长（S）
 */
@property (nonatomic, copy) NSString *questionTime;

/**
 String    题目类型：0 选择题 ；1 判断题
*/
@property (nonatomic, copy) NSString *questionType;

/**
 String    问题说明
 */
@property (nonatomic, copy) NSString *questionExplain;

/**
 String    问题选项,如：‘A, B, C，D，E’或者‘对，错’
 */
@property (nonatomic, copy) NSString *questionOptions;

/**
 String    问题答案，如：‘A， C’
 */
@property (nonatomic, copy) NSString *questionAnswer;

/**
 String    是否显示答案，1 = 显示 0 = 不显示
 如果要显示答案就在提交答案后显示答案
 */
@property (nonatomic, copy) NSString *showAnswer;

/**
 我选择的答案  自己赋值
 */
@property (nonatomic, copy) NSString *myAnswer;

@end

NS_ASSUME_NONNULL_END
