//
//  NCNBlankView.h
//  XYClassRoom
//
//  Created by 尹彦博 on 2020/4/23.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCLiveView.h"
NS_ASSUME_NONNULL_BEGIN

@class NCNBlankView;
@class NCNBlankPPTListCellModel;
@class NCDrawElemMSG;
@class NCAddNewBlankElemMSG;
@class NCNBlankView;

@protocol NCNBlankViewDelegate <NSObject>

- (void)blankView:(NCNBlankView *)view onButtonClicked:(BOOL)isSelected;

@end

/**
 直播白板View
 */
@interface NCNBlankView : NCLiveView

@property (nonatomic, weak) id<NCNBlankViewDelegate> delegate;

- (void)updateState;

/**
 显示白板和ppt
 */
- (void)showBlanksOrPPTs:(NSArray<NCNBlankPPTListCellModel *> *)datas;

- (void)scrollToIndexPath:(NSIndexPath *)indexPath;


- (void)showContentWithCellModel:(NCNBlankPPTListCellModel *)model;

- (void)classEnded;




@end

@interface NCNBlankCellView : UIView

-(void)setImageUrl:(NSString *)imageUrl;
/** 设置图片大小 */
- (void)setImageSize:(CGSize)sz;
/** 图片缩放复原 */
- (void)resetImageScale;

- (void)showWithModel:(NCNBlankPPTListCellModel *)model isNeedRedraw:(BOOL)isNeedReDraw;

- (void)addNewDrawMSG:(NCDrawElemMSG *)msg;
- (void)deleteAnyoneDrawWithDrawMessage:(NCDrawElemMSG *)msg;
- (void)clearDrawLayerWithDrawMessage:(NCDrawElemMSG *)msg;
- (void)updateDrawLayerBackgroundColorWithMessage:(NCAddNewBlankElemMSG *)msg;


- (void)reloadAllDraws;

- (NCNBlankPPTListCellModel *)model;
@end



NS_ASSUME_NONNULL_END
