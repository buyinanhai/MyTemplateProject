//
//  NCNPublishView.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/18.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNPublishView.h"
#import "UIView+Extension.h"

@interface NCNPublishView()

@end
@implementation NCNPublishView

+ (instancetype)showPublishView {
    return [self viewFromXib];
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = UIColor.redColor;
}
- (IBAction)emojialBtnClick {
    if ([self.delegate respondsToSelector:@selector(didClickEmojialBtnInPublishView:)]) {
        [self.delegate didClickEmojialBtnInPublishView:self];
    }
}

- (IBAction)photoBtnClik {
    if ([self.delegate respondsToSelector:@selector(didClickPhotoBtnInPublishView:)]) {
        [self.delegate didClickPhotoBtnInPublishView:self];
    }
}

- (IBAction)attramentBtnClick {
    if ([self.delegate respondsToSelector:@selector(didClickAttramentBtnInPublishView:)]) {
        [self.delegate didClickAttramentBtnInPublishView:self];
    }
}



@end
