//
//  NCNMessageCellModel.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    NCNMessageStatus_Sending = 1,
    NCNMessageStatus_Successed,
    NCNMessageStatus_Failed,
    NCNMessageStatus_HasDeleted,
    NCNMessageStatus_LocalStored,
    NCNMessageStatus_Revoked,
} NCNMessageStatus;

#define NCN_IM_Cell_Reuse_Identifier_Text @"NCN_IM_Cell_Reuse_Identifier_Text"
#define NCN_IM_Cell_Reuse_Identifier_Image @"NCN_IM_Cell_Reuse_Identifier_Image"

@class TIMMessage;
@class TIMImage;
@interface NCNMessageCellModel : NSObject

+ (instancetype)messageCellModelWithMessage:(TIMMessage *)message;

/**
 更新消息的状态回调
 */
@property (nonatomic, copy) void(^messageStatusUpdateCallback)(void);

@property (nonatomic, assign) NCNMessageStatus status;


@property (nonatomic, strong) TIMMessage *message;

@property (nonatomic, assign) BOOL isSelf;

@property (nonatomic, copy) NSString *senderName;

@property (nonatomic, assign) BOOL isTeacher;

@property (nonatomic, copy) NSString *reuseIdentifier;


@property (nonatomic, assign) CGSize contentSize;


- (void)update;

@end



@interface NCNTextMessageCellModel : NCNMessageCellModel

@property (nonatomic, copy) NSString *content;
/**
 *  可变字符串
 *  文本消息接收到 content 字符串后，需要将字符串中可能存在的字符串表情（比如[微笑]），转为图片表情。
 *  本字符串则负责存储上述过程转换后的结果。
 */
@property (nonatomic, copy) NSAttributedString *attributedString;
/**
 *  文本字体
 *  文本消息显示时的 UI 字体。
 */
@property (nonatomic, copy) UIFont *textFont;

/**
 *  文本颜色
 *  文本消息显示时的 UI 颜色。
 */
@property (nonatomic) UIColor *textColor;

/**
 *  文本内容尺寸。
 *  配合原点定位文本消息。
 */
@property (readonly) CGSize textSize;

@end

@interface NCNImageMessageCellModel : NCNMessageCellModel

///发送的图片的路径
@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) UIImage *image;

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, strong) TIMImage *imageItem;

/**
 上传或下载的进度
 */
@property (nonatomic, assign) CGFloat progress;


@end


NS_ASSUME_NONNULL_END
