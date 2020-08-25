//
//  YQDLeftImgBtn.m
//  YQD_Student_iPad
//
//  Created by 王志盼 on 2018/2/2.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "YQDLeftImgBtn.h"

@implementation YQDLeftImgBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    UIImage *img = self.currentImage;
    CGFloat x = 0;
    CGFloat y = (contentRect.size.height - img.size.height) / 2;
    return CGRectMake(x, y, img.size.width, img.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    UIImage *img = self.currentImage;
    CGFloat x = img.size.width + 5;
    CGFloat y =(contentRect.size.height - 16) / 2;
    return CGRectMake(x, y, contentRect.size.width - x, 16);
}

@end
