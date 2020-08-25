//
//  ZYDrawingView+ReceiveData.m
//  YQD_Student_iPad
//
//  Created by 王志盼 on 2018/6/22.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYDrawingView+ReceiveData.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>
#import "NCDrawElemMSG.h"


const void *ZYTextArrKey = &ZYTextArrKey;

@implementation ZYDrawingView (ReceiveData)



- (void)receiveIMElemMsg:(NCDrawElemMSG *)elemMsg layerSize:(CGSize)size{
    
    self.currentHandleMsg = elemMsg;
    
    switch (elemMsg.itemType.integerValue) {
            
        case 0:
            // 0    画笔
            [self receivePrintTrailMsg:elemMsg layerSize:size];
            break;
        case 1:
            // 1    直线
            [self receivePrintTrailMsg:elemMsg layerSize:size];
            break;
        case 2:
            // 2    单向箭头
            [self receiveArrowLineMsg:elemMsg layerSize:size];
            break;
        case 3:
            // 3    矩形
            [self receivePrintTrailMsg:elemMsg layerSize:size];

            break;
        case 4:
            // 4    圆形
            [self receiveEllipseDownMsg:elemMsg];
            break;
        case 5:
            // 5    五边形
            [self receivePrintTrailMsg:elemMsg layerSize:size];
            
            break;
        case 6:
            // 6    梯形
            [self receivePrintTrailMsg:elemMsg layerSize:size];

            break;
        case 7:
            // 7    菱形
            [self receivePrintTrailMsg:elemMsg layerSize:size];

            break;
        case 8:
            // 8    三角形
            [self receivePrintTrailMsg:elemMsg layerSize:size];

            break;
        case 9:
            // 9    平行四边形
            [self receivePrintTrailMsg:elemMsg layerSize:size];

            break;
        case 10:
            // 10    文本框
            [self receivePrintTextMsg:elemMsg];
            break;
            
    }
    
}

-(void)receivePrintTrailMsg:(NCDrawElemMSG *)msg layerSize:(CGSize)size
{
    //历史消息的批注数据
    
    if(msg.pointList.count <= 1)
    {
        return;
    }
    UIColor *penColor = [NCCustomeElemMSG getColorFromColorString:msg.penColor];
    uint32_t chooseColor = [UIColor transferHexToUIntWithHexString:msg.penColor1];
    CGFloat penWidth = msg.penWidth.floatValue * self.pointpXRatio;
    self.drawingLayer = [self findLayerWithId:msg.itemId];
    if (self.drawingLayer == nil) {
        CGFloat x = [msg.pointList[0][0] floatValue];
        CGFloat y = [msg.pointList[0][1] floatValue];
        CGPoint startPoint = [self getOrcPoint:CGPointMake(x,y)];
        self.drawingLayer = [ZYDrawingLayer createLayerWithStartPoint:startPoint penColor:penColor chooseColor:chooseColor chooseWeight:penWidth layerSize:size];//创建相应的layer
        self.drawingLayer.lId = msg.itemId;
        [self.layer addSublayer:self.drawingLayer];
        [self.layerArray addObject:self.drawingLayer];
    }
    NSInteger maxCount = [msg.pointList count];
    for(int i=1;i<maxCount;i++)
    {
        
        CGFloat x = [msg.pointList[i][0] floatValue];
        CGFloat y = [msg.pointList[i][1] floatValue];
    
        [self.drawingLayer movePathWithEndPoint:[self getOrcPoint:CGPointMake(x, y)]];//绘制新创建的shape
    }

//    if([msg hasX] && [msg hasY])
//    {
//        CGPoint curPoint = CGPointMake(msg.itemX.floatValue * self.pointpXRatio, msg.itemY.floatValue * self.pointpXRatio);
//        curPoint  = [self getOrcPoint:curPoint];
//        [self.drawingLayer moveGrafiitiPathPreviousPoint:self.drawingLayer.containRect.origin currentPoint:curPoint];//平移涂鸦shape
//    }
}

