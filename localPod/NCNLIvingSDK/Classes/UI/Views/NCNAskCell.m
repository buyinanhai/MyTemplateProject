//
//  NCNAskCell.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/14.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNAskCell.h"

#import "NCNQ&ACellData.h"

@interface NCNAskCell()

@property (nonatomic, strong) NCNQACellContentView *askView;

@property (nonatomic, strong) NCNQACellContentView *anwserView;


@end
@implementation NCNAskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setupSubView];
    
    return self;
    
}


- (void)setData:(NCNQ_ACellData *)data {
    
    _data = data;
    
    [self.askView setContent:data.askText];
    [self.anwserView setContent:data.answerText];
    
    if ([data.sender isEqualToString:NCNLivingSDK.shareInstance.studentId]) {
        self.askView.QANamelabel.text  = @" 我 ";
    } else {
        self.askView.QANamelabel.text = data.askName;
    }
    self.askView.QATimelabel.text = data.askTime;
    self.anwserView.QANamelabel.text = data.answerName;
    self.anwserView.QATimelabel.text = data.answerTime;
    
    self.anwserView.hidden = data.answerText.length > 0 ? false : true;
   
    if (data.answerText.length > 0) {
        [self.askView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.height.offset(data.askContentHeight);
        }];
        [self.anwserView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.top.equalTo(self.askView.mas_bottom).offset(-5);;
            
        }];
    } else {
        [self.askView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.offset(0);
        }];
    }
    
}

- (void)setupSubView {
    
    self.backgroundColor = UIColor.clearColor;
    UIView *subContentView = UIView.new;
//    subContentView.layer.shadowRadius = 5;
    subContentView.layer.cornerRadius = 10;
    subContentView.layer.masksToBounds = true;
    subContentView.backgroundColor = UIColor.whiteColor;
    
    self.layer.shadowOffset = CGSizeMake(-1,1);
    self.layer.shadowColor = [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:0.5].CGColor;
    self.layer.shadowOpacity = 1;
    
    self.askView = [NCNQACellContentView QAViewWithIsAsk:true];
    
    self.anwserView = [NCNQACellContentView QAViewWithIsAsk:false];
    
        
    [self.contentView addSubview:subContentView];
    
    [subContentView addSubview:self.askView];
    [subContentView addSubview:self.anwserView];
    
    
    [subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7.5);
        make.right.offset(-7.5);
        make.top.offset(4);
        make.bottom.offset(-4);
    }];

    
    [self.askView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.offset(0);
    }];
    
   

   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.y+=12;
    newFrame.size.height-=12;
    newFrame.origin.x +=12;
    newFrame.size.width-=24;
    frame = newFrame;
    [super setFrame:frame];
}

@end

@interface NCNQACellContentView ()
@property (nonatomic, strong) UILabel *QASymbollabel;

@property (nonatomic, strong) UILabel *QAcontentLabel;

@property (nonatomic, assign) BOOL isAsk;

@end

@implementation NCNQACellContentView


+ (instancetype)QAViewWithIsAsk:(BOOL)isAsk {
    
    NCNQACellContentView *view = [[NCNQACellContentView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    view.isAsk = isAsk;
    [view setupSubView];

    return view;
    
}

- (void)setContent:(NSString *)content {
    
    _content = content;
    
    self.QAcontentLabel.text = content;
}


- (void)setupSubView {
    UILabel *askLabel = [[UILabel alloc] init];
    askLabel.backgroundColor = self.isAsk ? [UIColor colorWithRed:255/255.0 green:129/255.0 blue:132/255.0 alpha:1.0] :  [UIColor colorWithRed:128/255.0 green:194/255.0 blue:105/255.0 alpha:1.0];
    askLabel.layer.cornerRadius = 3;
    askLabel.font = [UIFont fontWithName:@"PingFang SC" size: 11];
    askLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    askLabel.text = self.isAsk ? @"问" : @"答";
    askLabel.textAlignment = NSTextAlignmentCenter;
    self.QASymbollabel = askLabel;
    
    self.QANamelabel = [[UILabel alloc] init];
    self.QANamelabel.font = [UIFont fontWithName:@"PingFang SC" size: 14];
    self.QANamelabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    self.QANamelabel.text = self.isAsk ? @"李*冬" : @"东也";
    
    self.QATimelabel = [[UILabel alloc] init];
    self.QATimelabel.font = [UIFont fontWithName:@"PingFang SC" size: 14];
    self.QATimelabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    self.QATimelabel.text = self.isAsk ? @"10:32" : @"11:30 回复";
    
    self.QAcontentLabel = [[UILabel alloc] init];
    self.QAcontentLabel.font = [UIFont fontWithName:@"PingFang SC" size: 14];
    self.QAcontentLabel.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1.0];
//    self.QAcontentLabel.text = self.isAsk ? @"请问如果想表现一个人非常的开心，心情愉悦，可以用哪些细节来描写呢?" : @"请问如果想表现一个人非常的开心，心情愉悦，可以用哪些细节来描写呢?请问如果想表现一个人非常的开心，心情愉悦，可以用哪些细节来描写呢?请问如果想表现一个人非常的开心，心情愉悦，可以用哪些细节来描写呢?请问如果想表现一个人非常的开心，心情愉悦，可以用哪些细节来描写呢?请问如果想表现一个人非常的开心，心情愉悦，可以用哪些细节来描写呢?";
    self.QAcontentLabel.numberOfLines = 0;
    
    [self addSubview:self.QASymbollabel];
    [self addSubview:self.QATimelabel];
    [self addSubview:self.QANamelabel];
    [self addSubview:self.QAcontentLabel];
    
    [self.QASymbollabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(12);
        make.width.offset(20);
        make.height.offset(16);
    }];
    
    [self.QANamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QASymbollabel.mas_right).offset(12);
        make.centerY.equalTo(self.QASymbollabel);
        make.width.lessThanOrEqualTo(@(100));
    }];
       
    [self.QATimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QANamelabel.mas_right).offset(8);
        make.centerY.equalTo(self.QASymbollabel);
    }];
    
    [self.QAcontentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QASymbollabel);
        make.right.offset(-8);
        make.top.equalTo(self.QASymbollabel.mas_bottom).offset(12);
        make.bottom.offset(-5);
    
    }];
    
       

}
@end
