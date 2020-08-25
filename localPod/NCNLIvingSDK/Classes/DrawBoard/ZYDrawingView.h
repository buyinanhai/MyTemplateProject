//
//  ZYDrawingView.h
//  ZYDrawBoard
//
//  Created by 王志盼 on 2018/5/31.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYDrawingLayer.h"
#import "ZYTextLayer.h"
#import "ZYDrawTextField.h"
#import "UIColor+Hex.h"
#import "ZYLaserImgView.h"


typedef NS_ENUM(NSInteger, ZYDrawingType) {
    ZYDrawingTypeSelected,      //选择区域
    ZYDrawingTypeDrawing,       //画板
    ZYDrawingTypeTextfield,     //添加文本
    ZYDrawingTypeLaser,         //激光笔
    ZYDrawingTypeMathGraph,  //画直线
};

@class ZYDrawingView;
@class NCDrawElemMSG;

@protocol ZYDrawingViewDelegate <NSObject>
- (void)drawingView:(ZYDrawingView *)drawingView drawingBeginLId:(NSString *)lId cId:(NSString *)cId point:(CGPoint)point weight:(float)weight color:(uint32_t)color;
- (void)drawingView:(ZYDrawingView *)drawingView drawingMoveLId:(NSString *)lId cId:(NSString *)cId point:(CGPoint)point;
- (void)drawingView:(ZYDrawingView *)drawingView drawingEndLId:(NSString *)lId cId:(NSString *)cId point:(CGPoint)point;
- (void)drawingView:(ZYDrawingView *)drawingView moveLId:(NSString *)lId cId:(NSString *)cId point:(CGPoint)point;
- (void)drawingView:(ZYDrawingView *)drawingView deleteLId:(NSString *)lId cId:(NSString *)cId;
- (void)drawingView:(ZYDrawingView *)drawingView laserBegin:(NSString *)uId cId:(NSString *)cId point:(CGPoint)point;
- (void)drawingView:(ZYDrawingView *)drawingView laserMove:(NSString *)uId cId:(NSString *)cId point:(CGPoint)point;
- (void)drawingView:(ZYDrawingView *)drawingView laserEnd:(NSString *)uId cId:(NSString *)cId point:(CGPoint)point;

//文本框内容发送
- (void)drawingView:(ZYDrawingView *)drawingView textViewContentPass:(NSString *)content lid:(NSString *)lid cId:(NSString *)cId point:(CGPoint)point weight:(float)weight color:(uint32_t)color;
//文本框内容删除
- (void)drawingView:(ZYDrawingView *)drawingView deleteTextLId:(NSString *)lId cId:(NSString *)cId;

//主动移动文本
- (void)drawingView:(ZYDrawingView *)drawingView moveTextLId:(NSString *)lId cId:(NSString *)cId point:(CGPoint)point;

//- (void)drawingView:(ZYDrawingView *)drawingView drawingEllipseLId:(NSString *)lId cId:(NSString *)cId box:(CGRect)rect weight:(float)weight color:(uint32_t)color brushColor:(uint32_t)brushColor;

//- (void)drawingView:(ZYDrawingView *)drawingView drawingRectangleLId:(NSString *)lId cId:(NSString *)cId box:(CGRect)rect weight:(float)weight color:(uint32_t)color brushColor:(uint32_t)brushColor;
- (void)drawingView:(ZYDrawingView *)drawingView drawingBeginGraphShapeLId:(NSString *)lId cId:(NSString *)cId box:(CGRect)rect weight:(float)weight color:(uint32_t)color brushColor:(uint32_t)brushColor graphType:(NSInteger)type;
- (void)drawingView:(ZYDrawingView *)drawingView drawingMoveGraphShapeLId:(NSString *)lId cId:(NSString *)cId box:(CGRect)rect weight:(float)weight color:(uint32_t)color brushColor:(uint32_t)brushColor graphType:(NSInteger)type;
- (void)drawingView:(ZYDrawingView *)drawingView drawingEndGraphShapeLId:(NSString *)lId cId:(NSString *)cId box:(CGRect)rect weight:(float)weight color:(uint32_t)color brushColor:(uint32_t)brushColor graphType:(NSInteger)type;
- (void)drawingView:(ZYDrawingView *)drawingView MoveGraphShapeLId:(NSString *)lId cId:(NSString *)cId point:(CGPoint)point graphType:(NSInteger)type;
- (void)drawingView:(ZYDrawingView *)drawingView deleteGraphShapeLId:(NSString *)lId cId:(NSString *)cId  graphType:(NSInteger)type;

@end

@interface ZYDrawingView : UIView
@property (nonatomic, strong) ZYDrawingLayer *drawingLayer;//当前创建的path
@property (nonatomic, strong) ZYDrawingLayer *selectedLayer;//当前选中的path
@property (nonatomic, strong) ZYTextLayer *selectedTextLayer;//当前选中的文本框
@property (nonatomic, strong) NSMutableArray *layerArray;//当前创建的path集合
@property (nonatomic, strong) NSMutableArray *textArr;//当前所创建的textLayer;
//@property (nonatomic, strong) UIImageView *laserPoint;//我创建的激光笔
@property (nonatomic, strong) ZYLaserImgView *laserPoint;//我创建的激光笔
@property (nonatomic, strong) ZYDrawingLayer *straightLineLayer;
@property (nonatomic, strong) NSMutableDictionary *laserDic;//当前创建的激光笔集合
@property (nonatomic, copy) NSString *cId;

@property (nonatomic, assign) CGFloat pointpXRatio;    //比例
/**
 被区域选中的所有layer   ---- 只针对cashapelayer封装的zydrawinglayer
 */
@property (nonatomic, strong) NSMutableArray *areaLayerArr;

/**
 被区域选中的所有textlayer   ---- 只针对catextlayer封装的 ZYTextLayer
 */

@property (nonatomic, strong) NSMutableArray *areaTextLayerArr;

@property (nonatomic, weak) id<ZYDrawingViewDelegate>delegate;

@property (nonatomic, copy) void (^drawingLayerSelectedBlock)(BOOL isSelected);


@property(nonatomic, assign) ZYDrawingType type;

/**文本框**/
@property (nonatomic, strong) ZYDrawTextField *txField;

/*defaulColor*/
@property (nonatomic, strong) UIColor *defaultColor;

@property (nonatomic, copy) NSString *hexStr; //画笔颜色hex
@property (nonatomic, assign) float penWeight;//画笔笔宽度

@property (nonatomic, copy) NSString *textHexStr; //文本颜色hex
@property (nonatomic, assign) float textPenWeight;//文本字体宽度

@property (nonatomic, assign) NSInteger graphType;//数学图形类型

@property (nonatomic, weak) NCDrawElemMSG *currentHandleMsg;


- (void)revoke;
- (void)clearDrawingLayer;
-(CGPoint) getOrcPoint:(CGPoint)ratioPoint;

- (instancetype)initWithDefaultPenColor:(UIColor *)defaultColor;

@end


@interface ZYPointModel : NSObject;
@property (nonatomic, copy) NSString *lid; //记录id
@property (nonatomic, assign) CGPoint previousPoint;//记录点
@property (nonatomic, assign) CGPoint currentPoint;//记录当前点
@end
