//
//  NCNQuestionAskView.h
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/3.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NCNQ_ACellData;
@interface NCNQuestionAskView : UIView

@property (nonatomic, copy) void(^publishBtnClickCallback)(void);


- (void)addQAData:(NSArray<NCNQ_ACellData *> *)datas;


- (NCNQ_ACellData *)findDataWithId:(NSString *)id;
- (void)updateData:(NCNQ_ACellData *)data;
@end

NS_ASSUME_NONNULL_END
