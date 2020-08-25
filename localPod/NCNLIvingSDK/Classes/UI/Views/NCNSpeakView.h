//
//  NCNSpeakView.h
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/2.
//  Copyright © 2020 newcloudnet. All rights reserved.
//   

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class TIMMessage;
@class NCNMessageCellModel;
@interface NCNSpeakView : UIView

@property (nonatomic, weak) UIViewController *belongVC;
@property (nonatomic, copy) void(^faceKeyboardIsShowCallback)(BOOL isShow);



- (void)insertNewMessages:(NSArray<TIMMessage *> *)messages;
- (void)sendMessageWithContent:(NSString *)content;
- (void)sendImageMessageWithImages:(NSArray<UIImage *> *)images;
- (void)sendMessageWithCellModel:(NCNMessageCellModel *)model;

- (void)enterLandscapeScreen;
- (void)enterPortraitScreen;

- (void)startToEdit;
- (void)stopToEdit;

- (void)scrollToMessageBottom;

- (TIMMessage *)lastMessage;

/**
 外部控制器主动调用
 */
- (void)copyMessageAction;
- (void)revokeMessageAction;
@end

NS_ASSUME_NONNULL_END
