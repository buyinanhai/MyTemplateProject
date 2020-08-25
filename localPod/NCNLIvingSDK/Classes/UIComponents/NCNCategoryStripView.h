//
//  NCNCategoryStripView.h
//  XYClassRoom
//
//  Created by lzh on 2018/7/19.
//  Copyright © 2018年 newcloudnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCNCategoryStripView;

@protocol NCNCategoryStripViewDelegate <NSObject>
/** 点击了分类按钮 btnIdx 从0开始 */
-(void)categoryStripView:(NCNCategoryStripView *)ctgV selectedButton:(NSUInteger)btnIdx;

@end


/** 分类条，可滑动，带滑块 */
@interface NCNCategoryStripView : UIScrollView

@property (assign,nonatomic) CGFloat sliderWidth;  ///< 滑块宽度 默认12 需要设置

@property (assign,nonatomic) CGFloat sliderH;  ///< 滑块高度 需要设置
/** 设置 text 要在categoryNames赋值之前 */
@property (copy,nonatomic) UIFont *textFont;
@property (copy,nonatomic) UIFont *textFontSelected;
@property (copy,nonatomic) UIColor *textColorNormal;
@property (copy,nonatomic) UIColor *textColorSelected;
@property (copy,nonatomic) NSArray *selectColorArr; //< 选中状态可以是不同的颜色
@property (copy,nonatomic) UIColor *btnColorSelected;
@property (assign,nonatomic) CGFloat btnCornerRadius;

@property (assign,nonatomic) CGFloat minBtnW; ///< 按钮最小宽度
@property (assign,nonatomic) CGFloat textGap; ///< 字间距
@property (assign,nonatomic) CGFloat btnGap;  ///< 按钮的间距。通过加宽按钮实现此视觉效果
@property (assign,nonatomic) BOOL needEvenly; ///< 当按钮总宽少于view宽时，是否需要均匀分布 默认YES

/** 设置完其他后，最后来给数据 */
@property (copy,nonatomic) NSArray *categoryNames;
@property (weak,nonatomic) id <NCNCategoryStripViewDelegate> actionDelegate;


- (void)moveTo:(NSInteger)idx;  //移动到哪个Category
- (NSInteger)getSelectedIndex;

@end
