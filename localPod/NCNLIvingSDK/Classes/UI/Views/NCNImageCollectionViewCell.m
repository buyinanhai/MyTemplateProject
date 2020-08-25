//
//  NCNImageCollectionViewCell.m
//  XYClassRoom
//
//  Created by IOSrsn on 2020/3/25.
//  Copyright © 2020 newcloudnet. All rights reserved.
//


#import "NCNImageCollectionViewCell.h"
#import "Masonry.h"
#import "zydrawingview.h"
#import "NCNBlankView.h"

@interface NCNImageCollectionViewCell()<UIScrollViewDelegate>

@property (nonatomic, strong) NCNBlankCellView *functionView;

@end



@implementation NCNImageCollectionViewCell





-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self addSomeViews];
    }
    return self;
}


- (void)setModel:(NCNBlankPPTListCellModel *)model {
    _model = model;
    [self.functionView showWithModel:model isNeedRedraw:false];
    
}


#pragma mark - UI
- (void)addSomeViews {
    
    self.functionView = [NCNBlankCellView new];
    self.functionView.userInteractionEnabled = true;
    [self.contentView addSubview:self.functionView];
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}


@end