-(void)receivePrintTextMsg:(NCDrawElemMSG *)msg
{
    if (self.textArr == nil) self.textArr = [[NSMutableArray alloc] init];

    ZYTextLayer *curFiled = [self findFiledWithId:msg.itemId];

    CGRect frame = CGRectZero;

//    float fontWeight = msg.weight*27 + 18.0;
    frame = [msg.itemText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25]} context:nil];

    frame.size.height = frame.size.height + 80;

    //x,y
    frame.origin.x = [msg.pointList[0][0] floatValue] * self.pointpXRatio;
    frame.origin.y = [msg.pointList[0][1] floatValue] * self.pointpXRatio;
    frame.size.width = ([msg.pointList[1][0] floatValue] - [msg.pointList[0][0] floatValue]) * self.pointpXRatio;

    if (curFiled == nil)
    {
        uint32_t fontColor = [UIColor transferHexToUIntWithHexString:msg.penColor1];
        CGFloat fontSize = msg.pixelSize.floatValue * self.pointpXRatio;
        curFiled = [[ZYTextLayer alloc] initWithFontColor:fontColor weight:fontSize];
        if (msg.fontBold.boolValue) {
            curFiled.font = (__bridge CFTypeRef _Nullable)([UIFont boldSystemFontOfSize:fontSize]);
        } else {
            curFiled.font = CFBridgingRetain([UIFont systemFontOfSize:fontSize]);
        }

        curFiled.lId = msg.itemId;
        curFiled.zPosition = msg.posZ.floatValue;
        [self.textArr addObject:curFiled];
        [self.layer addSublayer:curFiled];
    }
    curFiled.frame = frame;
    curFiled.string = msg.itemText;
}

#pragma mark 单向箭头
- (void)receiveArrowLineMsg:(NCDrawElemMSG *)msg layerSize:(CGSize)size {
    
    if(msg.pointList.count <= 1)
    {
        return;
    }
//    UIColor *penColor = [NCCustomeElemMSG getColorFromColorString:msg.penColor];
    uint32_t chooseColor = [UIColor transferHexToUIntWithHexString:msg.penColor1];
    CGFloat penWidth = msg.penWidth.floatValue * self.pointpXRatio;
    self.drawingLayer = [self findLayerWithId:msg.itemId];
    if (self.drawingLayer == nil) {
        CGFloat x = [msg.pointList[0][0] floatValue];
        CGFloat y = [msg.pointList[0][1] floatValue];
        CGPoint startPoint = [self getOrcPoint:CGPointMake(x,y)];
        self.drawingLayer = [ZYDrawingLayer createMathGraphWithStartPoint:startPoint chooseColor:chooseColor fillColor:0 chooseWeight:penWidth type:GraphTypeStrightLineArrow];//创建相应的layer
        self.drawingLayer.pointpXRatio = self.pointpXRatio;
        self.drawingLayer.lId = msg.itemId;
        [self.layer addSublayer:self.drawingLayer];
        [self.layerArray addObject:self.drawingLayer];
    }
    CGFloat x = [msg.pointList[1][0] floatValue];
    CGFloat y = [msg.pointList[1][1] floatValue];
    CGPoint endPoint = [self getOrcPoint:CGPointMake(x, y)];
    [self.drawingLayer moveMathGraphWithCurrentPoint:endPoint];
    
}




#pragma mark 对layer的操作
- (void)receiveMoveMsg:(NCDrawElemMSG *)msg
{
    ZYDrawingLayer *moveLayer = [self findLayerWithId:msg.itemId];

    if (moveLayer)
    {

        CGPoint curPoint = CGPointMake(msg.itemX.floatValue, msg.itemY.floatValue);
        curPoint  = [self getOrcPoint:curPoint];
        [moveLayer moveGrafiitiPathPreviousPoint:moveLayer.containRect.origin currentPoint:curPoint];//平移涂鸦shape
    }
}
- (void)receiveDeletedMsg:(NCDrawElemMSG *)msg
{
    ZYDrawingLayer *delLayer = [self findLayerWithId:msg.itemId];

    if (delLayer)
    {
        [self deleteLayer:delLayer];
    }
}
//- (void)receivePenDownMsg:(NCDrawElemMSG *)msg
//{
//    ZYDrawingLayer* layer = [self findLayerWithId:msg.itemId];
//    if(!layer)
//    {
//        UIColor *penColor = [NCCustomeElemMSG getColorFromColorString:msg.penColor];
//        uint32_t chooseColor = [UIColor transferHexToUIntWithHexString:msg.penColor1];
//
//        layer = [ZYDrawingLayer createLayerWithStartPoint:[self getOrcPoint: CGPointMake(msg.itemX.floatValue,msg.itemY.floatValue)] penColor:penColor chooseColor:chooseColor chooseWeight:msg.penWidth.floatValue];//创建相应的layer
//        layer.lId = msg.itemId;
//        [self.layer addSublayer:layer];
//        [self.layerArray addObject:layer];
//    }
//    layer.zPosition = msg.posZ.floatValue;
//}

