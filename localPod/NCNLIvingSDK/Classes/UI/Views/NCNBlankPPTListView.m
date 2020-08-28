//
//  NCNBlankPPTListView.m
//  LFLiveKit
//
//  Created by 汪宁 on 2020/4/30.
//

#import "NCNBlankPPTListView.h"
#import "NCNBlankView.h"
#import "NCAddNewBlankElemMSG.h"
#import "NCDrawElemMSG.h"
#import "NSTimer+dy_extension.h"

@interface NCNBlankPPTListCell : UICollectionViewCell

@property (nonatomic, weak) NCNBlankPPTListCellModel *blankModel;

- (void)updateSelectState;


- (void)addNewDrawMessage:(NCDrawElemMSG *)msg;
- (void)deleteAnyoneDrawWithDrawMessage:(NCDrawElemMSG *)msg;
- (void)clearDrawLayerWithDrawMessage:(NCDrawElemMSG *)msg;
- (void)updateDrawLayerBackgroundColorWithMessage:(NCAddNewBlankElemMSG *)msg;


@end


@interface NCNBlankPPTListView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *blankListView;
@property (nonatomic, strong) UICollectionView *pptListView;

@property (nonatomic, strong) NSMutableArray<NCNBlankPPTListCellModel *> *blankModels;
@property (nonatomic, strong) NSMutableArray<NCNBlankPPTListCellModel *> *pptModels;

@property (nonatomic, weak) NCNBlankPPTListCellModel *lastBlankSeletModel;
@property (nonatomic, weak) NCNBlankPPTListCellModel *lastPPTSeletModel;

@property (nonatomic, weak) UIButton *folderBtn;
@property (nonatomic, assign) BOOL isLandscape;

//横屏状态时让view在5秒后自己小时
@property (nonatomic, strong) NSTimer *landscapeTimer;

@property (nonatomic, weak) UIButton *arrowBtn;

@end

@implementation NCNBlankPPTListView {
    
    NSInteger _landscapeTimeCount;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
        _landscapeTimeCount = 5;
    }
    return self;
}

- (void)setupSubview {

    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.blankListView];
    [self addSubview:self.pptListView];
    self.blankListView.dataSource = self;
    self.pptListView.dataSource = self;
    self.blankListView.delegate = self;
    self.pptListView.delegate = self;
    
    [self.blankListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.pptListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(8);
        make.left.equalTo(self.mas_right).offset(-100);
        make.width.equalTo(self).multipliedBy(0.8);
        make.bottom.offset(-8);
    }];
    self.pptListView.hidden = true;
   
    [self.pptListView setShadowColor:[UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:0.5] shadowR:5 cornerR:15];
    [self.pptListView living_addShadowWithCornerRadius:5];
    self.pptListView.clipsToBounds = true;
    self.blankModels = @[].mutableCopy;
    self.pptModels = @[].mutableCopy;
   
}

- (void)addBlanks:(NSArray<NCNBlankPPTListCellModel *> *)blanks {
    
    if (blanks.count == 0) return;
    
    if (self.blankModels.count == 0) {
        
        [blanks enumerateObjectsUsingBlock:^(NCNBlankPPTListCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [self.blankModels addObject:obj];
            if (kLivingConfig.currentPage.intValue  == idx + 1) {
                self.lastBlankSeletModel = obj;
                obj.isSelect = true;
            }
        }];
        if (self.lastBlankSeletModel == nil) {
            self.lastBlankSeletModel = blanks.firstObject;
            self.lastBlankSeletModel.isSelect = true;
        }
        [self.blankListView reloadData];
    } else {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:blanks.count];
        [blanks enumerateObjectsUsingBlock:^(NCNBlankPPTListCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:self.blankModels.count inSection:0]];
            [self.blankModels addObject:obj];
        }];
        [self.blankListView insertItemsAtIndexPaths:indexPaths];
    }
    
}
- (void)showPPTs:(NSArray<NCNBlankPPTListCellModel *> *)ppts {
    
     if (ppts.count == 0) return;
    //ppt不会增加或减少页数 分包的情况除外
    [self.pptModels removeAllObjects];
    [self.pptModels addObjectsFromArray:ppts];
    [self.pptListView reloadData];
    self.pptListView.hidden = false;
    self.lastPPTSeletModel = ppts.firstObject;
        
        
}

