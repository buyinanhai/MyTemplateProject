//
//  NCNMessageCellModel.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/28.
//

#import "NCNMessageCellModel.h"
#import <ImSDK/ImSDK.h>
#import "ncimmanager.h"
#import "TUIFaceCell.h"
#import "TUIFaceView.h"
#import "NSDate+Formatter.h"

@implementation NCNMessageCellModel
- (instancetype)init {
    
    self = [super init];
    self.contentSize = CGSizeMake(100, 44);
   
    return self;
    
}


+ (instancetype)messageCellModelWithMessage:(TIMMessage *)message {
    
    NCNMessageCellModel *data = [self new];
    
    data.message = message;
    
    data.senderName = data.message.isSelf ? @"我" : data.message.getSenderNickname;
    data.isTeacher = [message.sender isEqualToString:NCNLivingSDK.shareInstance.teacherId];
    data.status = message.status;
    return data;
    
}

- (BOOL)isSelf {
    
    if (_isSelf) {
        return _isSelf;
    }
    return self.message.isSelf;
    
}

- (void)update {
    
    if (self.messageStatusUpdateCallback) {
        self.messageStatusUpdateCallback();
    }
    
}

@end




@implementation NCNTextMessageCellModel


+ (instancetype)messageCellModelWithMessage:(TIMMessage *)message {
    
    NCNTextMessageCellModel *model = [super messageCellModelWithMessage:message];
    
    model.content = [(TIMTextElem *)[message getElem:0] text];
    
    //test
//    NSString *dateStr = [model.message.timestamp dateWithFormat:@"MM-dd hh:mm"];
//    model.content = [NSString stringWithFormat:@"%@------消息发送时间%@",model.content, dateStr];

    
    return model;
    
}

- (instancetype)init {
    self = [super init];
    
    self.textColor = UIColor.blackColor;
    self.textFont = [UIFont systemFontOfSize:14];
    return self;
    
}

- (CGSize)contentSize {
    
    BOOL isLandscape = kScreen_Width > kScreen_Height;
    
    CGFloat cellWidth = isLandscape ? 350 : kScreen_Width - 20;
    CGFloat nameWidth = [self.senderName boundingRectWithSize:CGSizeMake(60, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;
    if (nameWidth > 60) {
        nameWidth = 60;
    }
    nameWidth = MAX(nameWidth, 40);
    CGFloat contentWidth = cellWidth - nameWidth - 15 - 35;

    CGSize contentSize = [self.content boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont mediumFont:14]} context:nil].size;
    CGFloat textWidth = contentSize.width + 8;
    if (textWidth > contentWidth) {
        textWidth = contentWidth;
    }
    
    return CGSizeMake(textWidth, contentSize.height);
}




- (NSAttributedString *)attributedString
{
    if (!_attributedString) {
        _attributedString = [self formatMessageString:_content];
    }
    return _attributedString;
}

- (NSAttributedString *)formatMessageString:(NSString *)text
{
    //先判断text是否存在
    if (text == nil || text.length == 0) {
        NSLog(@"TTextMessageCell formatMessageString failed , current text is nil");
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];

    if([NCIMManager sharedInstance].faceGroups.count == 0){
        [attributeString addAttribute:NSFontAttributeName value:self.textFont range:NSMakeRange(0, attributeString.length)];
        return attributeString;
    }

    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情

    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }

    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];

    TFaceGroup *group = [NCIMManager sharedInstance].faceGroups[0];

    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];

        for (TFaceCellData *face in group.faces) {
            if ([face.name isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [UIImage imageWithContentsOfFile:face.path];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds = CGRectMake(0, -(self.textFont.lineHeight-self.textFont.pointSize)/2, self.textFont.pointSize, self.textFont.pointSize);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                break;
            }
        }
    }

    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }


    [attributeString addAttribute:NSFontAttributeName value:self.textFont range:NSMakeRange(0, attributeString.length)];

    return attributeString;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@: %s>  content:%@  time:%@",[self class],&self,self.content, self.message.timestamp];
    
}

@end



@implementation NCNImageMessageCellModel


+ (instancetype)messageCellModelWithMessage:(TIMMessage *)message {
    
    NCNImageMessageCellModel *model = [super messageCellModelWithMessage:message];
    TIMImageElem *elem = (TIMImageElem *)[message getElem:0];
    TIMImage *image = elem.imageList.firstObject;
    model.path = image.url;
    model.imageItem = image;
    model.imageSize = CGSizeMake(image.width,image.height);
    
//    NSString *path = [TUIKit_Image_Path stringByAppendingString:[NCNLivingHelper genImageName:nil]];
    
//    [image getImage:path progress:^(NSInteger curSize, NSInteger totalSize) {
//        model.progress = curSize / totalSize;
//    } succ:^{
//        model.image = [UIImage imageWithContentsOfFile:path];
//    } fail:^(int code, NSString *msg) {
//
//    }];
    return model;
}

- (CGSize)contentSize {
    
    BOOL isLandscape = kScreen_Width > kScreen_Height;
    
    CGFloat cellWidth = isLandscape ? 350 : kScreen_Width - 20;
    CGFloat nameWidth = [self.senderName boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;
    if (nameWidth > 60) {
        nameWidth = 60;
    }
    nameWidth = MAX(nameWidth, 40);
    CGFloat contentWidth = cellWidth - nameWidth - 15 - 35;
    
    
    CGFloat maxHeight = 150;
    
    CGFloat imageWidth = self.imageSize.width;
    CGFloat imageHeight = self.imageSize.height;
    if (imageHeight > maxHeight) {
        CGFloat ratio = maxHeight / imageHeight;
        imageHeight = maxHeight;
        imageWidth = self.imageSize.width  * ratio;
    } else if (imageWidth > contentWidth) {
        CGFloat ratio = contentWidth / imageWidth;
        imageWidth = contentWidth;
        imageHeight = imageHeight * ratio;
    }
    
    return CGSizeMake(imageWidth, imageHeight);
}

- (NSString *)description {
    
    
    return [NSString stringWithFormat:@"<%@: %s>  image:%@  time:%@",[self class],&self,self.imageItem, self.message.timestamp];

}

@end
