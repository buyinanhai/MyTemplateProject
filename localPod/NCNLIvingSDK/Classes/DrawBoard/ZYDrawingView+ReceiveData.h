//
//  ZYDrawingView+ReceiveData.h
//  YQD_Student_iPad
//
//  Created by 王志盼 on 2018/6/22.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYDrawingView.h"
//#import "YQDRoomSocket.h"
#import "ZYTextLayer.h"

@class NCDrawElemMSG;
@interface ZYDrawingView (ReceiveData)



- (void)receiveIMElemMsg:(NCDrawElemMSG *)elemMsg layerSize:(CGSize)size;

//- (void)receiveMoveMsg:(CanvasElementMoved *)msg;
- (void)receiveDeletedMsg:(NCDrawElemMSG *)msg;
//- (void)receivePenDownMsg:(CanvasPenDown *)msg;
//- (void)receivePenDrawMsg:(CanvasPenDraw *)msg;
//- (void)receivePenDoneMsg:(CanvasPenDone *)msg;
//- (void)receivePenMoveMsg:(CanvasPenMoved *)msg;
//- (void)receivePenDeleteMsg:(CanvasPenDeleted *)msg;
//- (void)receiveTextMsg:(CanvasTextDone *)msg;
//- (void)receiveDeleteTextMsg:(CanvasTextDeleted *)msg;
//- (void)receiveMoveTextMsg:(CanvasTextMoved *)msg;
//- (void)receivePrintTrailMsg:(TrailHistory*) msg;
//- (void)receivePrintTextMsg:(TextHistory*) msg;
//- (void)receiveLaserBeginMsg:(CanvasLaserBegin*)msg;
//- (void)receiveLaserMoveMsg:(CanvasLaserMove*)msg;
//- (void)receiveLaserEndMsg:(CanvasLaserEnd*)msg;
//
//- (void)receiveEllipseDownMsg:(CanvasEllipse *)msg;
//- (void)receiveEllipseDrawMsg:(CanvasEllipse *)msg;
//- (void)receiveEllipseDoneMsg:(CanvasEllipse *)msg;
//- (void)receiveEllipseDeletedMsg:(CanvasEllipse *)msg;
//- (void)receiveEllipseMoveMsg:(CanvasEllipse *)msg;
//- (void)receiveRectDownMsg:(CanvasRect *)msg;
//- (void)receiveRectDrawMsg:(CanvasRect *)msg;
//- (void)receiveRectDoneMsg:(CanvasRect *)msg;
//- (void)receiveRectDeletedMsg:(CanvasRect *)msg;
//- (void)receiveRectMoveMsg:(CanvasRect *)msg;
@end
