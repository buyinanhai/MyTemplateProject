//
//  NCNMessageImageCell.m
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/28.
//

#import "NCNMessageCell.h"
#import "NCNMessageCellModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NCIMManager.h"
#import <AFNetworking/AFNetworking.h>
@interface NCNMessageCell()
@property (nonatomic, strong) UIView *subContentView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIButton *faildBtn;
@property (nonatomic, strong) UIButton *bublleBtn;


@end

@implementation NCNMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setupSubview];
    self.backgroundColor = UIColor.clearColor;
    
    
    return self;
}


- (void)setModel:(NCNMessageCellModel *)model {
    
    _model = model;
    if (model.isSelf) {
        self.nameLabel.text = @"我";
    } else {
        __weak UILabel *weakSenderLabel = self.nameLabel;
        [model.message getSenderProfile:^(TIMUserProfile *profile) {
            weakSenderLabel.text = [NSString stringWithFormat:@"  %@     ",[profile nickname]];
        }];
    }
   
    [self updateMessageStatus];
    kWeakSelf(self);
    model.messageStatusUpdateCallback = ^{
        if (weakself) {
            [weakself updateMessageStatus];
        }
    };
    [self.bublleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(model.contentSize.width);
    }];
        
    
}
- (void)updateMessageStatus {
    if (self.model.status == NCNMessageStatus_Sending) {
        [self.activityView startAnimating];
        self.faildBtn.hidden = true;
    } else if(self.model.status == NCNMessageStatus_Failed) {
        self.faildBtn.hidden = false;
        [self.activityView stopAnimating];
    } else  {
        self.faildBtn.hidden = true;
        [self.activityView stopAnimating];
    }
}

 - (void)setStyle:(int)style {
     
     _style = style;
   
     
     if (_style == 1) {
         self.subContentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
         [self.subContentView sl_setCornerRadius:12];
         self.nameLabel.backgroundColor = UIColor.clearColor;
         if (self.model.isSelf) {
             self.nameLabel.text = @"我：";
             self.nameLabel.textColor = [UIColor colorWithHexString:@"#7AC18A"];
         } else if (self.model.isTeacher) {
             self.nameLabel.textColor = [UIColor redColor];
         }  else {
             self.nameLabel.text = [NSString stringWithFormat:@"  %@：  ",self.model.senderName];
             self.nameLabel.textColor = [UIColor colorWithHexString:@"#989EB4"];

         }
         self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
     } else {
         
         self.subContentView.layer.cornerRadius = 0;
         self.subContentView.layer.masksToBounds = false;
         self.subContentView.backgroundColor = UIColor.clearColor;
         self.nameLabel.textColor = UIColor.whiteColor;
        
         if (self.model.isSelf) {
             self.nameLabel.backgroundColor = rgba(122, 193, 138, 1);
         } else if(self.model.isTeacher) {
             self.nameLabel.backgroundColor = UIColor.redColor;
         } else {
             self.nameLabel.backgroundColor = rgba(201, 203, 217, 1);
         }
         self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

     }
   
 }
- (void)setupSubview {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    // Initialization code
    
    [self.contentView addSubview:self.subContentView];
    [self.subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(5);
        make.right.offset(-5);
        make.bottom.offset(-3);
//        make.width.greaterThanOrEqualTo(self.contentView.mas_width);
    }];
    [self.subContentView addSubview:self.nameLabel];
    [self.subContentView addSubview:self.bublleView];
    
    self.contentView.backgroundColor = UIColor.clearColor;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(5);
        make.height.offset(20);
        make.width.greaterThanOrEqualTo(@40);
        make.width.lessThanOrEqualTo(@60);

    }];
    self.nameLabel.layer.cornerRadius = 10;
    self.nameLabel.layer.masksToBounds = true;
    [self.bublleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(8);
        make.top.equalTo(self.nameLabel);
        make.bottom.offset(-5);
//        make.width.greaterThanOrEqualTo(@20);
        make.right.lessThanOrEqualTo(self.subContentView).offset(35);
    }];
    [self.subContentView addSubview:self.activityView];
    [self.subContentView addSubview:self.faildBtn];
    [self.faildBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bublleView.mas_right);
        make.centerY.equalTo(self.bublleView);
        make.size.offset(35);
    }];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bublleView.mas_right);
        make.centerY.equalTo(self.bublleView);
        make.size.offset(35);
    }];
    self.bublleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bublleBtn.backgroundColor = UIColor.clearColor;
    [self.bublleBtn addTarget:self action:@selector(bublleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.subContentView addSubview:self.bublleBtn];
    [self.bublleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.bublleView);
    }];
    [self.faildBtn addTarget:self action:@selector(failedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer  alloc] initWithTarget:self action:@selector(longPressedBubbleView:)];
    longTap.minimumPressDuration = 1.0;
    [self.bublleBtn addGestureRecognizer:longTap];
    
    [self setupBubbleView];
}
- (void)setupBubbleView {
    
    NSAssert(0, @"必须在子类实现setupBubbleView方法");
    
}
- (BOOL)canBecomeFirstResponder {
    
    return true;
}


