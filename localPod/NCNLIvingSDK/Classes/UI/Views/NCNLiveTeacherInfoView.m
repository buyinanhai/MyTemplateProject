//
//  NCNLiveTeacherInfoView.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/1.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNLiveTeacherInfoView.h"
#import "NCNLivingMainVC.h"

@interface NCNLiveTeacherInfoView()

@property (weak,nonatomic) UIImageView *teacherImg;
@property (weak,nonatomic) UILabel *descLabel;
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *subjectLabel;

@end
@implementation NCNLiveTeacherInfoView

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self setupSubview];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    [self setupSubview];
    
    return self;
    
}

- (void)setupSubview {
    // 名字
    UILabel *nameLab = [UILabel new];
    [self addSubview:nameLab];
    nameLab.text = @"张老师";
    nameLab.font = [UIFont systemFontOfSize:SLMainFontSize+2];
    nameLab.textColor = UIColor.blackColor;
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(7);
    }];
    self.nameLabel = nameLab;

    UILabel *subjectLab = [UILabel new];
    subjectLab.font = [UIFont systemFontOfSize:SLMainFontSize-2];
    subjectLab.layer.cornerRadius = 8;
    [self addSubview:subjectLab];
    subjectLab.text = @"语文";
    subjectLab.backgroundColor = rgba(215, 234, 253, 1.0);
    subjectLab.textColor = rgba(60, 112, 165, 1);
    subjectLab.textAlignment = NSTextAlignmentCenter;
    subjectLab.layer.masksToBounds = YES;
    [subjectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLab.mas_right).offset(6);
        make.centerY.mas_equalTo(nameLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 17));
    }];
    self.subjectLabel = subjectLab;



    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowBtn setImage:[UIImage living_imageWithNamed:@"teacherUnfold@3x"] forState:UIControlStateNormal];
    [arrowBtn setImage:[UIImage living_imageWithNamed:@"teacherFold@3x"] forState:UIControlStateSelected];
    [self addSubview:arrowBtn];
    [arrowBtn addTarget:self action:@selector(arrowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(subjectLab.mas_right).offset(14);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.centerX.offset(0);
    }];
    arrowBtn.selected = true;
    //
//    UIImageView *teacherImg = [[UIImageView alloc]init];
//    [self addSubview:teacherImg];
//    teacherImg.image = [UIImage imageNamed:@"df_wide"];
//    teacherImg.layer.cornerRadius = 10;
//    teacherImg.layer.masksToBounds = YES;
//    [teacherImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-8);
//        make.centerY.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(90, 68));
//    }];
//    teacherImg.hidden = YES;
//    self.teacherImg = teacherImg;
    //
    UILabel *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:SLMainFontSize-1];
    [self addSubview:titleLab];
    titleLab.numberOfLines = 2;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(-8);
        make.left.mas_equalTo(nameLab.mas_left);
    }];
    self.descLabel = titleLab;
    
}

- (void)arrowBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.descLabel.hidden = self.teacherImg.hidden = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(teacherInfoView:isFold:)]) {
        [self.delegate teacherInfoView:self isFold:!btn.selected];
    }
}

- (void)updateWithModel:(NCNLivingRoomModel *)model {
    
    self.nameLabel.text = model.teacherName;
    self.descLabel.text = model.courseDesc;
    self.subjectLabel.text = model.subject;
    self.subjectLabel.hidden = self.subjectLabel.text.length > 0 ? false : true;
}
   


    
@end
