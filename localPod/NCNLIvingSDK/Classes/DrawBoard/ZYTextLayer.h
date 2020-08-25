//
//  ZYTextLayer.h
//  YQD_Student_iPad
//
//  Created by 王志盼 on 2018/6/29.
//  Copyright © 2018年 王志盼. All rights reserved.
//

//#import <UIKit/UIKit.h>
////@interface ZYTextLayer : UITextField
//@interface ZYTextLayer : UILabel
//@property (nonatomic, copy) NSString *lId;
//@end


#import <UIKit/UIKit.h>

//@interface YQDMoveFied : UITextField
@interface ZYTextLayer : CATextLayer
@property (nonatomic, strong) NSString *lId;

//是否被选中 --- 删除前确认是否选中
@property (nonatomic, assign) BOOL isSelected;

// 选颜色
@property (nonatomic, assign) uint32_t chooseColor;

// 字体粗细
@property (nonatomic, assign) float weight;

//移动
- (void)moveGrafiitiPathPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint;

//- (CGRect)containRect;

//初始化
- (instancetype)initWithFontColor:(uint32_t)chooseColor weight:(float)weight;
@end

