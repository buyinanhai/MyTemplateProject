//
//  NCNBlankView.m
//  XYClassRoom
//
//  Created by 尹彦博 on 2020/4/23.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNBlankView.h"
#import "Masonry.h"
#import "NCNImageCollectionViewCell.h"
#import "NCNBlankPPTListView.h"
#import "NCAddNewBlankElemMSG.h"

@interface NCNBlankView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray<NCNBlankPPTListCellModel *> *datas;

@property (nonatomic, weak) NSIndexPath *willShowIndex;

@property (nonatomic, strong) UILabel *noTeacherLabel;

@property (nonatomic, strong) NCNBlankCellView *contentView;

@property (nonatomic, weak) UIButton *blankBtn;

@end

@implementation NCNBlankView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self setupSubview];
    return self;
}
- (instancetype)init {
    
    self = [super init];
    self.clipsToBounds = true;
    self.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    return self;
}

- (void)setupSubview {
    
    self.contentView = [[NCNBlankCellView alloc] init];
    self.contentView.hidden = true;
    [self addSubview:self.contentView];

    UIButton *blankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [blankBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    blankBtn.backgroundColor = YQDColor(0, 0, 0, 1);
    blankBtn.layer.cornerRadius = 3.0;
       blankBtn.layer.masksToBounds = true;
    blankBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [blankBtn setTitle:@"白板" forState:UIControlStateNormal];
    [blankBtn addTarget:self action:@selector(blankBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [blankBtn.titleLabel adjustsFontSizeToFitWidth];
    [self addSubview:blankBtn];
    [blankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-8);
        make.centerX.offset(0);
        make.width.offset(65);
        make.height.offset(26);
    }];
  
    self.blankBtn = blankBtn;
    self.blankBtn.hidden = true;

    
    [self addSubview:self.noTeacherLabel];
    [self.noTeacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.height.offset(40);
        make.width.offset(160);
    }];
    
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (self.contentView.width == 0) {
        self.contentView.frame = self.bounds;
    }
    
}

#pragma mark 显示白板或课件
- (void)showContentWithCellModel:(NCNBlankPPTListCellModel *)model {
    if (model == nil) return;
    self.contentView.hidden = false;
    //内部实现画图操作
    [self.contentView showWithModel:model isNeedRedraw:true];
    
    NSString *symbol = [NSString stringWithFormat:@"%@%d",[model.useIdentifier isEqualToString:@"blank"] ? @"白板" : @"课件",model.pageIndex.intValue];
    [self.blankBtn setTitle:symbol forState:UIControlStateNormal];
    
}



#pragma mark 画图操作

- (void)addNewDrawMSG:(NCDrawElemMSG *)msg {
    
    NCNBlankPPTListCellModel *currentModel = self.contentView.model;
    if (currentModel.newDrawMessageCallback) {
        currentModel.newDrawMessageCallback(msg);
    }
    [self.contentView addNewDrawMSG:msg];
}

- (void)deleteAnyoneDrawWithDrawMessage:(NCDrawElemMSG *)msg {
    
    NCNBlankPPTListCellModel *currentModel = self.contentView.model;
    if (currentModel.deleteDrawMessageCallback) {
        currentModel.deleteDrawMessageCallback(msg);
    }
    [self.contentView deleteAnyoneDrawWithDrawMessage:msg];
    
}

- (void)updateDrawLayerBackgroundColorWithMessage:(NCAddNewBlankElemMSG *)msg {
    
    NCNBlankPPTListCellModel *currentModel = self.contentView.model;
    if (currentModel.updateDrawLayerBackgroundColorCallback) {
        currentModel.updateDrawLayerBackgroundColorCallback(msg);
    }
    [self.contentView updateDrawLayerBackgroundColorWithMessage:msg];
    
}

- (void)clearDrawLayerWithDrawMessage:(NCDrawElemMSG *)msg {
   
    NCNBlankPPTListCellModel *currentModel = self.contentView.model;
    if (currentModel.clearDrawLayerCallback) {
        currentModel.clearDrawLayerCallback(msg);
    }
    [self.contentView clearDrawLayerWithDrawMessage:msg];
}


- (void)blankBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(blankView:onButtonClicked:)]) {
        
        sender.selected = !sender.isSelected;
        [self.delegate blankView:self onButtonClicked:sender.isSelected];
    }
}


- (void)classEnded {
    
    [self.contentView showWithModel:nil isNeedRedraw:false];
    self.noTeacherLabel.hidden = false;

    
}

- (void)exitFullScreenBtnClick {
    
    [self prepareRatateOritentionPortrait];
    
}

