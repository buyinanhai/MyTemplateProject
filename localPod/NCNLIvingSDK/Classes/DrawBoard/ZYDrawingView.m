//
//  ZYDrawingView.m
//  ZYDrawBoard
//
//  Created by 王志盼 on 2018/5/31.
//  Copyright © 2018年 王志盼. All rights reserved.
//

#import "ZYDrawingView.h"
#import "ZYDottedLineField.h"

@interface ZYDrawingView ()<UITextViewDelegate>

@property (nonatomic, assign) BOOL isFirstTouch;//区分点击与滑动手势
@property (nonatomic, assign) BOOL isMoveLayer;//区分移动还是创建path

//新增加
@property (nonatomic, assign) BOOL isMoveTextLayer;//标记是否在移动文本

@property (nonatomic, assign) CGPoint startPoint;    //区域选择的起点
@property (nonatomic, assign) CGPoint endPoint;    //区域选择的终点

/**
 选中的区域覆盖view
 */
@property (nonatomic, strong) UIView *areaView;

/**
 现在是否为区域选中
 */
@property (nonatomic, assign) BOOL isAreaSelected;

/***现在文本是否为区域勾中*/
@property (nonatomic, assign) BOOL isTextAreaSelected;

/**
 所有textfield
 */
@property (nonatomic, strong) NSMutableArray *textfieldArr;

///**文本框**/
//@property (nonatomic, strong) ZYDrawTextField *txField;

/**
 待发送的画笔点库
 */
@property (nonatomic, strong) NSMutableArray *drawPointArr;

@property (nonatomic, assign) BOOL isFire; //是否触发

@property (nonatomic, strong) NSTimer *timer;



@end

@implementation ZYDrawingView

- (instancetype)initWithDefaultPenColor:(UIColor *)defaultColor{
    
    if (self = [super init])
    {
        self.userInteractionEnabled = YES;
        self.frame = [UIScreen mainScreen].bounds;
        self.layerArray = [NSMutableArray array];
        self.textArr = [NSMutableArray array];
        self.areaLayerArr = [NSMutableArray array];
        self.textfieldArr = [NSMutableArray array];
        self.laserDic = [[NSMutableDictionary alloc]init];
        
        self.drawPointArr = [NSMutableArray array];
        
        //self.backgroundColor = [UIColor blackColor];
        self.type = ZYDrawingTypeDrawing;
        self.isAreaSelected = false;
        self.isTextAreaSelected = false;
        self.cId = @"5000";
        
        //新加
        
        self.areaTextLayerArr = [NSMutableArray array];
        self.defaultColor = defaultColor;
        
        [self addSubview:self.areaView];
        
        
//        self.penWeight = 0.0;//笔宽度默认为零
//        self.textPenWeight = 0.0;//默认文本字体大小
//        self.hexStr = @"#FF1900";//默认文本字体颜色
//        self.textHexStr = @"#FF1900";//默认文本字体颜色
        
        self.penWeight = [NCDrawManager ShareInstance].weight;//笔宽度默认为零
        self.textPenWeight = [NCDrawManager ShareInstance].weight;//默认文本字体大小
        self.hexStr = [NCDrawManager ShareInstance].chooseColor;//默认画笔字体颜色
        self.textHexStr = [NCDrawManager ShareInstance].chooseColor;//默认文本字体颜色
        
        
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.userInteractionEnabled = YES;
        self.frame = [UIScreen mainScreen].bounds;
        self.layerArray = [NSMutableArray array];
        self.areaLayerArr = [NSMutableArray array];
        self.textfieldArr = [NSMutableArray array];
        self.laserDic = [[NSMutableDictionary alloc]init];
        
        //self.backgroundColor = [UIColor blackColor];
        self.type = ZYDrawingTypeDrawing;
        self.isAreaSelected = false;
        self.cId = @"5000";
        
        //新加
        self.areaTextLayerArr = [NSMutableArray array];
        
        [self addSubview:self.areaView];
        
    }
    return self;
}

-(CGFloat)pointpXRatio
{
//    return self.frame.size.width/100.0;
    return self.frame.size.width / 1920;
}

-(CGPoint) getRatioPoint:(CGPoint)orcPoint
{
    return CGPointMake(orcPoint.x/self.pointpXRatio, orcPoint.y/self.pointpXRatio);
}

-(CGPoint) getOrcPoint:(CGPoint)ratioPoint
{
    return CGPointMake(ratioPoint.x*self.pointpXRatio, ratioPoint.y*self.pointpXRatio);
}

-(CGRect) getRatioRect:(CGRect)orcRect
{
    return CGRectMake(orcRect.origin.x/self.pointpXRatio, orcRect.origin.y/self.pointpXRatio, orcRect.size.width/self.pointpXRatio, orcRect.size.height/self.pointpXRatio);
}

-(CGRect) getOrcRect:(CGRect)ratioRect
{
    return CGRectMake(ratioRect.origin.x/self.pointpXRatio, ratioRect.origin.y/self.pointpXRatio, ratioRect.size.width/self.pointpXRatio, ratioRect.size.height/self.pointpXRatio);
}

-(void)clearDrawingLayer
{
    for(ZYDrawingLayer *layer in self.layerArray)
    {
        [layer removeFromSuperlayer];

    }
    for (ZYTextLayer *layer in self.textArr) {
        [layer removeFromSuperlayer];
    }
    [self.layerArray removeAllObjects];
    [self.textArr removeAllObjects];
   
}