- (void)addPPTS:(NSArray<NCNBlankPPTListCellModel *> *)ppts {
    
    if (ppts.count == 0) return;
    
    if (self.pptModels.count == 0) {
        
        [ppts enumerateObjectsUsingBlock:^(NCNBlankPPTListCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.pptModels addObject:obj];
        }];
        [self.pptListView reloadData];
        self.pptListView.hidden = false;
        self.lastPPTSeletModel = ppts.firstObject;
    } else {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:ppts.count];
        [ppts enumerateObjectsUsingBlock:^(NCNBlankPPTListCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:self.blankModels.count inSection:0]];
            [self.pptModels addObject:obj];
        }];
        [self.pptModels sortUsingComparator:^NSComparisonResult(NCNBlankPPTListCellModel *  _Nonnull obj1, NCNBlankPPTListCellModel*  _Nonnull obj2) {
            return obj1.pageIndex.intValue > obj2.pageIndex.intValue;
        }];
        [self.pptListView reloadData];
    }
    
}

- (void)addNewDrawMSG:(NCDrawElemMSG *)msg {
    
    NCNBlankPPTListCellModel *model = [self findModelWithType:msg.pageType.intValue pageIndex:msg.pageIndex.intValue];
    NSInteger index = 0;
    UICollectionView *collectionView = nil;
    if (msg.pageType.boolValue) {
        
        collectionView = self.pptListView;
        index = [self.pptModels indexOfObject:model];
    } else {
       
        collectionView = self.blankListView;
        index = [self.blankModels indexOfObject:model];
    }
    if (model) {
        
        [model.draws addObject:msg];
        NCNBlankPPTListCell *cell = (NCNBlankPPTListCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [cell addNewDrawMessage:msg];
        if (model.newDrawMessageCallback) {
            model.newDrawMessageCallback(msg);
        }
        
        
    }
    
}

- (NCNBlankPPTListCellModel *)selectBlankOrPPTWithType:(NCNBlankType)type pageIndex:(NSInteger)pageIndex {
    
    NCNBlankPPTListCellModel *model = [self findModelWithType:type pageIndex:pageIndex];
    if (model == nil) {
        return nil;
    }
    NSInteger index = 0;
    NSInteger lastSelectIndex = 0;
    UICollectionView *collectionView = nil;
    NCNBlankPPTListCellModel *lastModel = nil;
    if (type == 1) {
        
        collectionView = self.pptListView;
        index = [self.pptModels indexOfObject:model];
        lastSelectIndex  = [self.pptModels indexOfObject:self.lastPPTSeletModel];
        lastModel = self.lastPPTSeletModel;
    } else {
       
        collectionView = self.blankListView;
        index = [self.blankModels indexOfObject:model];
        lastSelectIndex  = [self.blankModels indexOfObject:self.lastBlankSeletModel];
        lastModel = self.lastBlankSeletModel;
    }
    if (model) {
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
        NCNBlankPPTListCell *lastCell = (NCNBlankPPTListCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:lastSelectIndex inSection:0]];
        lastModel.isSelect = false;
        [lastCell updateSelectState];
            
        model.isSelect = true;
        NCNBlankPPTListCell *cell = (NCNBlankPPTListCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [cell updateSelectState];
        
        if (type == 1) {
            self.lastPPTSeletModel = model;
        } else {
            self.lastBlankSeletModel = model;
        }
       
    }
    
    return model;
}

- (void)deleteAnyoneDrawWithDrawMessage:(NCDrawElemMSG *)msg {
    
    NCNBlankPPTListCellModel *model = [self findModelWithType:msg.pageType.intValue pageIndex:msg.pageIndex.intValue];
    NSInteger index = 0;
    UICollectionView *collectionView = nil;
    if (msg.pageType.boolValue) {
        
        collectionView = self.pptListView;
        index = [self.pptModels indexOfObject:model];
    } else {
        
        collectionView = self.blankListView;
        index = [self.blankModels indexOfObject:model];
    }
    if (model) {
        __block NSInteger deleteIndex = -1;
        [model.draws enumerateObjectsUsingBlock:^(NCDrawElemMSG * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.itemId isEqualToString:msg.itemId]) {
                deleteIndex = idx;
                *stop = true;
            }
        }];
        if (deleteIndex > 0 && deleteIndex < model.draws.count) {
            
            [model.draws removeObjectAtIndex:deleteIndex];
            NCNBlankPPTListCell *cell = (NCNBlankPPTListCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            [cell deleteAnyoneDrawWithDrawMessage:msg];
            if (model.deleteDrawMessageCallback) {
                model.deleteDrawMessageCallback(msg);
            }
        }
    }
    
}

