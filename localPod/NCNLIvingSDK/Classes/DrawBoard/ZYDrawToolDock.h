//
//  ZYDrawToolDock.h
//  YQD_Teach_iPad
//
//  Created by 纤夫的爱 on 2018/10/19.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZYDrawToolDock;
@protocol ZYDrawToolDockDelegate <NSObject>
- (void)penBtnCallBackWithPenWeight:(float)weight;
- (void)colorBtnCallBackWithColorHex:(NSString *)colorHex;
@end


@interface ZYDrawToolDock : UIView
@property (nonatomic ,weak) id<ZYDrawToolDockDelegate>delegate;
- (void)moveToX:(CGFloat)x;
-(void)setFillColorViewHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