- (void)prepareRatateOritentionLandscape {
    
    if (self.oritention == NCLivingViewOritention_landscape) return;
    
    [super prepareRatateOritentionLandscape];
    
    //当白板是变大的状态 才处理横屏
    if (self.state == NCLivingViewStateBig) {
        self.oritention = NCLivingViewOritention_rotating;
        [self changeContentViewToLandscapeWithTargetFrame:UIScreen.mainScreen.bounds];
    }
   
    self.oritention = NCLivingViewOritention_landscape;
    
}

- (void)changeContentViewToLandscapeWithTargetFrame:(CGRect)frame {
  
    
    CGFloat targetHeight = frame.size.height;
    
    ///在旋转的时候  自身的frame 先变化为全屏了
    CGFloat height = self.oritention == NCLivingViewOritention_rotating ? self.portraitFrame.size.height : self.height;

    CGFloat scale = targetHeight / height;
        
    //旋转时不需要修改view的transform
    if (self.oritention == NCLivingViewOritention_rotating) {
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, scale, scale);
        
    } else {
        if (targetHeight == self.portraitFrame.size.height) {
            //在回到最初的形状时还原transform
            self.transform = CGAffineTransformIdentity;
            self.contentView.transform = CGAffineTransformIdentity;
        } else if (targetHeight > self.portraitFrame.size.height && self.portraitFrame.size.height > 0) {
            //如果是横屏需要从小变到横屏大小时
            self.transform = CGAffineTransformIdentity;
            scale = targetHeight / self.portraitFrame.size.height;
            self.contentView.transform = CGAffineTransformMakeScale(scale, scale);

        } else {
            
            self.transform = CGAffineTransformScale(self.transform, scale, scale);
        }
    }
    
    CGFloat contentNewX = MAX((frame.size.width - self.contentView.width) * 0.5, 0);
    self.contentView.frame = CGRectMake(contentNewX, 0, self.contentView.width, self.contentView.height);
    
}

- (void)prepareRatateOritentionPortrait {
    if (self.oritention == NCLivingViewOritention_portrait) return;

    [super prepareRatateOritentionPortrait];
    
    if (self.state == NCLivingViewStateBig) {
        
//        [self changeContentViewToLandscapeWithTargetFrame:self.portraitFrame];
        [UIView animateWithDuration:0.25 animations:^{
            
            self.contentView.transform = CGAffineTransformIdentity;
            self.contentView.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
            
        } completion:^(BOOL finished) {
            //        self.exitFullScreenBtn.hidden = true;
        }];
    }
   
    self.oritention = NCLivingViewOritention_portrait;
    
}

- (void)prepareZoomToBigFrame:(CGRect)frame {
    
    [self changeContentViewToLandscapeWithTargetFrame:frame];
    self.blankBtn.enabled = true;

//    self.collectionView.scrollEnabled = true;

    
}

- (void)prepareZoomToSmallFrame:(CGRect)frame {
    
    [self changeContentViewToLandscapeWithTargetFrame:frame];
    self.blankBtn.enabled = false;

//    self.transform = CGAffineTransformMakeScale(0.30, 0.30);
//    self.collectionView.scrollEnabled = false;
    
}


- (void)showBlanksOrPPTs:(NSArray<NCNBlankPPTListCellModel *> *)datas {
    
    __block NSInteger selectItem = 0;
    [datas enumerateObjectsUsingBlock:^(NCNBlankPPTListCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            selectItem = idx;
            *stop = true;
        }
    }];
    self.datas = datas;
    
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:false];
    
}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath {
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    
}


#pragma mark uicollectionviewdelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}


#pragma mark - collectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NCNImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NCNImageCollectionViewCellId" forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    return  cell;
}


-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    self.blankLabel.text = [NSString stringWithFormat:@" %02zd/%02zd ",self.willShowIndex.row + 1,self.datas.count];
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    self.willShowIndex = indexPath;
    
}



- (void)updateState {
    
    self.noTeacherLabel.hidden = kLivingConfig.isBegin.boolValue;
    
    self.blankBtn.hidden = !self.noTeacherLabel.hidden;
    
}


- (UILabel *)noTeacherLabel {
    
    if (!_noTeacherLabel) {
        _noTeacherLabel = [UILabel new];
        _noTeacherLabel.backgroundColor = [UIColor whiteColor];
        [_noTeacherLabel sl_setCornerRadius:10];
        _noTeacherLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"老师不在教室" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:117/255.0 green:119/255.0 blue:131/255.0 alpha:1.0]}];
        _noTeacherLabel.attributedText = string;
    }
    return _noTeacherLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


#import "ZYDrawingView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ZYDrawingView+ReceiveData.h"
@interface NCNBlankCellView () <UIScrollViewDelegate>
@property (nonatomic, weak) NCNBlankPPTListCellModel  *model;

