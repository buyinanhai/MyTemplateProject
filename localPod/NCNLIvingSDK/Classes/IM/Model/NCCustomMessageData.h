//
//  NCCustomMessageData.h
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCDrawElemMSG.h"
#import "NCExamElemMSG.h"
#import "NCQAElemMSG.h"
#import "NCAnswerElemMSG.h"
#import "NCControlElemMSG.h"
#import "NCRollElemMSG.h"


NS_ASSUME_NONNULL_BEGIN
@class NCCustomeElemMSG;

/**
 自定义消息中elem中对应的data
 */
@interface NCCustomMessageData : NSObject

/**
 0    批注    白板中的图形、笔迹
 1    课件控制    控制课件翻页
 2    答题器    答题器指令
 3    点名    点名指令，指定答道时间
 4    测验    开始/结束测验，公布测验答案
 5    问答    问答消息，需要指定所回答的问题消息ID
 6    上课/下课    上课  ； 下课
 7    接受/拒绝举手    接受  ； 拒绝
 8    学生锁    打开  ； 关闭
 9    摄像头    打开  ； 关闭
 10    麦克风    打开  ； 关闭
 11    点赞    无
 12    举手控制开关    1：允许/ 0：禁止举手
 13    翻页    翻页动作
 14    删除图形    删除指定图形
 15    清空页面    清空指定页面中的批注
 16    新增白板页
 17    设置白板页背景    设置页面的背景色/背景图片
 18    学生提交答题器答案    提交答题器答案
 19    学生端答到    回应点名
 20    学生端提交测验答案    提交测验（测试）答案
 */
@property (nonatomic, copy) NSString *cmdType;

@property (nonatomic, copy) NSString *bagCount;

@property (nonatomic, copy) NSString *bagIndex;

@property (nonatomic, copy) NSString *bagId;

@property (nonatomic, strong) NCCustomeElemMSG *cmdData;

+ (instancetype)customMessageWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
