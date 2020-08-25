//
//  NCNQ&ACellData.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/4/27.
//

#import "NCNQ&ACellData.h"

@implementation NCNQ_ACellData


- (CGFloat)askContentHeight {
    
    CGFloat width = kScreen_Width - 100;

    CGFloat topMargin = 80;
    
    CGFloat resultHeight = topMargin;
    if (self.askText.length > 0) {
        CGSize answerSize = [self.askText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        resultHeight += answerSize.height;
    }
    
   
    
    return resultHeight;
}

- (CGFloat)answerContentHeight {
    
    CGFloat width = kScreen_Width - 100;

    CGFloat topMargin = 60;
    
    CGFloat resultHeight = topMargin;
    
    if (self.answerText.length > 0) {
        CGSize askSize = [self.answerText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        resultHeight += askSize.height;
    } else {
        resultHeight = 0;
    }
    
    return resultHeight;
}
@end
