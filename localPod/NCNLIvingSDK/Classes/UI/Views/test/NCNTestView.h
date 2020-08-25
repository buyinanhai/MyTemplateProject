//
//  NCNTestView.h
//  LFLiveKit
//
//  Created by 汪宁 on 2020/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 试题超类
 */

@class NCAnswerElemMSG;
@interface NCNTestView : UIView

@property (nonatomic, copy) void(^submitAnswerCallback)(NCNTestView *view, NSString *result);


+ (instancetype)testWithElem:(NCAnswerElemMSG *)msg;

- (void)showOnView:(UIView *_Nonnull)view;

- (void)setupTestContent;

- (UIScrollView *)testContentView;

- (void)canSubmit:(BOOL)isCan;

- (NCAnswerElemMSG *)elemMsg;

- (void)dismiss;

- (void)testEnded;

/**
 子类实现
 */
- (void)confirmBtnClick:(UIButton *)sender;

- (BOOL)timeIsExhausted;
@end

NS_ASSUME_NONNULL_END
