//
//  NCLiveVC.m
//  NewCloudLiveStream
//
//  Created by 尹彦博 on 2020/4/11.
//  Copyright © 2020 子宁. All rights reserved.
//

#import "NCLiveVC.h"
#import <ImSDK/ImSDK.h>
#import "NCLivePullView.h"
#import "NCLivePushView.h"
#import "Masonry.h"
#import "GenerateTestUserSig.h"
#import "THeader.h"
#import "NCIMManager.h"
#import "TUIInputController.h"


@interface NCLiveVC ()<TIMConnListener,UITableViewDataSource,UITableViewDelegate,TIMMessageListener,UITextViewDelegate, TInputControllerDelegate>
@property (nonatomic, strong) UIView *blankView;

@property (nonatomic, strong) NCLivePullView *teacherView;

@property (nonatomic, strong) UITableView *imTableView;

@property (nonatomic, strong) UITextView *inputView;

@property (nonatomic, strong) NCLivePushView *studentPreView;

@property (nonatomic, strong) NSMutableArray<TIMMessage *> *messages;

@property (nonatomic, strong) TUIInputController *inputController;
@end

@implementation NCLiveVC {
    
    NSLock *_messageLock;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self IMLogin];
    [self setupSubview];
    _messageLock = [NSLock new];
    self.messages = NSMutableArray.new;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage:) name:TUIKitNotification_TIMMessageListener object:nil];
    // Do any additional setup after loading the view.
}


- (void)IMLogin {
    
    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    [param setIdentifier:@"12344321"];
    param.userSig = [GenerateTestUserSig genTestUserSig:@"12344321"];
   
    int result = [TIMManager.sharedInstance login:param succ:^{
        NSLog(@"IM login successful~~~~~");
        //登录成功后加入群聊
        [self addChatGroup];
        
    } fail:^(int code, NSString *msg) {
        NSLog(@"IM  login failed  errormsg=%d errordesc=%@", code, msg);
    }];
        
    NSLog(@"登录初始化状态 %d", result);
    NSLog(@"当前IM登录状态 %ld",(long)TIMManager.sharedInstance.getLoginStatus);
}

- (void)addChatGroup {
    
    [TIMManager.sharedInstance.groupManager joinGroup:@"999999" msg:@"匡词匡词匡词匡词匡词" succ:^{
        NSLog(@"join group successful~~~~~");

    } fail:^(int code, NSString *msg) {
        NSLog(@"join group failed  errormsg=%d errordesc=%@", code, msg);
    }];
    
}
- (void)setupSubview {
    self.blankView = UIView.new;
    self.blankView.backgroundColor = UIColor.orangeColor;
    self.teacherView = [NCLivePullView pullViewWithLiveRoom:@""];
//    self.studentPreView = [NCLivePushView pushViewWithLiveRoom:@""];
    self.imTableView = UITableView.new;
    self.inputView = [[UITextView alloc] init];
    self.inputView.backgroundColor = UIColor.orangeColor;
    
    self.inputView.returnKeyType = UIReturnKeySend;
    self.inputView.delegate = self;
    self.inputView.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"我要发言" forState:UIControlStateNormal];
    [btn setTitle:@"停止发言" forState:UIControlStateSelected];

    [btn addTarget:self action:@selector(onLiving:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.imTableView];
    [self.view addSubview:self.blankView];
    [self.view addSubview:self.teacherView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.studentPreView];
    [self.view addSubview:btn];
    
    [self.teacherView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teacherViewClick)]];
    [self.blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(220);
    }];
    [self.imTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(220);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.offset(0);
        make.height.offset(44);
    }];
    
    [self.teacherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.offset(0);
        make.width.offset(120);
        make.height.offset(80);
    }];

    [self.studentPreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.offset(0);
        make.width.offset(120);
        make.height.offset(80);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-8);
        make.bottom.offset(-100);
    }];
    
   UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
   [msgBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [self.view addSubview:msgBtn];
    [msgBtn addTarget:self action:@selector(msgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.offset(-8);
           make.bottom.offset(-60);
       }];
    self.imTableView.dataSource = self;
    self.imTableView.delegate = self;
    
    [self.imTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    _inputController = [[TUIInputController alloc] init];
    _inputController.view.frame = CGRectMake(0, self.view.frame.size.height - TTextView_Height - kBottom_SafeHeight, self.view.frame.size.width, TTextView_Height + kBottom_SafeHeight);
    _inputController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _inputController.delegate = self;
//    [RACObserve(self, moreMenus) subscribeNext:^(NSArray *x) {
//        @strongify(self)
//        [self.inputController.moreView setData:x];
//    }];
    [self addChildViewController:_inputController];
    [self.view addSubview:_inputController.view];
    
}

#pragma mark TInputControllerDelegate
- (void)inputController:(TUIInputController *)inputController didChangeHeight:(CGFloat)height
{
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect msgFrame = self.view.frame;
        msgFrame.size.height = ws.view.frame.size.height - height;
        self.imTableView.frame = msgFrame;

        CGRect inputFrame = ws.inputController.view.frame;
        inputFrame.origin.y = msgFrame.origin.y + msgFrame.size.height;
        inputFrame.size.height = height;
        ws.inputController.view.frame = inputFrame;

        [self.imTableView setScrollsToTop:NO];
    } completion:nil];
}




