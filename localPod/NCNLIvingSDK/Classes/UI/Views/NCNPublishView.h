//
//  NCNPublishView.h
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/18.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NCNPublishView;
@protocol PublishViewDelegate <NSObject>

@optional;

- (void)didClickEmojialBtnInPublishView:(NCNPublishView *)publishView;
- (void)didClickPhotoBtnInPublishView:(NCNPublishView *)publishView;
- (void)didClickAttramentBtnInPublishView:(NCNPublishView *)publishView;

@end

@interface NCNPublishView : UIView
@property (weak,nonatomic) id <PublishViewDelegate> delegate;
+ (instancetype)showPublishView;
@end

NS_ASSUME_NONNULL_END