#pragma mark actions
- (void)longPressedBubbleView:(UILongPressGestureRecognizer *)gestrue {
    NSLog(@"%s", __func__);
    self.bublleBtn.enabled = false;
    if (gestrue.state == UIGestureRecognizerStateBegan) {
        if (self.bubbleViewLongPressedCallback) {
            self.bubbleViewLongPressedCallback(self, self.model);
        }
        gestrue.state = UIGestureRecognizerStateEnded;
    }
    self.bublleBtn.enabled = true;
    
}

- (void)failedBtnClick {
    
    if (self.failedBtnClickCallback) {
        self.failedBtnClickCallback(self, self.model);
    }
}

- (void)bublleBtnClick {
    
    if (self.bubbleViewClickCallback) {
        self.bubbleViewClickCallback(self, self.model);
    }
    
}



- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.preferredMaxLayoutWidth = 100;
    }
    return _nameLabel;
    
    
}
- (UIActivityIndicatorView *)activityView {
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
    
}

- (UIButton *)faildBtn {
    
    if (!_faildBtn) {
        _faildBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faildBtn setImage:[UIImage living_imageWithNamed:@"ncn-messsage-send-failed@3x"] forState:UIControlStateNormal];
    }
    return _faildBtn;
    
}

- (UIView *)bublleView {
    
    if (!_bublleView) {
        _bublleView = [UIView new];
    }
    return _bublleView;
}

- (UIView *)subContentView {
    
    if (!_subContentView) {
        _subContentView = [UIView new];
        _subContentView.backgroundColor = UIColor.redColor;
    }
    return _subContentView;
    
}

@end



#pragma mark text cell

@implementation NCNMessageTextCell


- (void)setModel:(NCNTextMessageCellModel *)model {
    [super setModel:model];
    
    self.contentLabel.attributedText = model.attributedString;
}

- (void)setStyle:(int)style {
    [super setStyle:style];
    
    if (style == 1) {
        //横屏模式
        self.contentLabel.textColor = UIColor.whiteColor;
    } else {
        
        self.contentLabel.textColor = [UIColor colorWithHexString:@"#010101"];
    }
    
}

- (void)setupBubbleView {
    
    [self.bublleView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.offset(-5);
    }];
    
    
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        _contentLabel = [UILabel  new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL isLandscape = kScreen_Width > kScreen_Height;
       
//       CGFloat cellWidth = isLandscape ? 350 : kScreen_Width - 20;
//    CGFloat nameWidth = [self.model.senderName boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;
//       nameWidth = MIN(nameWidth, 40);
//       CGFloat contentWidth = cellWidth - nameWidth - 26;
//    _contentLabel.preferredMaxLayoutWidth = contentWidth - 40;
    
    CGFloat cellWidth = isLandscape ? 350 : kScreen_Width - 20;
    CGFloat nameWidth = [self.model.senderName boundingRectWithSize:CGSizeMake(60, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;
    if (nameWidth > 60) {
        nameWidth = 60;
    }
    nameWidth = MAX(nameWidth, 40);
    CGFloat contentWidth = cellWidth - nameWidth - 15 - 35;
    _contentLabel.preferredMaxLayoutWidth = contentWidth;

}


@end

#pragma mark image cell
@interface NCNMessageImageCell ()


@end

@implementation NCNMessageImageCell


- (void)setModel:(NCNImageMessageCellModel *)model {
    [super setModel:model];
    self.pictureView.image = nil;
    self.pictureView.frame = CGRectMake(0, 0, model.contentSize.width, model.contentSize.height);
  

    if (model.image) {
        self.pictureView.image = model.image;
    } else {
        if ([model.path hasPrefix:@"http"]) {
            
//            self.pictureView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.path]]];
            
            NSString *path = [TUIKit_Image_Path stringByAppendingString:[NCNLivingHelper genImageName:nil]];
            kWeakSelf(self);
            [model.imageItem getImage:path progress:^(NSInteger curSize, NSInteger totalSize) {
                NSLog(@"图片下载进度   %ld / %ld",curSize,totalSize);
            } succ:^{
                model.path = path;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.pictureView.image = [UIImage imageWithContentsOfFile:path];
                });
            } fail:^(int code, NSString *msg) {
                
            }];
            
        } else {
            self.pictureView.image = [UIImage imageWithContentsOfFile:model.path];
            
        }
        
    }
}

- (void)setupBubbleView {
    
    [self.bublleView addSubview:self.pictureView];
   
        
    
}


- (UIImageView *)pictureView {
    
    if (!_pictureView) {
        _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _pictureView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureView.backgroundColor = UIColor.grayColor;
    }
    return _pictureView;
    
}

@end