- (void)revoke
{
    if (self.isAreaSelected)
    {
        NSMutableArray *tmpArr = [NSMutableArray array];
        int length = (int)self.layerArray.count;
        for (int i = 0; i < length; i++)
        {
            ZYDrawingLayer *layer = self.layerArray[i];
            if (layer.isSelected)
            {
                [layer removeFromSuperlayer];
                if(layer.type>GraphTypeStraightLine)
                {
                    [self.delegate drawingView:self deleteGraphShapeLId:layer.lId cId:self.cId graphType:layer.type];
                }
                else
                {
                    [self.delegate drawingView:self deleteLId:layer.lId  cId:self.cId];
                }
                
                NSLog(@"-----deleteLid-----%@",layer.lId);
                [tmpArr addObject:layer];
            }
        }
        [self.layerArray removeObjectsInArray:tmpArr];
        
        
        
        //新加删除zytextlayer
        NSArray *tempArr = [NSArray arrayWithArray: self.layer.sublayers];
        
        for (CALayer *layer in tempArr) {
            if ([layer isKindOfClass:[ZYTextLayer class]]) {
                ZYTextLayer *textlayer = (ZYTextLayer *)layer;
                if (textlayer.isSelected) {
                    [textlayer removeFromSuperlayer];
                    
                    [self.textArr removeObject:textlayer];
                    
                    [self.delegate drawingView:self deleteTextLId:textlayer.lId cId:self.cId];
                    NSLog(@"-----deleteTextLId-----%@",textlayer.lId);
                }
            }
        }
        
    }
    else
    {
        [self.layerArray removeObject:self.selectedLayer];
        [self.selectedLayer removeFromSuperlayer];
        if(self.selectedLayer.type>GraphTypeStraightLine)
        {
            [self.delegate drawingView:self deleteGraphShapeLId:self.selectedLayer.lId cId:self.cId graphType:self.selectedLayer.type];
        }
        else
        {
            [self.delegate drawingView:self deleteLId:self.selectedLayer.lId  cId:self.cId];
        }
        
        //        NSLog(@"-----deleteLid-----%@",layer.lId);
        
        
        
        
        //新加删除zytextlayer
        NSArray *tempArr = [NSArray arrayWithArray: self.layer.sublayers];
        
        for (CALayer *layer in tempArr) {
            if ([layer isKindOfClass:[ZYTextLayer class]]) {
                ZYTextLayer *textlayer = (ZYTextLayer *)layer;
                if (textlayer.isSelected) {
                    [textlayer removeFromSuperlayer];
                    [self.delegate drawingView:self deleteTextLId:textlayer.lId cId:self.cId];
                    NSLog(@"-----deleteTextLId-----%@",textlayer.lId);
                }
            }
        }
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![NCDrawManager ShareInstance].permission) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    self.isFirstTouch = YES;//是否第一次点击屏幕
    self.isMoveLayer = NO;//是否移动layer
    self.isMoveTextLayer = NO;//是否移动文本标记
    
    //    if (self.type == ZYDrawingTypeTextfield)
    //    {
    //        ZYDottedLineField *field = [[ZYDottedLineField alloc] init];
    //        field.x = currentPoint.x;
    //        field.y = currentPoint.y;
    //        [field becomeFirstResponder];
    //        [self addSubview:field];
    //        [self.textfieldArr addObject:field];
    //        return;
    //    }
    
    if (self.type == ZYDrawingTypeSelected)
    {
        self.startPoint = currentPoint;
        if (self.isAreaSelected)
        {
            if ([self pointIsOnAreaLayers:currentPoint])
            {
                int length = (int)self.areaLayerArr.count;
                for (int i = 0; i < length; i++)
                {
                    ZYDrawingLayer *layer = self.areaLayerArr[i];
                    if (CGRectContainsPoint(layer.containRect, currentPoint))
                    {
                        self.selectedLayer = layer;
                        break;
                    }
                }
            }
            else
            {
                self.isAreaSelected = false;
                self.selectedLayer.isSelected = NO;
                self.selectedLayer = nil;
                int length = (int)self.areaLayerArr.count;
                for (int i = 0; i < length; i++)
                {
                    ZYDrawingLayer *layer = self.areaLayerArr[i];
                    layer.isSelected = false;
                }
                [self.areaLayerArr removeAllObjects];
            }
            
        }
        
        if (self.selectedLayer && CGRectContainsPoint(self.selectedLayer.containRect, currentPoint))
            //        if (self.selectedLayer && CGRectContainsPoint(self.selectedLayer.frame, currentPoint))
        {
            self.selectedLayer.isSelected = true;
        }
        else
        {
            self.selectedLayer.isSelected = NO;
            self.selectedLayer = nil;
            int length = (int)self.layerArray.count;
            for (int i = length - 1; i >= 0; i--)
            {
                ZYDrawingLayer *layer = self.layerArray[i];
                if (CGRectContainsPoint(layer.containRect, currentPoint))
                {
                    self.selectedLayer = layer;
                    self.selectedLayer.isSelected = YES;
                    break;
                }
            }
        }
        
        //针对文本
        //文本是否在勾中范围内---
        if (self.isTextAreaSelected)
        {
            //            if ([self pointIsOnTextAreaLayers:currentPoint])
            //pointIsOnAreaLayers
            if ([self pointIsOnAreaLayers:currentPoint])
            {
                if (self.selectedTextLayer)
                {
                    self.selectedTextLayer.isSelected = YES;
                }
            }
            else
            {
                self.selectedTextLayer.isSelected = NO;
                self.selectedTextLayer = nil;
                
                NSArray *tempArr = [NSArray arrayWithArray: self.layer.sublayers];
                for (CALayer *layer in tempArr)
                {
                    if ([layer isKindOfClass:[ZYTextLayer class]])
                    {
                        ZYTextLayer *textlayer = (ZYTextLayer *)layer;
                        textlayer.isSelected = false;
                        
                    }
                }
                
            }
        }
        
        
        
    }
    else if(self.type == ZYDrawingTypeTextfield)
    { //新加文本框创建
        
        self.selectedLayer.isSelected = false;
        
        if ([NCDrawManager ShareInstance].txField)
        {
            [[NCDrawManager ShareInstance].txField removeFromSuperview];
            [NCDrawManager ShareInstance].txField.delegate = self;
            [self addSubview:[NCDrawManager ShareInstance].txField];
        }
        else if(![NCDrawManager ShareInstance].txField)
        {
            
            uint32_t unitColor = unitColor = [UIColor transferHexToUIntWithHexString:self.textHexStr];
            
            [NCDrawManager ShareInstance].txField =[[ZYDrawTextField alloc] initWithFontColor:unitColor weight:self.textPenWeight];
            
            [NCDrawManager ShareInstance].txField.delegate = self;
            [self addSubview:[NCDrawManager ShareInstance].txField];
        }
        
        //        if(!_txField)
        //        {
        ////           uint32_t unitColor = [UIColor transferHexToUIntWithHexString:@"#6464B4"];
        ////
        ////            _txField =[[ZYDrawTextField alloc] initWithFontColor:unitColor weight:0];
        //            //暂时将文本设为一样
        //            uint32_t unitColor = [UIColor transferHexToUIntWithHexString:self.textHexStr];
        //
        //            _txField =[[ZYDrawTextField alloc] initWithFontColor:unitColor weight:self.textPenWeight];
        //
        //            _txField.delegate = self;
        //            [self addSubview:_txField];
        //        }
        [self txFieldAdjustFrame:currentPoint];
        
    }
    else if(self.type == ZYDrawingTypeMathGraph) //直线
    {
        self.selectedLayer.isSelected = false;
        UIColor *color = nil;
        if (self.hexStr.length > 3)
        {
            color = [UIColor colorWithHexString:self.hexStr];
        }
        
        /*
         self.drawingLayer = [ZYDrawingLayer createLayerWithStartPoint:currentPoint defaultColor:self.defaultColor chooseColor:color chooseWeight:0];//创建相应的layer
         
         NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
         self.drawingLayer.lId = [NSString stringWithFormat:@"ios-%lf", time];
         [self.layer addSublayer:self.drawingLayer];
         [self.layerArray addObject:self.drawingLayer];
         
         [self.delegate drawingView:self drawingBeginLId:self.drawingLayer.lId cId:self.cId point:[self getRatioPoint:currentPoint] weight:self.penWeight color:color];
         */
        if (!self.drawingLayer.isLastStepOfTriangle) /*非第二步时才创建*/
        {
            
            self.drawingLayer = [ZYDrawingLayer createMathGraphWithStartPoint:currentPoint chooseColor:color fillColor:[NCDrawManager ShareInstance].fillColor chooseWeight:[NCDrawManager ShareInstance].weight type:self.graphType];
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            u_int64_t timeNum = time*1000;
            self.drawingLayer.lId = [NSString stringWithFormat:@"%llu", timeNum];
            self.drawingLayer.zPosition = timeNum*100;
            [self.layer addSublayer:self.drawingLayer];
            [self.layerArray addObject:self.drawingLayer];
            
            if(self.graphType == GraphTypeStraightLine)
            {
                //先用这个实现直线，后期换掉一下方法
                [self.delegate drawingView:self drawingBeginLId:self.drawingLayer.lId cId:self.cId point:[self getRatioPoint:currentPoint] weight:self.penWeight color:color];
            }
            else if(self.graphType == GraphTypeEllipse || self.graphType == GraphTypeRectangle)
            {
                uint32_t color = 0;
                if (self.hexStr.length > 3)
                {
                    color = [UIColor transferHexToUIntWithHexString:self.hexStr];
                }
                [self.delegate drawingView:self drawingBeginGraphShapeLId:self.drawingLayer.lId cId:self.cId box:[self getRatioRect:self.drawingLayer.containBox] weight:self.penWeight color:color brushColor:[NCDrawManager ShareInstance].fillColor graphType:self.graphType];
            }
            
        }
    }
    else
    {
        self.selectedLayer.isSelected = false;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![NCDrawManager ShareInstance].permission) {
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    if (self.isFirstTouch)
    {
        
        if (self.selectedLayer && CGRectContainsPoint(self.selectedLayer.containRect, currentPoint) && self.type == ZYDrawingTypeSelected)
        {
            self.isMoveLayer = CGRectContainsPoint(self.selectedLayer.containRect, currentPoint);//计算当前point是否在已绘制的shapes里边
            //            NSLog(@"----isMoveLayer--%d",_isMoveLayer);
        }
        else if (self.type == ZYDrawingTypeDrawing)
        {
            UIColor * color = nil;
            if (self.hexStr.length > 3)
            {
                color = [UIColor colorWithHexString:self.hexStr];
            }
            ZYDrawingLayer *drawLayer = [ZYDrawingLayer createLayerWithStartPoint:previousPoint penColor:self.defaultColor chooseColor:color chooseWeight:self.penWeight layerSize:self.size];
            
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            u_int64_t timeNum = time*1000;
            drawLayer.lId = [NSString stringWithFormat:@"%llu", timeNum];
            drawLayer.zPosition = timeNum*100;
            self.drawingLayer = drawLayer;//创建相应的layer
            
            [self.layer addSublayer:self.drawingLayer];
            [self.layerArray addObject:self.drawingLayer];
            
            [self.delegate drawingView:self drawingBeginLId:self.drawingLayer.lId cId:self.cId point:[self getRatioPoint:previousPoint] weight:self.penWeight color:color];
        }
        else if(self.type == ZYDrawingTypeLaser)
        {
            if(!_laserPoint)
            {
                UIImage *laserImage = [UIImage imageNamed:@"laser_point"];
                _laserPoint = [[UIImageView alloc] initWithImage:laserImage];
                [_laserPoint setFrame:CGRectMake(0, 0, 24, 24)];
                _laserPoint.layer.anchorPoint = CGPointMake(0.5, 0.5);
                [self addSubview:_laserPoint];
            }
            _laserPoint.center = CGPointMake(previousPoint.x, previousPoint.y);
//            [self.delegate drawingView:self laserBegin:kUserId cId:self.cId point:[self getRatioPoint:previousPoint]];
        }
        else if(self.type == ZYDrawingTypeSelected &&self.selectedTextLayer&& CGRectContainsPoint(self.selectedTextLayer.frame, currentPoint)){ //最后查看文本框 标记文本框是处于可以移动状态
            
            self.isMoveTextLayer = YES;
        }
    }
    else
    {
        if (self.isMoveLayer && self.type == ZYDrawingTypeSelected)
        {
            if (self.isAreaSelected && self.areaLayerArr.count > 0)
            {
                for (ZYDrawingLayer *layer in self.areaLayerArr)
                {
                    
                    [layer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];//平移涂鸦shape
                }
                
                //新加文本判断
                if (self.areaTextLayerArr.count >0) { //确认存在文本layer
                    for (CALayer *layer in self.layer.sublayers) {
                        if ([layer isKindOfClass:[ZYTextLayer class]]) {
                            
                            ZYTextLayer *textlayer = (ZYTextLayer *)layer;
                            
                            if (textlayer.isSelected) {
                                
                                [textlayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];
                                
                                //[self.delegate drawingView:self moveTextLId:textlayer.lId cId:self.cId point:[self getRatioPoint:layer.frame.origin]];
                                
                                //                                NSLog(@"moveTextLId--%@",textlayer.lId);
                            }
                            
                            
                        }
                    }
                    
                }
                
            }
            else
            {
                [self.selectedLayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];//平移涂鸦shape
                NSLog(@"============  %@    %@", NSStringFromCGPoint(currentPoint), NSStringFromCGPoint(self.selectedLayer.containRect.origin));
            }
            
        }
        else if (self.type == ZYDrawingTypeDrawing)
        {
            ZYPointModel *model = [[ZYPointModel alloc] init];
            model.previousPoint = previousPoint;
            model.currentPoint = currentPoint;
            model.lid = self.drawingLayer.lId;
            [self.drawPointArr addObject:model];
            
            [self.delegate drawingView:self drawingMoveLId:self.drawingLayer.lId cId:self.cId point:[self getRatioPoint:currentPoint]];
            [self.drawingLayer movePathWithEndPoint:currentPoint];//绘制新创建的shape
            
            //            //改为每秒发30
            //            [self sendPacketBylimit];
            
        }
        else if (self.type == ZYDrawingTypeSelected && self.isMoveTextLayer) //标记仅有文本框移动时候
        {
            //新加文本内容移动判断  ------ 仅有文本框被勾中的情况下
            //            if (self.areaTextLayerArr.count >0) { //确认存在文本layer
            for (CALayer *layer in self.layer.sublayers) {
                if ([layer isKindOfClass:[ZYTextLayer class]]) {
                    
                    ZYTextLayer *textlayer = (ZYTextLayer *)layer;
                    
                    if (textlayer.isSelected) {
                        
                        [textlayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];
                        
                        //[self.delegate drawingView:self moveTextLId:textlayer.lId cId:self.cId point:[self getRatioPoint:layer.frame.origin]];
                        
                        NSLog(@"moveOnlyTextLId--%@",textlayer.lId);
                        
                    }
                }
                //                }
                
                
                
                //查看是否有之前勾住的画线
                if (self.isAreaSelected && self.areaLayerArr.count > 0)
                {
                    for (ZYDrawingLayer *layer in self.areaLayerArr)
                    {
                        
                        [layer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];//平移涂鸦shape
                        //                    NSLog(@"============  %@    %@", NSStringFromCGPoint(currentPoint), NSStringFromCGPoint(layer.containRect.origin));
                    }
                }
                
            }
        }
        else if (self.type == ZYDrawingTypeSelected)
        {
            self.areaView.hidden = false;
            self.endPoint = currentPoint;
            [self dealupSelectedArea];
        }
        else if(self.type == ZYDrawingTypeLaser)
        {
            if(!_laserPoint)
            {
                UIImage *laserImage = [UIImage imageNamed:@"laser_point"];
                _laserPoint = [[UIImageView alloc] initWithImage:laserImage];
                [_laserPoint setFrame:CGRectMake(0,0, _laserPoint.frame.size.width, _laserPoint.frame.size.height)];
                _laserPoint.layer.anchorPoint = CGPointMake(0.5, 0.5);
                [self addSubview:_laserPoint];
            }
            _laserPoint.center = CGPointMake(currentPoint.x, currentPoint.y);
            
//            [self.delegate drawingView:self laserMove:kUserId cId:self.cId point:[self getRatioPoint:previousPoint]];
        }
        else if(self.type == ZYDrawingTypeTextfield) //文本框
        {
            if ([NCDrawManager ShareInstance].txField)
            {
                [[NCDrawManager ShareInstance].txField removeFromSuperview];
                [self addSubview:[NCDrawManager ShareInstance].txField];
            }
            else if(![NCDrawManager ShareInstance].txField)
            {
                
                uint32_t unitColor = unitColor = [UIColor transferHexToUIntWithHexString:self.textHexStr];
                
                [NCDrawManager ShareInstance].txField =[[ZYDrawTextField alloc] initWithFontColor:unitColor weight:self.textPenWeight];
                [NCDrawManager ShareInstance].txField.delegate = self;
                
                [self addSubview:[NCDrawManager ShareInstance].txField];
            }
            [self txFieldAdjustFrame:currentPoint];
            
        }
        else if(self.type == ZYDrawingTypeMathGraph) //画直线 -- 最好能加条射线
        {
            if (self.drawingLayer)
            {
                if (self.drawingLayer.isTriangle && self.drawingLayer.isLastStepOfTriangle) //三角的第二步移动中
                {
                    [self.drawingLayer graphTriangleLastMoveWithCurrentPoint:currentPoint];
                    
                }
                else/*三角第一步移动过程 或者 其他图形移动过程*/
                {
                    [self.drawingLayer moveMathGraphWithCurrentPoint:currentPoint];
                    if(self.graphType == GraphTypeStraightLine)
                    {
                        
                    }
                    else
                    {
                        uint32_t color = 0;
                        if (self.hexStr.length > 3)
                        {
                            color = [UIColor transferHexToUIntWithHexString:self.hexStr];
                        }
                        [self.delegate drawingView:self drawingMoveGraphShapeLId:self.drawingLayer.lId cId:self.cId box:[self getRatioRect:self.drawingLayer.containBox] weight:self.penWeight color:color brushColor:[NCDrawManager ShareInstance].fillColor graphType:self.graphType];
                    }
                }
            }
        }
    }
    self.isFirstTouch = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![NCDrawManager ShareInstance].permission) {
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    if (self.type == ZYDrawingTypeDrawing)
    {
        if(self.drawingLayer!=nil)
        {
            [self.delegate drawingView:self drawingEndLId:self.drawingLayer.lId cId:self.cId point:[self getRatioPoint:currentPoint]];
        }
        //这个不知为何会这样写
        if (![self.layerArray containsObject:self.drawingLayer] && !self.isFirstTouch )
        {
            [self.layerArray addObject:self.drawingLayer];
        }
    }
    if (self.type == ZYDrawingTypeSelected)
    {
        if (self.isMoveLayer && self.type == ZYDrawingTypeSelected)
        {
            if (self.isAreaSelected && self.areaLayerArr.count > 0)
            {
                for (ZYDrawingLayer *layer in self.areaLayerArr)
                {
                    
                    [layer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];//平移涂鸦shape
                    //                    NSLog(@"============  %@    %@", NSStringFromCGPoint(currentPoint), NSStringFromCGPoint(layer.containRect.origin));
                    if(layer.type>GraphTypeStraightLine)
                    {
                        [self.delegate drawingView:self MoveGraphShapeLId:layer.lId cId:self.cId point:[self getRatioPoint:layer.containRect.origin] graphType:layer.type];
                    }
                    else
                    {
                        [self.delegate drawingView:self moveLId:layer.lId cId:self.cId point:[self getRatioPoint:layer.containRect.origin]];
                    }
                }
                
                //新加文本判断
                for (CALayer *layer in self.layer.sublayers) {
                    if ([layer isKindOfClass:[ZYTextLayer class]]) {
                        
                        ZYTextLayer *textlayer = (ZYTextLayer *)layer;
                        
                        if (textlayer.isSelected) {
                            
                            [textlayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];
                            
                            [self.delegate drawingView:self moveTextLId:textlayer.lId cId:self.cId point:[self getRatioPoint:layer.frame.origin]];
                            
                            //                                NSLog(@"moveTextLId--%@",textlayer.lId);
                        }
                        
                        
                    }
                }
                
            }
            else
            {
                [self.selectedLayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];//平移涂鸦shape
                NSLog(@"============  %@    %@", NSStringFromCGPoint(currentPoint), NSStringFromCGPoint(self.selectedLayer.containRect.origin));
                if(self.selectedLayer.type>GraphTypeStraightLine)
                {
                    [self.delegate drawingView:self MoveGraphShapeLId:self.selectedLayer.lId cId:self.cId point:[self getRatioPoint:self.selectedLayer.containRect.origin] graphType:self.selectedLayer.type];
                }
                else
                    [self.delegate drawingView:self moveLId:self.selectedLayer.lId cId:self.cId point:[self getRatioPoint:self.selectedLayer.containRect.origin]];
            }
            
        }
        else if (self.type == ZYDrawingTypeSelected && self.isMoveTextLayer) //标记仅有文本框移动时候
        {
            //新加文本内容移动判断  ------ 仅有文本框被勾中的情况下
            //            if (self.areaTextLayerArr.count >0) { //确认存在文本layer
            for (CALayer *layer in self.layer.sublayers) {
                if ([layer isKindOfClass:[ZYTextLayer class]]) {
                    
                    ZYTextLayer *textlayer = (ZYTextLayer *)layer;
                    
                    if (textlayer.isSelected) {
                        
                        [textlayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];
                        
                        [self.delegate drawingView:self moveTextLId:textlayer.lId cId:self.cId point:[self getRatioPoint:layer.frame.origin]];
                        
                        
                        
                    }
                }
                //                }
                
                
                
                //查看是否有之前勾住的画线
                if (self.isAreaSelected && self.areaLayerArr.count > 0)
                {
                    for (ZYDrawingLayer *layer in self.areaLayerArr)
                    {
                        
                        [layer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];//平移涂鸦shape
                        if(layer.type>GraphTypeStraightLine)
                        {
                            [self.delegate drawingView:self MoveGraphShapeLId:layer.lId cId:self.cId point:[self getRatioPoint:layer.containRect.origin] graphType:layer.type];
                        }
                        else
                            [self.delegate drawingView:self moveLId:layer.lId cId:self.cId point:[self getRatioPoint:layer.containRect.origin]];
                    }
                }
                
            }
        }
        self.areaView.hidden = true;
    }
    if(self.type == ZYDrawingTypeLaser)
    {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self];
        [self.laserPoint removeFromSuperview];
        self.laserPoint = nil;
//        [self.delegate drawingView:self laserEnd:kUserId cId:self.cId point:[self getRatioPoint:currentPoint]];
    }
    if (self.type == ZYDrawingTypeTextfield)
    {//文本框
        
    }
    if (self.type == ZYDrawingTypeMathGraph) //直线
    {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self];
        
        if(self.drawingLayer!=nil)
        {
            /*
             [self.drawingLayer movePathWithEndPoint:currentPoint];
             
             [self.delegate drawingView:self drawingEndLId:self.drawingLayer.lId cId:self.cId point:[self getRatioPoint:currentPoint]];
             */
            
            if (self.drawingLayer.isTriangle && self.drawingLayer.isLastStepOfTriangle) //三角的第二步行
            {
                [self.drawingLayer graphTriangleLastStepWithCurrentPoint:currentPoint];
            }
            else/*三角第一步的终点 或者 其他图形的终点*/
            {
                [self.drawingLayer finishMathGraphWithEndPoint:currentPoint];
                
                if(self.graphType == GraphTypeStraightLine)
                {
                    //先用这个实现直线方法 后期改掉
                    [self.delegate drawingView:self drawingEndLId:self.drawingLayer.lId cId:self.cId point:[self getRatioPoint:currentPoint]];
                }
                else if(self.graphType == GraphTypeEllipse || self.graphType == GraphTypeRectangle)
                {
                    uint32_t color = 0;
                    if (self.hexStr.length > 3)
                    {
                        color = [UIColor transferHexToUIntWithHexString:self.hexStr];
                    }
                    [self.delegate drawingView:self drawingEndGraphShapeLId:self.drawingLayer.lId cId:self.cId box:[self getRatioRect:self.drawingLayer.containBox] weight:self.penWeight color:color brushColor:[NCDrawManager ShareInstance].fillColor graphType:self.graphType];
                }
            }
            
            
            
        }
    }
    
    if (self.drawingLayer.isTriangle)
    {
        if (!self.drawingLayer.isLastStepOfTriangle)
        {
            self.drawingLayer.isLastStepOfTriangle = YES;
        }
        else
        {
            self.drawingLayer = nil;
        }
    }
    else
    {
        self.drawingLayer = nil;
    }
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![NCDrawManager ShareInstance].permission) {
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    if (self.type == ZYDrawingTypeDrawing)
    {
        //        UITouch *touch = [touches anyObject];
        //        CGPoint currentPoint = [touch locationInView:self];
        //        if(self.drawingLayer!=nil)
        //        {
        //            [self.delegate drawingView:self drawingEndLId:self.drawingLayer.lId cId:self.cId point:[self getRatioPoint:currentPoint]];
        //        }
        //        if (![self.layerArray containsObject:self.drawingLayer] && !self.isFirstTouch )
        //        {
        //            [self.layerArray addObject:self.drawingLayer];
        //        }
    }
    if(self.type == ZYDrawingTypeLaser)
    {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self];
        [self.laserPoint removeFromSuperview];
        self.laserPoint = nil;
//        [self.delegate drawingView:self laserEnd:kUserId cId:self.cId point:[self getRatioPoint:currentPoint]];
    }
    if (self.type == ZYDrawingTypeTextfield) {
        
    }
    if (self.isMoveLayer && self.type == ZYDrawingTypeSelected)
    {
        if (self.isAreaSelected && self.areaLayerArr.count > 0)
        {
            for (ZYDrawingLayer *layer in self.areaLayerArr)
            {
                
//                [layer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];//平移涂鸦shape
//                if(layer.type>GraphTypeStraightLine)
//                {
//                    [self.delegate drawingView:self MoveGraphShapeLId:layer.lId cId:self.cId point:[self getRatioPoint:layer.containRect.origin] graphType:layer.type];
//                }
//                else
//                    [self.delegate drawingView:self moveLId:layer.lId cId:self.cId point:[self getRatioPoint:layer.containRect.origin]];
            }
            
            //新加文本判断
            if (self.areaTextLayerArr.count >0) { //确认存在文本layer
                for (CALayer *layer in self.layer.sublayers) {
                    if ([layer isKindOfClass:[ZYTextLayer class]]) {
                        
                        ZYTextLayer *textlayer = (ZYTextLayer *)layer;
                        
                        if (textlayer.isSelected) {
                            
                            [textlayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];
                            
                            [self.delegate drawingView:self moveTextLId:textlayer.lId cId:self.cId point:[self getRatioPoint:layer.frame.origin]];
                            
                            //                                NSLog(@"moveTextLId--%@",textlayer.lId);
                        }
                        
                        
                    }
                }
                
            }
            
        }
        else
        {
//            [self.selectedLayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];//平移涂鸦shape
//            NSLog(@"============  %@    %@", NSStringFromCGPoint(currentPoint), NSStringFromCGPoint(self.selectedLayer.containRect.origin));
//            if(self.selectedLayer.type>GraphTypeStraightLine)
//            {
//                [self.delegate drawingView:self MoveGraphShapeLId:self.selectedLayer.lId cId:self.cId point:[self getRatioPoint:self.selectedLayer.containRect.origin] graphType:self.selectedLayer.type];
//            }
//            else
//                [self.delegate drawingView:self moveLId:self.selectedLayer.lId cId:self.cId point:[self getRatioPoint:self.selectedLayer.containRect.origin]];
        }
        
    }
}