- (void)clearDrawLayerWithDrawMessage:(NCDrawElemMSG *)msg {
    
       
    NCNBlankPPTListCellModel *model = [self findModelWithType:msg.pageType.intValue pageIndex:msg.pageIndex.intValue];
    NSInteger index = 0;
    UICollectionView *collectionView = nil;
    if (msg.pageType.boolValue) {
        
        collectionView = self.pptListView;
        index = [self.pptModels indexOfObject:model];
    } else {
        
        collectionView = self.blankListView;
        index = [self.blankModels indexOfObject:model];
    }
    if (model) {
        
        [model.draws removeAllObjects];
        NCNBlankPPTListCell *cell = (NCNBlankPPTListCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [cell clearDrawLayerWithDrawMessage:msg];
        if (model.clearDrawLayerCallback) {
            model.clearDrawLayerCallback(msg);
        }
    }
    
}

- (void)updateDrawLayerBackgroundColorWithMessage:(NCAddNewBlankElemMSG *)msg {
    
    NCNBlankPPTListCellModel *model = [self findModelWithType:0 pageIndex:msg.pageIndex.intValue];
    NSInteger index = 0;
    UICollectionView *collectionView = nil;
    collectionView = self.blankListView;
    index = [self.blankModels indexOfObject:model];
    if (model) {
        
        if (model.updateDrawLayerBackgroundColorCallback) {
            model.updateDrawLayerBackgroundColorCallback(msg);
        }
        
        NCNBlankPPTListCell *cell = (NCNBlankPPTListCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [cell updateDrawLayerBackgroundColorWithMessage:msg];
    }
    
}

- (NCNBlankPPTListCellModel *)findModelWithType:(NCNBlankType)type pageIndex:(NSInteger)pageIndex {
   
    __block NCNBlankPPTListCellModel *model = nil;
    UICollectionView *collectionView = nil;
    if (type == 1) {
        [self.pptModels enumerateObjectsUsingBlock:^(NCNBlankPPTListCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.pageIndex.intValue == pageIndex) {
                model = obj;
                *stop = true;
            }
        }];
        collectionView = self.pptListView;
    } else {
        [self.blankModels enumerateObjectsUsingBlock:^(NCNBlankPPTListCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.pageIndex.intValue == pageIndex) {
                model = obj;
                *stop = true;
            }
        }];
        collectionView = self.blankListView;
    }
    return model;
    
}

- (void)clear {
    
    [self.blankModels removeAllObjects];
    [self.blankListView reloadData];
    [self.pptModels removeAllObjects];
    [self.pptListView reloadData];
    self.pptListView.hidden = true;
    
}