- (void)receivePenDrawMsg:(NCDrawElemMSG *)msg
{
    ZYDrawingLayer* layer = [self findLayerWithId:msg.itemId];
    if (layer) {
        for(int i=0;i<[msg.pointList count];i++)
        {
            CGFloat x = [msg.pointList[i][0] floatValue];
            CGFloat y = [msg.pointList[i][1] floatValue];
            [layer movePathWithEndPoint:[self getOrcPoint:CGPointMake(x, y)]];//绘制新创建的shape
        }
    }
}
- (void)receivePenDoneMsg:(NCDrawElemMSG *)msg
{
    ZYDrawingLayer* layer = [self findLayerWithId:msg.itemId];
    if (layer) {
        for(int i=0;i<[msg.pointList count];i++)
        {
            CGFloat x = [msg.pointList[i][0] floatValue];
            CGFloat y = [msg.pointList[i][1] floatValue];
            [layer movePathWithEndPoint:[self getOrcPoint:CGPointMake(x, y)]];//绘制新创建的shape
        }
    }
}

- (void)receivePenMoveMsg:(NCDrawElemMSG *)msg
{
    ZYDrawingLayer *moveLayer = [self findLayerWithId:msg.itemId];

    if (moveLayer)
    {

        CGPoint curPoint = CGPointMake(msg.itemX.floatValue, msg.itemY.floatValue);
        curPoint  = [self getOrcPoint:curPoint];
        [moveLayer moveGrafiitiPathPreviousPoint:moveLayer.containRect.origin currentPoint:curPoint];//平移涂鸦shape
    }
}
- (void)receivePenDeleteMsg:(NCDrawElemMSG *)msg
{
    ZYDrawingLayer *delLayer = [self findLayerWithId:msg.itemId];

    if (delLayer)
    {
        [self deleteLayer:delLayer];
    }
}

#pragma mark 对文本框的操作
- (void)receiveTextMsg:(NCDrawElemMSG *)msg
{
    if (self.textArr == nil) self.textArr = [[NSMutableArray alloc] init];
    ZYTextLayer *curFiled = [self findFiledWithId:msg.itemId];
    uint32_t chooseColor = [UIColor transferHexToUIntWithHexString:msg.penColor1];
    if (curFiled == nil)
    {
        
        curFiled = [[ZYTextLayer alloc] initWithFontColor:chooseColor  weight:msg.penWidth.floatValue];
        curFiled.lId = msg.itemId;
        curFiled.zPosition = msg.posZ.floatValue;
        [self.textArr addObject:curFiled];
        [self.layer addSublayer:curFiled];
    }
    CGRect frame = CGRectZero;
//    float fontWeight = msg.weight*27 + 18.0;
    frame = [msg.itemText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25]} context:nil];
    frame.size.height = frame.size.height + 80;
    frame.size.width = 1500;
    frame.origin.x = [msg.pointList[0][0] floatValue] * self.pointpXRatio;
    frame.origin.y = [msg.pointList[0][1] floatValue] * self.pointpXRatio;
    curFiled.frame = frame;
    curFiled.string = msg.itemText;
}

- (void)receiveDeleteTextMsg:(NCDrawElemMSG *)msg
{
    ZYTextLayer *curFiled = [self findFiledWithId:msg.itemId];
    if (curFiled != nil)
    {
        [self.textArr removeObject:curFiled];
//        [curFiled removeFromSuperview];

        [curFiled removeFromSuperlayer];
    }
}

