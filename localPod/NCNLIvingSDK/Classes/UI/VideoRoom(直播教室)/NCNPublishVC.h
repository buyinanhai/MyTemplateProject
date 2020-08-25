//
//  NCNPublishVC.h
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/18.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCNPublishVC : UIViewController
@property (nonatomic, copy) void(^publishBtnClickCallback)(NCNPublishVC *vc,NSString *text);

@end

NS_ASSUME_NONNULL_END