- (void)closePPT {
    
    [self.pptModels removeAllObjects];
    [self.pptListView reloadData];
    [self.pptListView setHidden:true];
    NSInteger item = [self.blankModels indexOfObject:self.lastBlankSeletModel];
    [self collectionView:self.blankListView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
}


#pragma mark collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.blankListView) {
        return self.blankModels.count;
    }
    return self.pptModels.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = [NSString stringWithFormat:@"NCNBlankPPTListCell-%ld",indexPath.row];
    [collectionView registerClass:NCNBlankPPTListCell.class forCellWithReuseIdentifier:reuseIdentifier];
    NCNBlankPPTListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
   
    if (collectionView == self.blankListView) {
        [cell sl_setCornerRadius:10];
        cell.clipsToBounds = false;
        cell.blankModel = self.blankModels[indexPath.item];
    } else {
        cell.blankModel = self.pptModels[indexPath.item];
    }
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NCNBlankPPTListCell *_cell = (NCNBlankPPTListCell *)cell;
    NCNBlankPPTListCellModel *model = collectionView == self.blankListView ? self.blankModels[indexPath.row] : self.pptModels[indexPath.row];
    _cell.blankModel = model;

}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == self.blankListView) {
        return CGSizeZero;
    }
    return CGSizeMake(30, collectionView.height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.blankListView) {
        return nil;
    }
    if (indexPath.row == 0 && kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
           UIButton *arrowBtn = nil;
           if (view.subviews.firstObject == nil) {
               arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
               [view addSubview:arrowBtn];
               [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.center.offset(0);
                   make.width.offset(30);
                   make.height.offset(collectionView.height);
               }];
               [arrowBtn addTarget:self action:@selector(arrowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
               [arrowBtn setImage:[UIImage living_imageWithNamed:@"leftArrow@3x"] forState:UIControlStateNormal];
               [arrowBtn setImage:[UIImage living_imageWithNamed:@"rightArrow@3x"] forState:UIControlStateSelected];
               self.arrowBtn = arrowBtn;
            
                   
           }
           return view;
    }
    return nil;
}

- (void)enterLandscape:(BOOL)isLandscape {
   
    self.isLandscape = isLandscape;
    [_landscapeTimer invalidate];
    _landscapeTimer = nil;
    _landscapeTimeCount = 5;
    if (isLandscape) {
        [self.landscapeTimer fire];
    } else {
        self.transform = CGAffineTransformIdentity;
    }
    //屏幕状态切换的是偶 让ppt listview 还原
    self.arrowBtn.selected = false;
    [self makeListViewIsPullOut:false];
}

- (void)showSelfViewOnLandscape {
    
    if (!self.isLandscape) return;
    [_landscapeTimer invalidate];
    _landscapeTimer = nil;
    _landscapeTimeCount = 5;
    [self.landscapeTimer fire];
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
  
}
- (void)dismisswSelfViewOnLandscape {
    if (!self.isLandscape) return;
   [_landscapeTimer invalidate];
      _landscapeTimer = nil;
      [UIView animateWithDuration:0.25 animations:^{
          self.transform = CGAffineTransformMakeTranslation(0, self.height);
      }];
}
- (void)arrowBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    _landscapeTimeCount = 5;
    [self makeListViewIsPullOut:sender.isSelected];
    
}
- (void)makeListViewIsPullOut:(BOOL)isOut {
    if (self.arrowBtn.isSelected != isOut) {
        self.arrowBtn.selected = isOut;
    }
    [UIView animateWithDuration:0.25 animations:^{
        
        if (isOut) {
            self.pptListView.transform = CGAffineTransformMakeTranslation(-(self.width * 0.6), 0);
        } else {
            self.pptListView.transform = CGAffineTransformIdentity;
        }
    }];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NCNBlankPPTListCellModel *model = collectionView == self.blankListView ? self.blankModels[indexPath.row] : self.pptModels[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(blankPPTListView:selectedSomeCellModel:)]) {
        [self.delegate blankPPTListView:self selectedSomeCellModel:model];
    }
    _landscapeTimeCount = 5;

