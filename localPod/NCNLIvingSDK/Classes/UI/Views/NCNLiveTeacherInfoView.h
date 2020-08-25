//
//  NCNLiveTeacherInfoView.h
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/1.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NCNLiveTeacherInfoView;
@class NCNLivingRoomModel;
@protocol NCNLiveTeacherInfoDelegate <NSObject>

- (void)teacherInfoView:(NCNLiveTeacherInfoView *)view isFold:(BOOL)isfold;

@end

@interface NCNLiveTeacherInfoView : UIView

- (void)updateWithModel:(NCNLivingRoomModel *)model;

@property (nonatomic, weak) id<NCNLiveTeacherInfoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
