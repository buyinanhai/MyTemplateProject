//
//  ZYDrawTextField.h
//  YQD_Student_iPad
//
//  Created by 纤夫的爱 on 2018/10/11.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYDrawTextField : UITextView
// 选颜色
@property (nonatomic, assign) uint32_t chooseColor;

// 字体粗细
@property (nonatomic, assign) float weight;

- (instancetype)initWithFontColor:(uint32_t)chooseColor weight:(float)weight;

@end

NS_ASSUME_NONNULL_END
