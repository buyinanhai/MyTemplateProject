//
//  NCNMessageImageCell.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NCNMessageCellModel;

@interface NCNMessageCell : UITableViewCell

/**
 显示内容区域被点击
 */
@property (nonatomic, copy) void(^bubbleViewClickCallback)(NCNMessageCell *cell, NCNMessageCellModel *model);
/**
 点击了 消息发送失败的按钮
 */
@property (nonatomic, copy) void(^failedBtnClickCallback)(NCNMessageCell *cell, NCNMessageCellModel *model);

/**
 显示内容区域长按
 */
@property (nonatomic, copy) void(^bubbleViewLongPressedCallback)(NCNMessageCell *cell, NCNMessageCellModel *model);



@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *bublleView;
//0 == 竖屏  1 ： 横屏： 暗黑
@property (nonatomic, assign) int style;

@property (nonatomic, weak) NCNMessageCellModel *model;

- (void)setupBubbleView;

@end


@interface NCNMessageTextCell : NCNMessageCell
@property (nonatomic, strong) UILabel *contentLabel;


@end


@interface NCNMessageImageCell : NCNMessageCell
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *progressLabel;


@end

NS_ASSUME_NONNULL_END