- (void)dealupSelectedArea
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    CGFloat minX = MIN(self.startPoint.x, self.endPoint.x);
    CGFloat minY = MIN(self.startPoint.y, self.endPoint.y);
    CGFloat width = fabs(self.endPoint.x - self.startPoint.x);
    CGFloat height = fabs(self.endPoint.y - self.startPoint.y);
    self.areaView.frame = CGRectMake(minX, minY, width, height);
    
    //    NSLog(@"areaView.frame ---- %@",NSStringFromCGRect(self.areaView.frame));
    
    [self performSelector:@selector(dealupSelectedLayer) withObject:nil afterDelay:0.1];
}

- (void)dealupSelectedLayer
{
    self.isAreaSelected = true;
    int length = (int)self.layerArray.count;
    for (int i = 0; i < length; i++)
    {
        ZYDrawingLayer *layer = self.layerArray[i];
        if (CGRectIntersectsRect(self.areaView.frame, layer.containRect))
        {
            layer.isSelected = true;
            if (![self.areaLayerArr containsObject:layer])
            {
                [self.areaLayerArr addObject:layer];
            }
        }
        else
        {
            layer.isSelected = false;
            [self.areaLayerArr removeObject:layer];
        }
    }
    
    //添加新的CATextLayer
    //    int totalCount = (int)self.layer.sublayers;
    self.isTextAreaSelected = true;
    
    //    [self.areaTextLayerArr removeAllObjects];
    
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[ZYTextLayer class]]) {
            
            ZYTextLayer *textLayer = (ZYTextLayer *)layer;
            
            if (CGRectIntersectsRect(self.areaView.frame, textLayer.frame)) {
                
                textLayer.isSelected = YES;
                if (![self.areaTextLayerArr containsObject:layer]) {
                    [self.areaTextLayerArr addObject:layer];
                }
            }else {
                textLayer.isSelected = NO;
                [self.areaTextLayerArr removeObject:layer];
            }
        }
    }
    
    
    
}