//    NCNBlankPPTListCell *cell = (NCNBlankPPTListCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if (collectionView == self.blankListView) {
//        self.lastBlankSeletModel.isSelect = false;
//        NSIndexPath *lastBlankIndex = [NSIndexPath indexPathForRow:[self.blankModels indexOfObject:self.lastBlankSeletModel] inSection:0];
//        NCNBlankPPTListCell *lastCell = (NCNBlankPPTListCell *)[collectionView cellForItemAtIndexPath:lastBlankIndex];
//        [lastCell updateSelectState];
//
//        model.isSelect = true;
//        self.lastBlankSeletModel = model;
//        if ([self.delegate respondsToSelector:@selector(blankPPTListView:scrollBlankToIndexPath:)]) {
//            [self.delegate blankPPTListView:self scrollBlankToIndexPath:indexPath];
//        }
//
//    } else {
//        self.lastPPTSeletModel.isSelect = false;
//        NSIndexPath *lastPPTIndex = [NSIndexPath indexPathForRow:[self.pptModels indexOfObject:self.lastPPTSeletModel] inSection:0];
//        NCNBlankPPTListCell *lastCell = (NCNBlankPPTListCell *)[collectionView cellForItemAtIndexPath:lastPPTIndex];
//              [lastCell updateSelectState];
//        self.lastPPTSeletModel.isSelect = !self.lastPPTSeletModel.isSelect;
//        model.isSelect = true;
//        self.lastPPTSeletModel = model;
//        if ([self.delegate respondsToSelector:@selector(blankPPTListView:scrollPPTToIndexPath:)]) {
//            [self.delegate blankPPTListView:self scrollPPTToIndexPath:indexPath];
//        }
//    }
//    [cell updateSelectState];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(6, 6, 6, 6);
    
}

- (BOOL)canShow {
    
    return self.blankModels.count > 0 || self.pptModels.count > 0;
    
}

- (void)landscapeTimeFire {
    
    _landscapeTimeCount--;
    
    if (_landscapeTimeCount == 0) {
        [self.landscapeTimer invalidate];
        self.landscapeTimer = nil;
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, self.height);
        }];
    }
    
}

#pragma mark lazy

- (NSTimer *)landscapeTimer {
    
    if (!_landscapeTimer) {
        _landscapeTimer = [NSTimer  dy_scheduledWeakTimerWithTimeInterval:1 target:self selector:@selector(landscapeTimeFire) userInfo:nil repeats:1];
    }
    return _landscapeTimer;
    
}

- (UICollectionView *)blankListView {
    
    if (!_blankListView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(93, 93 / kDrawAspectRatio);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _blankListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_blankListView registerClass:NCNBlankPPTListCell.class  forCellWithReuseIdentifier:@"cell"];

        _blankListView.backgroundColor = UIColor.whiteColor;
        _blankListView.showsHorizontalScrollIndicator = false;

        
    }
    return _blankListView;
    
}

- (UICollectionView *)pptListView {
    
    if (!_pptListView) {

        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(78, 78 / kDrawAspectRatio);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _pptListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_pptListView registerClass:NCNBlankPPTListCell.class  forCellWithReuseIdentifier:@"cell"];
        _pptListView.backgroundColor = UIColor.whiteColor;
        [_pptListView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _pptListView.showsHorizontalScrollIndicator = false;
    }
    return _pptListView;
    

}

- (UIButton *)folderBtn {
    
    if (!_folderBtn) {
        _folderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_folderBtn setImage:[UIImage living_imageWithNamed:@"leftArrow@3x"] forState:UIControlStateNormal];
        [_folderBtn setImage:[UIImage living_imageWithNamed:@"rightArrow@3x"] forState:UIControlStateSelected];
        
    }
    return _folderBtn;
    
}


