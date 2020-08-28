//
//  NCNAnnouncementView.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/3.
//  Copyright © 2020 newcloudnet. All rights reserved.
//  公共

#import "NCNAnnouncementView.h"
#import "NCIMManager.h"


@interface AnnounceTextView: UITextView
    
    

    
@end

@interface NCNAnnouncementView ()

@property (nonatomic, strong) AnnounceTextView *textView;

@property (nonatomic, weak) UIView *contentView;


@end

@implementation NCNAnnouncementView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (self.subviews.count == 0) {
        [self setupSubview];
    }
}

- (void)setupSubview {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    view.layer.shadowOffset = CGSizeMake(1,1);
    view.layer.shadowColor = [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:0.5].CGColor;
    view.layer.shadowOpacity = 1;
    
    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage living_imageWithNamed:@"notice@3x"];

    
    
    
    self.textView = [AnnounceTextView new];
    [self.textView setEditable:false];
    self.textView.font = [UIFont fontWithName:@"PingFang SC" size: 14];
    self.textView.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    for(UIGestureRecognizer *recognizer in self.textView.gestureRecognizers) {

        if([recognizer isKindOfClass:UILongPressGestureRecognizer.class] || [recognizer isKindOfClass:UITapGestureRecognizer.class]) {

            recognizer.enabled=NO;
        }
    }

  
   
    [self setContentForTextView:@""];
    [self addSubview:view];
    [view addSubview:self.textView];
    self.contentView = view;
//    [view addSubview:imageView];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7.5);
        make.top.offset(12);
        make.right.offset(-7.5);
        make.height.offset(140);
    }];
    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.offset(26);
//        make.size.offset(17 | 21);
//    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(26);
        make.bottom.right.offset(-26);
    }];
    
    self.contentView.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGroupInfoAnnouncementChanged:) name:TUIKitNotification_onGroupInfoChanged_Announcement object:nil];
}

- (void)onGroupInfoAnnouncementChanged:(NSNotification *)info {
    
    NSString *content = info.object;

    if (content.length > 0) {
        [self setContentForTextView:content];
    }

    
}

- (void)setContentForTextView:(NSString *)content {
    
    UIFont *font = [UIFont fontWithName:@"PingFang SC" size: 14];
    
    NSString *_content = [NSString stringWithFormat:@"      %@",content];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_content attributes:@{NSFontAttributeName: font,NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    //给附件添加图片
    textAttachment.image = [UIImage living_imageWithNamed:@"notice@3x"];
    //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
    //    textAttachment.bounds = CGRectMake(0, -(font.lineHeight- font.pointSize)/2, font.pointSize, font.pointSize);
    textAttachment.bounds = CGRectMake(0, -(font.lineHeight - font.pointSize)/2, 21, 17);
    
    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //把图片和图片对应的位置存入字典中
    NSRange range = NSMakeRange(0, 5);
    [attributeString replaceCharactersInRange:range withAttributedString:imageStr];
    self.textView.attributedText = attributeString;
    self.contentView.hidden = false;
    
}
- (void)willAppear {

    NSString *groupId = NCNLivingSDK.shareInstance.groupId;
    if (groupId.length == 0) {
        return;
    }
    [TIMManager.sharedInstance.groupManager getGroupInfo:@[groupId] succ:^(NSArray *groupList) {
        TIMGroupInfo *groupInfo = groupList.firstObject;
        NSString *notification = groupInfo.notification;
        if (notification.length > 0) {
            [self setContentForTextView:notification];
        } else {
            self.contentView.hidden = true;
        }
        
    } fail:^(int code, NSString *msg) {
        
    }];
    
   
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end



@implementation AnnounceTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    

    return false;
//    // 返回NO为禁用，YES为开启
//    // 粘贴
//    if (action == @selector(paste:)) return NO;
//    // 剪切
//    if (action == @selector(cut:)) return NO;
//    // 复制
//    if (action == @selector(copy:)) return NO;
//    // 选择
//    if (action == @selector(select:)) return NO;
//    // 选中全部
//    if (action == @selector(selectAll:)) return NO;
//    // 删除
//    if (action == @selector(delete:)) return NO;
//    // 分享
//    if (action == @selector(share)) return NO;
//    return [super canPerformAction:action withSender:sender];
}


- (BOOL)canBecomeFirstResponder {
    
    return false;
}
@end
