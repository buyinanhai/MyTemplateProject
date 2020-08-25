//
//  NCNTestResultView.h
//  LFLiveKit
//
//  Created by 汪宁 on 2020/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NCAnswerElemMSG;
@interface NCNTestResultView : UIView

- (void)showOnView:(UIView *_Nonnull)view elemMsg:(NCAnswerElemMSG *)msg;

@end

NS_ASSUME_NONNULL_END