- (BOOL)pointIsOnAreaLayers:(CGPoint)point
{
    int length = (int)self.areaLayerArr.count;
    for (int i = 0; i < length; i++)
    {
        ZYDrawingLayer *layer = self.areaLayerArr[i];
        if (CGRectContainsPoint(layer.containRect, point))
        {
            return true;
        }
    }
    
    
    //新加-----解决不能一起移动问题
    NSArray *tempArr = [NSArray arrayWithArray: self.layer.sublayers];
    for (CALayer *layer in tempArr)
    {
        if ([layer isKindOfClass:[ZYTextLayer class]])
        {
            ZYTextLayer *textlayer = (ZYTextLayer *)layer;
            if (CGRectContainsPoint(textlayer.frame, point))
            {
                self.selectedTextLayer = textlayer;
                //                NSLog(@"已有文本框被选中-------");
                return true;
                break;
            }
            
            
        }
    }
    
    
    return false;
}

- (BOOL)pointIsOnTextAreaLayers:(CGPoint)point
{
    NSArray *tempArr = [NSArray arrayWithArray: self.layer.sublayers];
    for (CALayer *layer in tempArr)
    {
        if ([layer isKindOfClass:[ZYTextLayer class]])
        {
            ZYTextLayer *textlayer = (ZYTextLayer *)layer;
            if (CGRectContainsPoint(textlayer.frame, point))
            {
                self.selectedTextLayer = textlayer;
                //                NSLog(@"已有文本框被选中-------");
                return true;
                break;
            }
            
            
        }
    }
    
    return false;
    
}


