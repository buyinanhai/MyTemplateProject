//
//  NCNBlankPPTListView.h
//  LFLiveKit
//
//  Created by 汪宁 on 2020/4/30.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

/**
 0 : 白板  1 ： ppt
 */
typedef int NCNBlankType;
@class NCNBlankPPTListView;
@class NCNBlankPPTListCellModel;
@protocol NCNBlankPPTListViewDelegate <NSObject>


@optional
- (void)blankPPTListView:(NCNBlankPPTListView *)view scrollBlankToIndexPath:(NSIndexPath *)path;

- (void)blankPPTListView:(NCNBlankPPTListView *)view scrollPPTToIndexPath:(NSIndexPath *)path;

- (void)blankPPTListView:(NCNBlankPPTListView *)view selectedSomeCellModel:(NCNBlankPPTListCellModel *)model;
@end


@class NCAddNewBlankElemMSG;
@class NCDrawElemMSG;
@interface NCNBlankPPTListCellModel : NSObject
@property (nonatomic, copy) UIColor *blankColor;
@property (nonatomic, copy) NSString *pptImageURL;
@property (nonatomic, copy) NSString *pageIndex;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) NSString *useIdentifier;


/**
 更新选中的白板或者ppt
 */

@property (nonatomic, copy)void(^ _Nullable newDrawMessageCallback)(NCDrawElemMSG *msg);
@property (nonatomic, copy) void(^ _Nullable deleteDrawMessageCallback)(NCDrawElemMSG *msg);
@property (nonatomic, copy) void(^ _Nullable clearDrawLayerCallback)(NCDrawElemMSG *msg);
@property (nonatomic, copy) void(^ _Nullable updateDrawLayerBackgroundColorCallback)(NCAddNewBlankElemMSG *msg);


+ (instancetype)modelFromElemMsg:(NCAddNewBlankElemMSG *)msg;

- (NSMutableArray<NCDrawElemMSG *> *)draws;
@end

@class NCAddNewBlankElemMSG;
@interface NCNBlankPPTListView : UIView

/**
 当前显示的课件的id
 */
@property (nonatomic, copy) NSNumber *fileId;

@property (nonatomic, weak) id<NCNBlankPPTListViewDelegate> delegate;

- (void)addBlanks:(NSArray<NCNBlankPPTListCellModel *> *)blanks;
- (void)addPPTS:(NSArray<NCNBlankPPTListCellModel *> *)ppts;
- (void)showPPTs:(NSArray<NCNBlankPPTListCellModel *> *)ppts;

- (void)enterLandscape:(BOOL)isLandscape;

- (void)showSelfViewOnLandscape;
- (void)dismisswSelfViewOnLandscape;


- (BOOL)canShow;

/**
 拉出或收回pptListView
 */
- (void)makeListViewIsPullOut:(BOOL)isOut;

/**
 翻到指定页面
    type 0 : 白板  1 ： ppt
 */
- (NCNBlankPPTListCellModel *)selectBlankOrPPTWithType:(NCNBlankType)type pageIndex:(NSInteger)pageIndex;

/**
 白板画图操作

 */

- (void)addNewDrawMSG:(NCDrawElemMSG *)msg;
- (void)deleteAnyoneDrawWithDrawMessage:(NCDrawElemMSG *)msg;
- (void)clearDrawLayerWithDrawMessage:(NCDrawElemMSG *)msg;
- (void)updateDrawLayerBackgroundColorWithMessage:(NCAddNewBlankElemMSG *)msg;

- (void)closePPT;

- (void)clear;
@end

NS_ASSUME_NONNULL_END