@property (weak, nonatomic) UIScrollView *scrV;
@property (weak, nonatomic) UIImageView *imgV;
@property (nonatomic, strong) ZYDrawingView *drawView;

@property (nonatomic, assign) BOOL isDrawed;

@end

@implementation NCNBlankCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViews];
        self.userInteractionEnabled = false;
    }
    return self;
}

- (void)showWithModel:(NCNBlankPPTListCellModel *)model isNeedRedraw:(BOOL)isNeedReDraw {

    
    if (model == nil) {
        [self.drawView clearDrawingLayer];
        self.drawView.backgroundColor = UIColor.clearColor;
        self.imgV.image = nil;
        return;
    }
    if (_model && [self.superview isKindOfClass:NCNBlankView.class]) {
        _model.newDrawMessageCallback = nil;
        _model.deleteDrawMessageCallback = nil;
        _model.clearDrawLayerCallback = nil;
        _model.updateDrawLayerBackgroundColorCallback = nil;
    }
    _model = model;
    //只在白板的view里面实现 方便同步画笔
    if ([self.superview isKindOfClass:NCNBlankView.class]) {
       
        kWeakSelf(self);
        model.newDrawMessageCallback = ^(NCDrawElemMSG * _Nonnull msg) {
            [weakself addNewDrawMSG:msg];
        };
        model.deleteDrawMessageCallback = ^(NCDrawElemMSG * _Nonnull msg) {
            [weakself deleteAnyoneDrawWithDrawMessage:msg];
        };
        model.clearDrawLayerCallback = ^(NCDrawElemMSG * _Nonnull msg) {
            [weakself clearDrawLayerWithDrawMessage:msg];
        };
        model.updateDrawLayerBackgroundColorCallback = ^(NCAddNewBlankElemMSG * _Nonnull msg) {
            [weakself updateDrawLayerBackgroundColorWithMessage:msg];
        };
    }
    
    if (isNeedReDraw) {
        self.isDrawed = false;
        [self layoutSubviews];
    }
    self.drawView.backgroundColor = model.blankColor == nil ? UIColor.clearColor : model.blankColor;
    
    if (model.pptImageURL.length > 1) {
        [self.imgV setImageWithURL:[NSURL URLWithString:model.pptImageURL]];
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (self.isDrawed == false) {
        [self.drawView clearDrawingLayer];
        [self.model.draws enumerateObjectsUsingBlock:^(NCDrawElemMSG * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.drawView receiveIMElemMsg:obj layerSize:self.size];
        }];
        self.isDrawed = true;
    }
    
}


-(void)setImageUrl:(NSString *)imageUrl {
    
    _imgV.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    
}

- (void)setImageSize:(CGSize)sz {
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(sz);
    }];
    
}

- (void)addNewDrawMSG:(NCDrawElemMSG *)msg {
   
    [self.drawView receiveIMElemMsg:msg layerSize:self.size];
}

-(void)deleteAnyoneDrawWithDrawMessage:(NCDrawElemMSG *)msg {
    
    [self.drawView receiveDeletedMsg:msg];
    
}
- (void)clearDrawLayerWithDrawMessage:(NCDrawElemMSG *)msg {
   
    [self.drawView clearDrawingLayer];
}
- (void)updateDrawLayerBackgroundColorWithMessage:(NCAddNewBlankElemMSG *)msg{
    
    if (msg.Color.length ==0) return;
    
    
    
    UIColor *blankColor = [NCCustomeElemMSG getColorFromColorString:msg.Color];
    self.model.blankColor = blankColor;
    self.drawView.backgroundColor = blankColor;
    
}

-(void)resetImageScale {
    self.scrV.zoomScale = 1.0;
}

- (void)addSubViews {
    
    UIScrollView *scrV = [UIScrollView new];
    scrV.bounces = NO;
    scrV.showsVerticalScrollIndicator = NO;
    scrV.showsHorizontalScrollIndicator = NO;
    scrV.maximumZoomScale = 2.0;
    scrV.minimumZoomScale = 0.6;
    scrV.delegate = self;
    
    UIImageView *imgV = [UIImageView new];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    self.scrV = scrV;
    self.imgV = imgV;
    
    [scrV addSubview:imgV];
    [self addSubview:scrV];
    
    [scrV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(scrV);
        make.size.equalTo(self);
    }];
    
    ZYDrawingView *drawView = [[ZYDrawingView alloc] initWithDefaultPenColor:UIColor.redColor];
    drawView.type = ZYDrawingTypeDrawing;
    drawView.backgroundColor = UIColor.whiteColor;
    [self addSubview:drawView];

    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.drawView = drawView;
}

#pragma mark - delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgV;
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {

    [self.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrV);
    }];
    
}

@end
