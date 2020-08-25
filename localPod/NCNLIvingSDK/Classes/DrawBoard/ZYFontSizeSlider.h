//
//  ZYFontSizeSlider.h
//  YQD_Student_iPad
//
//  Created by 纤夫的爱 on 2018/10/23.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZYFontSizeSliderDelegate <NSObject>

- (void)sendCurrentSliderValue:(float)value;

@end
@interface ZYFontSizeSlider : UIView
@property (nonatomic ,weak) id<ZYFontSizeSliderDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
