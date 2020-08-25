//
//  NCNMemberCell.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/18.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNMemberCell.h"
#import <ImSDK/ImSDK.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NCNMemberCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@end

@implementation NCNMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImgView.image = [UIImage living_imageWithNamed:@"defaultAvatar@3x"];
    self.symbolLabel.textColor = UIColor.whiteColor;
    // Initialization code
}

- (void)setProfile:(TIMUserProfile *)profile {
    
    _profile = profile;
    
    self.nameLabel.text = profile.nickname.length == 0 ? profile.identifier : profile.nickname;
    [self.avatarImgView setImageWithURL:[NSURL URLWithString:profile.faceURL]  placeholderImage:[UIImage living_imageWithNamed:@"defaultAvatar@3x"]];
    if ([TIMManager.sharedInstance.getLoginUser isEqualToString:profile.identifier]) {
        self.symbolLabel.backgroundColor = [UIColor colorWithHexString:@"#7AC18A"];
        self.symbolLabel.hidden = false;
        self.symbolLabel.text = @"我";
    } else {
        
        self.symbolLabel.hidden = true;
    }
    self.deviceLabel.hidden = true;
    NSLog(@"成员头像%@", profile.faceURL);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
