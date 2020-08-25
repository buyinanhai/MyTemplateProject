//
//  ZYMathGraphDock.h
//  YQD_Student_iPad
//
//  Created by 纤夫的爱 on 2018/10/22.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZYMathGraphDock;
@protocol ZYMathGraphDockDelegate <NSObject>
- (void)mathGraphBtnCallBackWithTag:(NSInteger)tag;
@end


@interface ZYMathGraphDock : UIView//数学画图小工具
@property (nonatomic ,weak) id<ZYMathGraphDockDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