- (void)receiveMoveTextMsg:(NCDrawElemMSG *)msg
{
    ZYTextLayer *curFiled = [self findFiledWithId:msg.itemId];
    if (curFiled != nil)
    {
        CGRect frame = curFiled.frame;

        frame.origin.x = msg.itemX.floatValue * self.pointpXRatio;
        frame.origin.y = msg.itemY.floatValue * self.pointpXRatio;

        curFiled.frame = frame;

    }
}

#pragma mark 激光笔

-(void)receiveLaserBeginMsg:(NCDrawElemMSG *)msg
{
  


    if ([NCDrawManager ShareInstance].laserImage) {

        [[NCDrawManager ShareInstance].laserImage removeFromSuperview];
        [self addSubview:[NCDrawManager ShareInstance].laserImage];

        [NCDrawManager ShareInstance].laserImage.center = CGPointMake(msg.itemX.floatValue * self.pointpXRatio, msg.itemY.floatValue * self.pointpXRatio);

        [NCDrawManager ShareInstance].laserImage.hidden = NO;
    }
    else if(![NCDrawManager ShareInstance].laserImage)
    {
        UIImage *laserImage = [UIImage imageNamed:@"laser_point"];
        UIImageView* customLaserPoint = [[UIImageView alloc] initWithImage:laserImage];
        [customLaserPoint setFrame:CGRectMake(0, 0, 24, 24)];
        customLaserPoint.layer.anchorPoint = CGPointMake(0.5, 0.5);

        [self addSubview:customLaserPoint];
        customLaserPoint.center = CGPointMake(msg.itemX.floatValue * self.pointpXRatio, msg.itemY.floatValue * self.pointpXRatio);
        [NCDrawManager ShareInstance].laserImage = customLaserPoint;
    }

}

-(void)receiveLaserMoveMsg:(NCDrawElemMSG *)msg

{

    if(![NCDrawManager ShareInstance].laserImage)
    {
        UIImage *laserImage = [UIImage living_imageWithNamed:@"laser_point"];
        UIImageView* customLaserPoint = [[UIImageView alloc] initWithImage:laserImage];
        [customLaserPoint setFrame:CGRectMake(0, 0, 24, 24)];
        customLaserPoint.layer.anchorPoint = CGPointMake(0.5, 0.5);

        [NCDrawManager ShareInstance].laserImage = customLaserPoint;
        [self addSubview:[NCDrawManager ShareInstance].laserImage];
        customLaserPoint.center = CGPointMake(msg.itemX.floatValue * self.pointpXRatio, msg.itemY.floatValue * self.pointpXRatio);
    }
    else{
        [NCDrawManager ShareInstance].laserImage.hidden = NO;
        [NCDrawManager ShareInstance].laserImage.center = CGPointMake(msg.itemX.floatValue * self.pointpXRatio, msg.itemY.floatValue *self.pointpXRatio);
    }
}

-(void)receiveLaserEndMsg:(NCDrawElemMSG *)msg
{
    //    if([self.laserDic objectForKey:msg.uid])
    //    {
    //        UIImageView *customLaserPoint = [self.laserDic objectForKey:msg.uid];
    //        [customLaserPoint removeFromSuperview];
    //        [self.laserDic removeObjectForKey:msg.uid];
    //    }
    [NCDrawManager ShareInstance].laserImage.hidden = YES;
}

#pragma mark 椭圆