- (void)teacherViewClick {
    
//    self.teacherView.isBigZoom = !self.teacherView.isBigZoom;
//    CGRect targetFrame = CGRectMake(0, 0, self.blankView.bounds.size.width, self.blankView.bounds.size.height);
//    [UIView animateWithDuration:0.25 animations:^{
//        if (self.teacherView.isBigZoom) {
//            [self.blankView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.left.offset(0);
//                make.width.offset(120);
//                make.height.offset(80);
//            }];
//            [self.teacherView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.top.right.offset(0);
//                make.height.offset(220);
//            }];
//        } else {
//            [self.blankView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.top.right.offset(0);
//                make.height.offset(220);
//            }];
//            [self.teacherView mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//                make.centerY.left.offset(0);
//                make.width.offset(120);
//                make.height.offset(80);
//            }];
//        }
//
//        [self.view layoutIfNeeded];
//    }];
//    [self.teacherView prepareToChangeFrame:targetFrame];
    
}

- (void)onLiving:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    if (!sender.isSelected) {
        [self.studentPreView stopToLive];
        self.studentPreView.hidden = true;
    } else {
        self.studentPreView.hidden = false;
        [self.studentPreView startToLive];
    }

}

- (void)msgBtnClick {
    
    [self sendMessageWithContent:@"我是wangling,  how are you?"];
    
}

- (void)clear {
    
    
    
}
#pragma mark  TIMConnListener
- (void)onNewMessage:(NSNotification *)info {
    

    NSArray<TIMMessage *> *messages = info.object;
    for (TIMMessage *message in messages) {
        TIMElem *elem = [message getElem:0];
        NSMutableArray *textMessages = [[NSMutableArray alloc] initWithCapacity:messages.count];
        if ([elem isKindOfClass:TIMTextElem.class]) {
            [textMessages addObject:message];
        }
        if (textMessages.count > 0) {
            [self insertNewMessages:textMessages];
        }
    }
    NSLog(@"收到新消息：  %@", messages);
    
    
}


#pragma mark uitableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TIMMessage *message = self.messages[indexPath.row];
    TIMTextElem *textElem = (TIMTextElem *)[message getElem:0];
    NSString *senderName = message.isSelf ? @"我" : message.getSenderNickname;
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@: %@",senderName, textElem.text];
    return cell;
}

#pragma mark uitextview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        [self sendMessageWithContent:textView.text];
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        return NO;
    }
    return YES;
}

- (void)sendMessageWithContent:(NSString *)content {
    
    TIMConversation *conversation = [TIMManager.sharedInstance getConversation:TIM_GROUP receiver:@"@TGS#2VMSY2LGU"];
    TIMMessage *message = [[TIMMessage alloc] init];
    TIMTextElem *elem = [TIMTextElem new];
    elem.text = content;
    [message addElem:elem];
    [conversation sendMessage:message succ:^{
        NSLog(@"聊天消息发送成功！！");
        [self.inputView setText:nil];
        [self insertNewMessages:@[message]];
    } fail:^(int code, NSString *msg) {
        NSLog(@"聊天消息发送失败！！ code == %d  errormsg= %@", code, msg);

    }];
   
}

- (void)insertNewMessages:(NSArray<TIMMessage *> *)messages {
    if (messages.count  == 0) {
        return;
    }
    [_messageLock lock];
   
    if (self.messages.count == 0) {
        [self.messages addObjectsFromArray:messages];
        [self.imTableView reloadData];
    } else {
        
        NSMutableArray<NSIndexPath *> *paths = [[NSMutableArray alloc] initWithCapacity:messages.count];
        for (TIMMessage *message in messages) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:self.messages.count inSection:0];
            [self.messages addObject:message];
            [paths addObject:index];
        }
        [self.imTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    }
  
    [_messageLock unlock];
    
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
