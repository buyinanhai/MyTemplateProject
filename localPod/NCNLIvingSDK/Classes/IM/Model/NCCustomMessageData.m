//
//  NCCustomMessageData.m
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/13.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCCustomMessageData.h"
#import "NCCustomeElemMSG.h"

@implementation NCCustomMessageData



+ (instancetype)customMessageWithDict:(NSDictionary *)dict {
    
    NCCustomMessageData *data = [NCCustomMessageData new];
    
    data.bagId = dict[@"bagId"];
    data.bagCount = dict[@"bagCount"];
    data.bagIndex = dict[@"bagIndex"];
    data.cmdType = dict[@"cmdType"];
    data.bagId = dict[@"bagId"];
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
    NSDictionary<NSString *, NSString *> *classDict = @{
        @"0": @"NCDrawElemMSG",
        @"1": @"NCControlElemMSG",
        @"2": @"NCAnswerElemMSG",
        @"3": @"NCCustomeElemMSG",
        @"4": @"NCExamElemMSG",
        @"5": @"NCQAElemMSG",
        @"6": @"NCCustomeElemMSG",
        @"7": @"NCCustomCommonElemMSG",
        @"8": @"NCCustomeElemMSG",
        @"9": @"NCCustomeElemMSG",
        @"10": @"NCCustomeElemMSG",
        @"11": @"",
        @"12": @"NCCustomeElemMSG",
        @"13": @"NCControlElemMSG",
        @"14": @"NCDrawElemMSG",
        @"15": @"NCDrawElemMSG",
        @"16": @"NCAddNewBlankElemMSG",
        @"17": @"NCAddNewBlankElemMSG",
        @"18": @"NCCustomeElemMSG",
        @"19": @"NCCustomeElemMSG",
        @"20": @"NCCustomeElemMSG",
        @"21": @"NCCustomCommonElemMSG",
        @"22": @"NCCustomCommonElemMSG"
    };
    NSString *clsStr = classDict[data.cmdType];
    if (clsStr.length > 0) {
        Class class = NSClassFromString(clsStr);
        data.cmdData = [class customElemMSGWithDict:dict[@"cmdData"]];
    }

    
    return data;
    
}

@end