-(void)receiveEllipseDownMsg:(NCDrawElemMSG *)msg
{
    ZYDrawingLayer* layer = [self findLayerWithId:msg.itemId];
    if (!layer)
    {
        uint32_t fillColor = [UIColor transferHexToUIntWithHexString:msg.brushColor1];
        uint32_t chooseColor = [UIColor transferHexToUIntWithHexString:msg.penColor1];
        CGFloat x = [msg.pointList[0][0] floatValue];
        CGFloat y = [msg.pointList[0][1] floatValue];
        CGPoint startPoint = [self getOrcPoint:CGPointMake(x, y)];
        CGFloat penWidth = msg.penWidth.floatValue * self.pointpXRatio;

        layer = [ZYDrawingLayer createMathGraphWithStartPoint:startPoint chooseColor:chooseColor fillColor:fillColor chooseWeight:penWidth type:GraphTypeEllipse];
        layer.lId = msg.itemId;
        [self.layer addSublayer:layer];
        [self.layerArray addObject:layer];
    }
    CGFloat x = [msg.pointList[1][0] floatValue];
    CGFloat y = [msg.pointList[1][1] floatValue];
    CGPoint endPoint = [self getOrcPoint: CGPointMake(x,y)];
    [layer moveMathGraphWithCurrentPoint:endPoint];
}
//
//-(void)receiveEllipseDrawMsg:(NCDrawElemMSG *)msg
//{
//    [self receiveEllipseMoveMsg: msg];
//    ZYDrawingLayer* layer = [self findLayerWithId:msg.lid];
//    if (layer)
//    {
//        CGPoint endPoint = [self getOrcPoint: CGPointMake(msg.x+msg.w,msg.y+msg.h)];
//        [layer moveMathGraphWithCurrentPoint:endPoint];
//    }
//}
//
//- (void)receiveEllipseDoneMsg:(NCDrawElemMSG *)msg
//{
//    ZYDrawingLayer* layer = [self findLayerWithId:msg.lid];
//    if (!layer)
//    {
//        uint32_t fillColor = msg.hasBrushColor?msg.brushColor:-1;
//        layer = [ZYDrawingLayer createMathGraphWithStartPoint:[self getOrcPoint: CGPointMake(msg.x,msg.y)] chooseColor:msg.penColor  fillColor:fillColor chooseWeight:msg.weight type:GraphTypeEllipse];
//        layer.lId = msg.lid;
//        layer.zPosition = msg.z;
//        [self.layer addSublayer:layer];
//        [self.layerArray addObject:layer];
//    }
//    CGPoint endPoint = [self getOrcPoint: CGPointMake(msg.x+msg.w,msg.y+msg.h)];
//    [layer finishMathGraphWithEndPoint:endPoint];
//}
//
//-(void)receiveEllipseDeletedMsg:(NCDrawElemMSG *)msg
//{
//    ZYDrawingLayer *delLayer = [self findLayerWithId:msg.lid];
//
//    if (delLayer)
//    {
//        [self deleteLayer:delLayer];
//    }
//}
//
//-(void)receiveEllipseMoveMsg:(NCDrawElemMSG *)msg
//{
//    ZYDrawingLayer *moveLayer = [self findLayerWithId:msg.lid];
//
//    if (moveLayer)
//    {
//        CGPoint curPoint = CGPointMake(msg.x, msg.y);
//        curPoint  = [self getOrcPoint:curPoint];
//        [moveLayer moveGrafiitiPathPreviousPoint:moveLayer.containRect.origin currentPoint:curPoint];//平移涂鸦shape
//    }
//}
//
//
//#pragma mark 画矩形
//-(void)receiveRectDownMsg:(NCDrawElemMSG *)msg
//{
//        NSLog(@"%@",msg);
//    ZYDrawingLayer* layer = [self findLayerWithId:msg.lid];
//    if (!layer)
//    {
//        uint32_t fillColor = msg.hasBrushColor?msg.brushColor:-1;
//        layer = [ZYDrawingLayer createMathGraphWithStartPoint:[self getOrcPoint: CGPointMake(msg.x,msg.y)] chooseColor:msg.penColor  fillColor:fillColor chooseWeight:msg.weight type:GraphTypeRectangle];
//        layer.lId = msg.lid;
//        [self.layer addSublayer:layer];
//        [self.layerArray addObject:layer];
//    }
//    layer.zPosition = msg.z;
//    CGPoint endPoint = [self getOrcPoint: CGPointMake(msg.x+msg.w,msg.y+msg.h)];
//    [layer moveMathGraphWithCurrentPoint:endPoint];
//}
//
//-(void)receiveRectDoneMsg:(NCDrawElemMSG *)msg
//{
//    ZYDrawingLayer* layer = [self findLayerWithId:msg.lid];
//    if (!layer)
//    {
//        uint32_t fillColor = msg.hasBrushColor?msg.brushColor:-1;
//        layer = [ZYDrawingLayer createMathGraphWithStartPoint:[self getOrcPoint: CGPointMake(msg.x,msg.y)] chooseColor:msg.penColor  fillColor:fillColor chooseWeight:msg.weight type:GraphTypeRectangle];
//        layer.lId = msg.lid;
//        layer.zPosition = msg.z;
//        [self.layer addSublayer:layer];
//        [self.layerArray addObject:layer];
//    }
//    CGPoint endPoint = [self getOrcPoint: CGPointMake(msg.x+msg.w,msg.y+msg.h)];
//    [layer finishMathGraphWithEndPoint:endPoint];
//}
//
//-(void)receiveRectDrawMsg:(NCDrawElemMSG *)msg
//{
//    [self receiveRectMoveMsg: msg];
//    ZYDrawingLayer* layer = [self findLayerWithId:msg.lid];
//    if (layer)
//    {
//        CGPoint endPoint = [self getOrcPoint: CGPointMake(msg.x+msg.w,msg.y+msg.h)];
//        [layer moveMathGraphWithCurrentPoint:endPoint];
//    }
//}
//
//-(void)receiveRectDeletedMsg:(NCDrawElemMSG *)msg
//{
//    ZYDrawingLayer *delLayer = [self findLayerWithId:msg.lid];
//
//    if (delLayer)
//    {
//        [self deleteLayer:delLayer];
//    }
//}
//
//-(void)receiveRectMoveMsg:(NCDrawElemMSG *)msg
//{
//    ZYDrawingLayer *moveLayer = [self findLayerWithId:msg.lid];
//
//    if (moveLayer)
//    {
//
//        CGPoint curPoint = CGPointMake(msg.x, msg.y);
//        curPoint  = [self getOrcPoint:curPoint];
//        [moveLayer moveGrafiitiPathPreviousPoint:moveLayer.containRect.origin currentPoint:curPoint];//平移涂鸦shape
//    }
//}








