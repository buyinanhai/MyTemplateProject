//
//  ZYDottedLineField.m
//
//  Created by 王志盼 on 2018/5/24.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYDottedLineField.h"

@interface ZYDottedLineField()
@property (nonatomic, assign) BOOL isCallDrawRect;
@end

@implementation ZYDottedLineField

- (instancetype)init
{
    if (self = [super init])
    {
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commitInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commitInit];
}

- (void)commitInit
{
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.font = [UIFont systemFontOfSize:18];
    self.isCallDrawRect = true;
    [self addTarget:self action:@selector(editingText:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(endEditingText) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)editingText:(UITextField *)textField
{
    NSString *text = textField.text;
    CGSize maxSize = CGSizeMake(900 - self.x, 35);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    //默认的
    CGRect infoRect =   [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    self.width = kStartW;
    if (infoRect.size.width > kStartW)
    {
        self.width = infoRect.size.width;
    }
}

- (void)endEditingText
{
    
}

- (void)moveTextfieldPathPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint
{
    CGFloat marginX = currentPoint.x - previousPoint.x;
    CGFloat marginY = currentPoint.y - previousPoint.y;
    self.x += marginX;
    self.y += marginY;
}


- (void)drawRect:(CGRect)rect
{
//    if (self.isCallDrawRect)
    {
        CGContextRef content = UIGraphicsGetCurrentContext();
        CGPoint Point[4];
        Point[0] = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
        Point[1] = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
        Point[2] = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        Point[3] = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGContextAddLines(content, Point, 4);
        CGContextClosePath(content);
        [[UIColor whiteColor] setStroke];
        CGContextSetLineWidth(content, 2);
        CGContextSetLineCap(content, kCGLineCapRound);
        CGContextSetLineJoin(content, kCGLineJoinRound);
        CGFloat dashArray[] = {4,4};
        CGContextSetLineDash(content, 0, dashArray, 2);
        CGContextStrokePath(content);
    }
    
}

@end