- (UIView *)areaView
{
    if (!_areaView)
    {
        _areaView = [[UIView alloc] init];
        _areaView.backgroundColor = YQDColor(100, 100, 180, 0.2);
        //        _areaView.backgroundColor = [UIColor cyanColor];
        _areaView.hidden = true;
        _areaView.layer.borderColor = YQDColor(100, 100, 180, 1).CGColor;
        _areaView.layer.borderWidth = 1;
    }
    return _areaView;
}

- (void)setType:(ZYDrawingType)type
{
    _type = type;
    if (type != ZYDrawingTypeSelected)
    {
        self.selectedLayer.isSelected = false;
        self.selectedLayer = nil;
        for (ZYDrawingLayer *layer in self.areaLayerArr)
        {
            layer.isSelected = false;
        }
        [self.areaLayerArr removeAllObjects];
        
        
        //针对文本
        self.selectedTextLayer.isSelected = true;
        self.selectedTextLayer = nil;
        NSArray *tempArr = [NSArray arrayWithArray: self.layer.sublayers];
        for (CALayer *layer in tempArr)
        {
            if ([layer isKindOfClass:[ZYTextLayer class]])
            {
                ZYTextLayer *textlayer = (ZYTextLayer *)layer;
                textlayer.isSelected = NO;
            }
        }
        [self.areaTextLayerArr removeAllObjects];
        
        
    }
}

