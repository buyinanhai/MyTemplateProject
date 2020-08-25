//
//  NCNMemberView.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/3.
//  Copyright © 2020 newcloudnet. All rights reserved.
//  成员

#import "NCNMemberView.h"
#import "NCNMemberCell.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "NCIMManager.h"

@interface NCNMemberView()<UITableViewDelegate,UITableViewDataSource,TIMConnListener>
@property (weak,nonatomic) UITableView *tab;

@property (nonatomic, copy) NSArray *datas;

@property (nonatomic, weak) UILabel *headerLabel;

@end

@implementation NCNMemberView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTableView];
        self.backgroundColor = UIColor.whiteColor;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMLoginSuccessed) name:TUIKitNotification_onLoginSuccessful object:nil];

    }
    return self;
}

- (void)setupTableView {
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-72) style:UITableViewStylePlain];
    [self addSubview:tab];
    tab.delegate = self;
    tab.dataSource = self;
    [tab registerNib:[UINib nibWithNibName:NSStringFromClass([NCNMemberCell class]) bundle:nil] forCellReuseIdentifier:@"memberCell"];
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    tab.rowHeight = 44;
    self.tab = tab;
    kWeakSelf(self);
    NCIMManager.sharedInstance.liveRoomUsersRefreshedCallback = ^(NSArray<NSDictionary *> *users) {
        if (weakself == nil) {
            return;
        }
        [weakself loadUserProfilesWithArray:users];
    };
    
}

- (void)IMLoginSuccessed {
    

}

- (void)willApear {
    NSArray<NSDictionary *> *onlineUsers = [NCIMManager.sharedInstance getOnlineUsers];
    if (onlineUsers.count > 0) {
        [self loadUserProfilesWithArray:onlineUsers];
    }
}

- (void)loadUserProfilesWithArray:(NSArray<NSDictionary *> *)array {
    
    NSMutableArray *ids = [[NSMutableArray alloc] initWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *userId = obj[@"userId"];
        [ids addObject:userId];
    }];
    [TIMManager.sharedInstance.friendshipManager getUsersProfile:ids forceUpdate:false succ:^(NSArray<TIMUserProfile *> *_profiles) {
        
        self.datas = _profiles;
        [self updateHeaderView];
        [self.tab reloadData];
        
    } fail:^(int code, NSString *msg) {
        
    }];
    
}

- (void)updateHeaderView {
    
    
    NSString *headerContent = [NSString stringWithFormat:@"●  在线成员（%ld人）", self.datas.count];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:headerContent];
    [attri addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#31D64C"]} range:NSMakeRange(0, 1)];
    self.headerLabel.attributedText = attri.copy;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NCNMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"];
    cell.profile = self.datas[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 44)];
    view.backgroundColor = UIColor.whiteColor;
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    
   
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    label.frame = view.bounds;
    self.headerLabel = label;
    [self updateHeaderView];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
    layer.frame = CGRectMake(20, 43, tableView.width - 40, 1);
    
    [view.layer addSublayer:layer];
    return view;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tab.frame = CGRectMake(0, 0, self.width, self.height-72);
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