- (uint32_t)transfromElemMsgStringColorToInt:(NSString *)msgColor {
    
    UIColor *color = [NCCustomeElemMSG getColorFromColorString:msgColor];
    
    uint32_t intColor = [color transferHexToInt];
    
    return intColor;
}

#pragma mark - private
- (ZYDrawingLayer *)findLayerWithId:(NSString *)lId
{
    ZYDrawingLayer *layer = nil;
    for (ZYDrawingLayer *_layer in self.layerArray)
    {
        if ([_layer.lId isEqualToString:lId])
        {
            layer = _layer;
            break;
        }
    }
    if (self.currentHandleMsg.isNewMsg && layer) {
        [layer removeFromSuperlayer];
        [self.layerArray removeObject:layer];
        layer = nil;
    }
    
    return layer;
}

- (ZYTextLayer *)findFiledWithId:(NSString *)lId
{
    ZYTextLayer *textLayer = nil;
    for (int i = 0; i < self.textArr.count; i++)
    {
        ZYTextLayer *filed = self.textArr[i];
        if ([filed.lId isEqualToString:lId])
        {
            textLayer = filed;
            break;
        }
    }
    if (self.currentHandleMsg.isNewMsg && textLayer) {
        [textLayer removeFromSuperlayer];
        [self.textArr removeObject:textLayer];
        textLayer = nil;
    }
    return textLayer;
}

- (void)deleteLayer:(ZYDrawingLayer *)layer
{
    [layer removeFromSuperlayer];
    [self.layerArray removeObject:layer];
    [self.areaLayerArr removeObject:layer];

    if (self.selectedLayer == layer) self.selectedLayer = nil;
}



- (UIBezierPath *)pathForText:(NSString *)text startPoint:(CGPoint)point
{

    CGMutablePathRef letters = CGPathCreateMutable();   //创建path

    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 100.0f, NULL);       //设置字体

    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);   //创建line
    CFArrayRef runArray = CTLineGetGlyphRuns(line);     //根据line获得一个数组

    // 获得每一个 run
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // 获得 run 的字体
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);

        // 获得 run 的每一个形象字
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // 获得形象字
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            //获得形象字信息
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);

            // 获得形象字外线的path
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);

    //根据构造出的 path 构造 bezier 对象
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];

    CGPathRelease(letters);
    CFRelease(font);
    return path;
}

#pragma mark - getter\setter

- (void)setTextArr:(NSMutableArray *)textArr
{
    objc_setAssociatedObject(self, ZYTextArrKey, textArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)textArr
{
    return objc_getAssociatedObject(self, ZYTextArrKey);
}

@end