- (void)txFieldAdjustFrame:(CGPoint)origin
{ //文本框frame计算
    CGPoint transferOrigin = CGPointZero;
    transferOrigin.x = origin.x;
    
    if (origin.y < 40) {
        transferOrigin.y = 10;
    }
    //    else if (origin.y>kScreenHeight - 120) {
    //        transferOrigin.y = kScreenHeight - 120;
    //    }
    else {
        transferOrigin.y = origin.y;
    }
    
    
    if (transferOrigin.x>self.width - 150) {
        [NCDrawManager ShareInstance].txField.frame = CGRectMake(self.width - 150, transferOrigin.y, 150, 80);
    }else if(transferOrigin.x<20){
        [NCDrawManager ShareInstance].txField.frame = CGRectMake(20, transferOrigin.y, 150, 80);
    }else {
        [NCDrawManager ShareInstance].txField.frame = CGRectMake(transferOrigin.x, transferOrigin.y, 150, 80);
    }
    
}


//文本编辑开始
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = nil;
}

//文本编辑完毕后
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if (textView.text.length > 0)
    {
        ZYTextLayer *textLayer = [[ZYTextLayer alloc] initWithFontColor:[UIColor transferHexToUIntWithHexString:self.textHexStr]  weight:self.textPenWeight];
        textLayer.string = textView.text;
        
        CGRect frame = textView.frame;
        //        frame = [textView.text boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT)
        float fontWeight = self.textPenWeight*27 + 18.0;
        //        frame = [textView.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
        //                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"SimSun" size:fontWeight]} context:nil];
        
        frame = [textView.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontWeight], NSForegroundColorAttributeName: UIColor.redColor} context:nil];
        
        //label1.font = [UIFont fontWithName:@"FiraSans-Bold" size:18];
        //SimSun
        
        frame.size.height = frame.size.height + 80;
        frame.size.width = 1500;
        
        //        NSLog(@"调整后的frame为----%@",NSStringFromCGRect(frame));
        
        //x,y坐标拿回来
        frame.origin = textView.origin;
        textLayer.frame = frame;
        [self.layer addSublayer:textLayer];
        
        //socket发送坐标 与文本给pc
        CGPoint finalPoint = CGPointZero;
        finalPoint.x = frame.origin.x/self.pointpXRatio;
        finalPoint.y = frame.origin.y/self.pointpXRatio;
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
        u_int64_t timeNum = timeStamp;
        NSString *lid = [NSString stringWithFormat:@"%llu",timeNum];
        textLayer.zPosition = timeNum*100;
        lid = [lid substringToIndex:13];
        
        uint32_t intColor = 0;
        intColor = [UIColor transferHexToUIntWithHexString:self.textHexStr];
        textLayer.lId = lid;
        
        [self.textArr addObject:textLayer];
        
        [self.delegate drawingView:self textViewContentPass:textView.text lid:lid cId:self.cId point:finalPoint weight:self.textPenWeight color:intColor];
        
    }
    
    //    NSLog(@"编辑完毕----");
    textView.text = nil;
    //    [_txField removeFromSuperview];
    //    _txField = nil;
    
    
    [[NCDrawManager ShareInstance].txField removeFromSuperview];
    [NCDrawManager ShareInstance].txField = nil;
}



