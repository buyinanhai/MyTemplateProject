//
//  NCNMemberCell.h
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/18.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TIMUserProfile;
@interface NCNMemberCell : UITableViewCell

@property (nonatomic, weak) TIMUserProfile *profile;

@end

NS_ASSUME_NONNULL_END
