//
//  NCNQuestionAskView.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/3.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNQuestionAskView.h"
#import "UIView+Extension.h"
#import "NCNAskCell.h"
#import "Masonry.h"
#import "dybutton.h"
#import "NCQAElemMSG.h"
#import "NCNQ&ACellData.h"
#import <ImSDK/ImSDK.h>
#import "NCQAElemMSG.h"
#import "NSDate+Formatter.h"
#import "ncimmanager.h"

@interface NCNQuestionAskView()<UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic) UITableView *tableView;
@property (nonatomic, strong) DYButton *noneBtn;

@property (nonatomic, strong) NSMutableArray<NCNQ_ACellData *> *datas;

@property (nonatomic, strong) TIMConversation *teacherConversation;
@property (nonatomic, strong) TIMMessage *topStackMessage;


@end
@implementation NCNQuestionAskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupTableView];
        self.datas = @[].mutableCopy;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMLoginSuccessed) name:@"TUIKitNotification_onLoginSuccessful" object:nil];

    }
    return self;
}
- (void)setupTableView {
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    [self addSubview:tab];
    tab.delegate = self;
    tab.dataSource = self;
    [tab registerClass:[NCNAskCell class] forCellReuseIdentifier:@"cell"];
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tab.rowHeight = UITableViewAutomaticDimension;
//    tab.estimatedRowHeight = 200;
    self.tableView = tab;
    self.tableView.allowsSelection = false;
    [self.tableView addSubview:self.noneBtn];
    [self.noneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.center.offset(0);
       }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    [refresh addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refresh;
     
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishBtn setTitle:@"发布问题" forState:UIControlStateNormal];
    [publishBtn.titleLabel setFont:[UIFont systemFontOfSize:SLMainFontSize+2]];
    [publishBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [publishBtn setBackgroundColor:rgba(253, 160, 84, 1.0)];
    [publishBtn living_addShadowWithCornerRadius:17.5];
    [self addSubview:publishBtn];
//    publishBtn.backgroundColor = ColorRGB(237, 201, 149, 1.0);
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-32);
        make.height.offset(35);
        make.centerX.offset(0);
        make.width.offset(150);
        
    }];
    [publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}
- (void)IMLoginSuccessed {
    
    self.teacherConversation = [TIMManager.sharedInstance getConversation:TIM_C2C receiver:NCNLivingSDK.shareInstance.teacherId];

    [self loadData];
    
}

- (void)loadData {
    
    [self.teacherConversation getMessage:50 last:self.topStackMessage succ:^(NSArray<TIMMessage *> *msgs) {
        [self.tableView.refreshControl endRefreshing];
        if (msgs.count == 0) {
            [YJProgressHUD showMessage:@"没有更多历史消息" inView:self];
            return;
        }
        self.topStackMessage = msgs.lastObject;
        [msgs enumerateObjectsUsingBlock:^(TIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.status != TIM_MSG_STATUS_SEND_SUCC) {
                return;
            }
            TIMCustomElem *elem = [obj getElem:0];
            if (elem.classForCoder == TIMCustomElem.class) {
                NSDictionary *customDict = [NSJSONSerialization JSONObjectWithData:elem.data options:0 error:0];
                NSString *cmdType = customDict[@"cmdType"];
                if (cmdType.intValue  == 5) {
                    NCQAElemMSG *qa = [NCQAElemMSG new];
                    [qa setValuesForKeysWithDictionary:customDict[@"cmdData"]];
                    if (qa.askId.length == 0) {
                        qa.askId = [NSString stringWithFormat:@"%llu",obj.locator.seq];
                    }
                    if (![qa.liveRoomId isEqualToString:NCNLivingSDK.shareInstance.liveRoomId]) {
                        return;
                    }
                    NCNQ_ACellData *data = [self findDataWithId:qa.askId];
                    if (data == nil) {
                        data = [NCNQ_ACellData new];
                        [self.datas insertObject:data atIndex:0];
                    }
                    data.sender = obj.sender;
                    if (qa.askOperation.boolValue) {
                        data.askId = qa.askId;
                        data.answerElem = obj;
                        data.answerText = qa.askText;
                        __weak NCNQ_ACellData *weakData = data;
                        [obj getSenderProfile:^(TIMUserProfile *profile) {
                            weakData.answerName = profile.nickname;
                        }];
                        data.answerTime = [obj.timestamp dateWithFormat:@"MM-dd HH:mm"];
                    } else {
                        data.askId = qa.askId;
                        data.askText = qa.askText;
                        data.askName = NCIMManager.sharedInstance.myselfProfile.nickname;
                        data.askTime = [obj.timestamp dateWithFormat:@"MM-dd HH:mm"];
                    }
                        
                    
                }
               
            }
        }];
        if (self.datas.count > 0) {
            self.noneBtn.hidden = true;
        }
        [self.tableView reloadData];
    } fail:^(int code, NSString *msg) {
        [self.tableView.refreshControl endRefreshing];
        [YJProgressHUD showMessage:@"获取失败！" inView:self];
    }];
    
}

- (void)insertHistoryMessages:(NSArray<TIMMessage *> *)messages {
    
    
}



- (void)addQAData:(NSArray<NCNQ_ACellData *> *)datas {
    
    if (datas.count == 0) return;
    
    if (self.datas.count == 0) {
        
        [datas enumerateObjectsUsingBlock:^(NCNQ_ACellData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.datas addObject:obj];
        }];
        [self.tableView reloadData];
        self.noneBtn.hidden = true;
    } else {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:datas.count];
        [datas enumerateObjectsUsingBlock:^(NCNQ_ACellData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:self.datas.count inSection:0]];
            [self.datas addObject:obj];
        }];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)publishBtnClick {
    NSLog(@"%s",__func__);
    if (self.publishBtnClickCallback) {
        self.publishBtnClickCallback();
    }
//    [NSNotificationCenter.defaultCenter postNotificationName:NCNPublishBtnDidSelectNotification object:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NCNAskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.data = self.datas[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NCNQ_ACellData *data = self.datas[indexPath.row];
    return [data askContentHeight] + [data answerContentHeight];
    
}
- (NCNQ_ACellData *)findDataWithId:(NSString *)id {
    
    __block NCNQ_ACellData *data = nil;
    [self.datas enumerateObjectsUsingBlock:^(NCNQ_ACellData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.askId isEqualToString:id]) {
            data = obj;
            *stop = true;
        }
    }];
        
    return data;
}

- (void)updateData:(NCNQ_ACellData *)data {
    
    if (data) {
        NSInteger index = [self.datas indexOfObject:data];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



- (DYButton *)noneBtn {
    
    if (!_noneBtn) {
        _noneBtn = [DYButton buttonWithType:UIButtonTypeCustom];
        [_noneBtn setDirection:1];
        [_noneBtn setImage:[NSBundle living_loadImageWithName:@"noneMessage@3x"]];
        [_noneBtn setTitle:@"还没有问答\n快去提个问题吧" forState:UIControlStateNormal];
        _noneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_noneBtn setTextColor:YQDColor(152, 158, 180, 1)];
    }
    
    return  _noneBtn;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