- (void)sendPacketBylimit
{
    if (!self.isFire) {//尚未触发
        self.isFire = YES;
        [self.timer fire];
    }
}

- (void)sendPacket{
    
    if (self.drawPointArr.count>30){
        
        NSArray *temArr = [NSArray array];
        temArr = [self.drawPointArr subarrayWithRange:NSMakeRange(0, 30)];
        for (int i=0; i<30; i++) {
            ZYPointModel *model = temArr[i];
            [self.delegate drawingView:self drawingMoveLId:model.lid cId:self.cId point:[self getRatioPoint:model.currentPoint]];
            [self.drawPointArr removeObject:model];
        }
    }
    else if(self.drawPointArr.count>0){
        
        NSArray *temArr = [NSArray array];
        temArr = self.drawPointArr;
        
        for (int i=0; i<temArr.count; i++) {
            ZYPointModel *model = temArr[i];
            [self.delegate drawingView:self drawingMoveLId:model.lid cId:self.cId point:[self getRatioPoint:model.currentPoint]];
            [self.drawPointArr removeObject:model];
        }
        
    }else {
        
        [self.timer invalidate];
        self.timer = nil;
        self.isFire = NO;
    }
    //
}

- (NSTimer *)timer{
    if (!_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(sendPacket) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

//- (void)dealloc{
//    if (self.timer) {
//        [self.timer invalidate];
//    }
//}

@end

@implementation ZYPointModel
@end
