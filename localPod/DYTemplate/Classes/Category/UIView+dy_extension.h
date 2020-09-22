//
//  UIView+Extension.h

//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 LUKHA_Lu. All rights reserved.
//

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

#define kScreenWidthRatio kScreenWidth / 375
#define kScreenHeightRatio kScreenHeight / 667



#import <UIKit/UIKit.h>

@interface UIView (dy_extension)

@property (nonatomic, assign) CGFloat dy_x;
@property (nonatomic, assign) CGFloat dy_y;
@property (nonatomic, assign) CGFloat dy_width;
@property (nonatomic, assign) CGFloat dy_height;
@property (nonatomic, assign) CGFloat dy_centerX;
@property (nonatomic, assign) CGFloat dy_centerY;
@property (nonatomic, assign) CGSize dy_size;
@property (nonatomic, assign) CGPoint dy_origin;
@property (nonatomic, assign, readonly) CGFloat dy_maxX;
@property (nonatomic, assign, readonly) CGFloat dy_maxY;


//获取该视图的控制器
- (UIViewController*) viewController;

//删除当前视图内的所有子视图
- (void)removeChildViews;

//删除tableview底部多余横线
- (void)setExtraCellLineHidden: (UITableView *)tableView;

- (void)addRound:(CGFloat)radius;

- (void)addShadow:(CGFloat)shadowRadius round:(CGFloat)roundRadius;

- (void)addBoard:(CGFloat)radius color: (UIColor *)color;

- (void)addTarget:(id)target selector:(SEL)selector;
@end