@end

@interface NCNBlankPPTListCell ()

@property (nonatomic, strong) NCNBlankCellView *functionView;

/*
 白板上才显示
 */
@property (nonatomic, strong) UILabel *blankLabel;




@end
@implementation NCNBlankPPTListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (void)setBlankModel:(NCNBlankPPTListCellModel *)blankModel {
   _blankModel = blankModel;
    [self.functionView showWithModel:blankModel isNeedRedraw:false];
    [self updateSelectState];
    self.blankLabel.text = [NSString stringWithFormat:@"白板%d",blankModel.pageIndex.intValue];
    
}

- (void)updateSelectState {
    
    if ([self.blankModel.useIdentifier isEqualToString:@"blank"]) {
       
        self.blankLabel.hidden = self.blankModel.isSelect ? false : true;
        
    } else if ([self.blankModel.useIdentifier isEqualToString:@"ppt"]) {
        if (self.blankModel.isSelect) {
            [self.functionView sl_setBorderWidth:1.5 borderColor:[[UIColor colorWithHexString:@"#FEA400"] CGColor] cornerR:0];
        } else {
            [self.functionView sl_setBorderWidth:0 borderColor:[[UIColor colorWithHexString:@"#FEA400"] CGColor] cornerR:0];
        }
    }
    
}

- (void)setupSubview {
    
    self.functionView = [NCNBlankCellView new];
    self.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview: self.functionView];
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];

    [self.contentView addSubview:self.blankLabel];
    [self.blankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(3);
        make.bottom.offset(-3);
        make.width.offset(45);
        make.height.offset(15);
    }];
    
    [self living_addShadowWithCornerRadius:3];
    
}

- (void)addNewDrawMessage:(NCDrawElemMSG *)msg {
    
    [self.functionView addNewDrawMSG:msg];
}

- (void)deleteAnyoneDrawWithDrawMessage:(NCDrawElemMSG *)msg {
    
    [self.functionView deleteAnyoneDrawWithDrawMessage:msg];
}

- (void)clearDrawLayerWithDrawMessage:(NCDrawElemMSG *)msg {
    [self.functionView clearDrawLayerWithDrawMessage:msg];
}
- (void)updateDrawLayerBackgroundColorWithMessage:(NCAddNewBlankElemMSG *)msg {
    
    [self.functionView updateDrawLayerBackgroundColorWithMessage:msg];
}
- (UILabel *)blankLabel {
    
    if (!_blankLabel) {
        _blankLabel = [[UILabel alloc] init];
        _blankLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        _blankLabel.textColor = UIColor.whiteColor;
        _blankLabel.layer.cornerRadius = 7.5;
        _blankLabel.layer.masksToBounds = true;
        _blankLabel.font = [UIFont systemFontOfSize:10];
        _blankLabel.textAlignment = NSTextAlignmentCenter;
        _blankLabel.text = @"白板";
        _blankLabel.hidden = true;
        
        
    }
    return _blankLabel;
    
}


@end

@interface NCNBlankPPTListCellModel ()
@property (nonatomic, strong) NSMutableArray<NCDrawElemMSG *> *draws;


@end

@implementation NCNBlankPPTListCellModel

- (instancetype)init {
    
    self = [super init];
    self.draws = @[].mutableCopy;
    
    return self;
    
}


+ (instancetype)modelFromElemMsg:(NCAddNewBlankElemMSG *)msg {
    
    NCNBlankPPTListCellModel *model = [NCNBlankPPTListCellModel new];
    model.useIdentifier = msg.image.length > 1 ? @"ppt" : @"blank";
    model.blankColor = [NCCustomeElemMSG getColorFromColorString:msg.Color];
    model.pptImageURL = msg.image;
    model.pageIndex = msg.pageIndex;
    model.draws = @[].mutableCopy;
    return model;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
}
@end
