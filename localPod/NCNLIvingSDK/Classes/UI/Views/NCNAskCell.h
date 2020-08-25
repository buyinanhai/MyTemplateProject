//
//  NCNAskCell.h
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/14.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class NCNQ_ACellData;
@interface NCNAskCell : UITableViewCell

@property (assign,nonatomic) CGFloat cellH;

@property (nonatomic, weak) NCNQ_ACellData *data;


@end

@interface NCNQACellContentView : UIView
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) UILabel *QANamelabel;
@property (nonatomic, strong) UILabel *QATimelabel;

+ (instancetype)QAViewWithIsAsk:(BOOL)isAsk;

@end


NS_ASSUME_NONNULL_END
