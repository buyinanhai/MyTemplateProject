//
//  ZYDottedLineField.h
//
//  Created by 王志盼 on 2018/5/24.
//  Copyright © 2018年 王志盼. All rights reserved.
//  虚线TextField

#import <UIKit/UIKit.h>

#define kStartW 120

@interface ZYDottedLineField : UITextField
- (void)moveTextfieldPathPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint;
@end
