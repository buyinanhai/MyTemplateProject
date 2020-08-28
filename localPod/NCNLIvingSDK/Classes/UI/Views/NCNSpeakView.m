//
//  NCNSpeakView.m
//  XYClassRoom
//
//  Created by 邹超 on 2020/4/2.
//  Copyright © 2020 newcloudnet. All rights reserved.
//  发言

#import "NCNSpeakView.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "NCIMManager.h"
#import "DYButton.h"
#import "tuiinputcontroller.h"
#import "NCNMessageCell.h"
#import "NCNMessageCellModel.h"
#import "NCNImageBrowserVC.h"
@interface NCNSpeakView()<UITableViewDelegate,UITableViewDataSource,TInputControllerDelegate>
@property (weak,nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NCNMessageCellModel *> *messages;

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *heightCache;

@property (nonatomic, strong) DYButton *noneBtn;


@property (nonatomic, strong) TUIInputController *inputController;

@property (nonatomic, assign) BOOL isLandscape;

@property (nonatomic, strong) TIMConversation *groupConversation;

@property (nonatomic, strong) NSOperationQueue *messagequeue;

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, weak) NCNMessageCellModel *currentLongPressModel;



@end
@implementation NCNSpeakView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMLoginSuccessed) name:TUIKitNotification_onLoginSuccessful object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImageProgress:) name:TUIKitNotification_TIMUploadProgressListener object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRevokeMessage:) name:TUIKitNotification_TIMMessageRevokeListener object:nil];


        [self addNotifications];
        self.isFirstLoad = true;
        self.messages = @[].mutableCopy;
        
    }
    return self;
}

- (void)addNotifications {
    
  
    
}

- (void)setupTableView {
   
    self.heightCache = NSMutableDictionary.new;
    
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-70) style:UITableViewStylePlain];
    tab.estimatedRowHeight = 60;
//    tab.rowHeight = UITableViewAutomaticDimension;
    tab.backgroundColor = UIColor.whiteColor;
    [self addSubview:tab];
    tab.delegate = self;
    tab.dataSource = self;
    [tab registerClass:NCNMessageTextCell.class forCellReuseIdentifier:NCN_IM_Cell_Reuse_Identifier_Text];
    [tab registerClass:NCNMessageImageCell.class forCellReuseIdentifier:NCN_IM_Cell_Reuse_Identifier_Image];

    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tab;
    [self.tableView addSubview:self.noneBtn];
    [self.noneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    //input
    _inputController = [[TUIInputController alloc] init];
    _inputController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _inputController.delegate = self;

    CGFloat inputHeight = TTextView_Height + kBottom_SafeHeight;
    if (kBottom_SafeHeight == 0) {
        inputHeight += 10.0;
    }
    
    _inputController.view.frame = CGRectMake(0, self.frame.size.height - inputHeight, kScreen_Width, inputHeight);
    _inputController.view.backgroundColor = UIColor.whiteColor;
    [self.belongVC addChildViewController:_inputController];
    [self addSubview:_inputController.view];
//    [_inputController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.left.offset(0);
//        make.height.offset(inputHeight);
//    }];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    [refresh addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refresh;

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, _inputController.view.height - kBottom_SafeHeight, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.top.offset(0);
//        make.bottom.offset(-(_inputController.view.height));
    }];
    
}


- (void)IMLoginSuccessed {
    
    [self loadData];
    
}
- (void)uploadImageProgress:(NSNotification *)info {
    
    NSDictionary *dic = info.object;
    TIMMessage *msg = [dic objectForKey:@"message"];
    NSNumber *progress = [dic objectForKey:@"progress"];
    
    NSLog(@"图片 %@  进度： %@",msg,progress);
    
}

- (void)onRevokeMessage:(NSNotification *)info {
    
    TIMMessageLocator *locator = info.object;
    
    if ([locator.sessId isEqualToString:NCNLivingSDK.shareInstance.groupId]) {
        
        kWeakSelf(self);
        [self.messagequeue addOperationWithBlock:^{
            __block NSInteger index = -1;
            [weakself.messages enumerateObjectsUsingBlock:^(NCNMessageCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.message.locator.seq == locator.seq) {
                    index = idx;
                    *stop = true;
                }
            }];
            if (index > -1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.messages removeObjectAtIndex:index];
                    [weakself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                });
            }
        }];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.tableView.width == 0) {
       [self setupTableView];
    }

}

- (void)loadData {
    
    if (TIMManager.sharedInstance.getLoginStatus == TIM_STATUS_LOGOUT) {
        [YJProgressHUD showMessage:@"正在尝试登录..." inView:self];
        [NCIMManager.sharedInstance startLoginForIM];
        return;
    }
  
    if (self.groupConversation == nil) {
        self.groupConversation = [TIMManager.sharedInstance getConversation:TIM_GROUP receiver:NCNLivingSDK.shareInstance.groupId];
    }
    [self.groupConversation getMessage:20 last:self.messages.firstObject.message succ:^(NSArray *msgs) {
        if (msgs.count == 0) {
            [YJProgressHUD showMessage:@"没有更多历史消息" inView:self];

        } else {
            kWeakSelf(self);

            [self.messagequeue addOperationWithBlock:^{
                [weakself insertHistoryMessages:msgs];
            }];
        }
        [self.tableView.refreshControl endRefreshing];

    } fail:^(int code, NSString *msg) {
    
        [YJProgressHUD showMessage:[NCNLivingHelper im_errorMsgWithCode:code defaultErrMsg:@"获取失败！"] inView:self];
        [self.tableView.refreshControl endRefreshing];
    }];

}


#pragma mark 处理消息

- (void)insertHistoryMessages:(NSArray<TIMMessage *> *)messages {
    
    NSLog(@"%s",__func__);
//    NSInteger msgCount = self.messages.count;
//    messages = [messages sortedArrayUsingComparator:^NSComparisonResult(TIMMessage   *obj1, TIMMessage  *obj2) {
//        return obj1.timestamp.timeIntervalSince1970 < obj2.timestamp.timeIntervalSince1970;
//    }];
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    kWeakSelf(self);
        //    if (indexPaths.count > 0) {
    [messages enumerateObjectsUsingBlock:^(TIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NCNMessageCellModel *data = [weakself transformModelFromMessage:obj];
        if (data) {
            //            [indexPaths addObject:[NSIndexPath indexPathForRow:self.messages.count inSection:0]];
            [weakself.messages insertObject:data atIndex:0];
        }
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.tableView reloadData];
        if (weakself.messages.count > 0) {
            weakself.noneBtn.hidden = true;
        }
        if (weakself.isFirstLoad) {
            [weakself scrollToMessageBottom];
            weakself.isFirstLoad = false;
        }
    });
        //    }
    
}


- (void)insertNewMessages:(NSArray<TIMMessage *> *)messages {
    
    kWeakSelf(self);
    [self.messagequeue addOperationWithBlock:^{
        [messages enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(TIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NCNMessageCellModel *model = [self transformModelFromMessage:obj];

            if (model) {
                [weakself insertNewMessage:model];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself scrollToMessageBottom];
        });
    }];
   
}

- (void)insertNewMessage:(NCNMessageCellModel *)model {
    if (!model) {
        return;
    }
    kWeakSelf(self);

    self.noneBtn.hidden = true;
    if (self.messages.count == 0) {
        [self.messagequeue addOperationWithBlock:^{
            
            [weakself.messages addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.tableView reloadData];
            });
        }];
    } else {
        
        [self.messagequeue addOperationWithBlock:^{
            
            NSMutableArray<NSIndexPath *> *paths = [[NSMutableArray alloc] initWithCapacity:1];
            NSIndexPath *index = [NSIndexPath indexPathForRow:weakself.messages.count inSection:0];
            [paths addObject:index];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.messages addObject:model];
                [weakself.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
                [weakself scrollToMessageBottom];
            });
            
        }];
    }
    
}
- (void)sendMessageWithContent:(NSString *)content {
    
    NCNTextMessageCellModel *model = [NCNTextMessageCellModel new];
    model.isSelf = true;
    model.content = content;
    
    [self sendMessageWithCellModel:model];
}

- (void)sendMessageWithCellModel:(NCNMessageCellModel *)model {
    

    BOOL isResendMessage = true;
    TIMMessage *message = model.message;
    if (message == nil) {
        message = [self transformMessageFromCellModel:model];
        isResendMessage = false;
        model.message = message;
    }
    if (!isResendMessage) {
        
        [self insertNewMessage:model];
    }
    model.status = NCNMessageStatus_Sending;
    if (message) {

        [self.groupConversation sendMessage:message succ:^{
            NSLog(@"聊天消息发送成功！！");
            [self.inputView setText:nil];
            model.status = NCNMessageStatus_Successed;
            [model update];
            
        } fail:^(int code, NSString *msg) {
            NSLog(@"聊天消息发送失败！！ code == %d  errormsg= %@", code, msg);
            [YJProgressHUD showMessage:[NCNLivingHelper im_errorMsgWithCode:code defaultErrMsg:@"发送失败！"] inView:self];
            model.status = NCNMessageStatus_Failed;
            [model update];
        }];
        [self.inputController.inputBar endEditing:true];
    }

}
- (void)sendImageMessageWithImages:(NSArray<UIImage *> *)images {
    
    if (images.count == 0) {
        return;
    }
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *dataImage = UIImageJPEGRepresentation(obj, 0.5);
        NSString *path = [TUIKit_Image_Path stringByAppendingString:[NCNLivingHelper genImageName:nil]];
        BOOL isCreate = [[NSFileManager defaultManager] createFileAtPath:path contents:dataImage attributes:nil];
        if (isCreate) {
            NCNImageMessageCellModel *model = [NCNImageMessageCellModel new];
            model.isSelf = true;
            model.image = obj;
            model.path = path;
            model.imageSize = obj.size;
            [self sendMessageWithCellModel:model];
        } else {
            NSLog(@"创建本地路径文件失败！");
        }
        
        
       
    }];
   
}

- (NCNMessageCellModel *)transformModelFromMessage:(TIMMessage *)msg {
    
    
    NCNMessageCellModel *data = nil;
    if (msg.status == TIM_MSG_STATUS_SEND_SUCC) {
        TIMElem *elem = [msg getElem:0];
        if (elem.classForCoder == TIMTextElem.class) {
            data = [NCNTextMessageCellModel messageCellModelWithMessage:msg];
        } else if (elem.classForCoder == TIMImageElem.class) {
            
            data = [NCNImageMessageCellModel messageCellModelWithMessage:msg];
        }
    }
   
    return data;
}
- (TIMMessage *)transformMessageFromCellModel:(NCNMessageCellModel *)model {
    
    TIMMessage *message = model.message;
    if (message == nil) {
        
        if (model.classForCoder == NCNTextMessageCellModel.class) {
            NCNTextMessageCellModel *textModel = (NCNTextMessageCellModel *)model;
            message = [[TIMMessage alloc] init];
            TIMTextElem *textElem = [[TIMTextElem alloc] init];
            textElem.text = textModel.content;
            [message addElem:textElem];
            
        } else if (model.classForCoder == NCNImageMessageCellModel.class) {
            
            NCNImageMessageCellModel *imageModel = (NCNImageMessageCellModel *)model;
            message = [[TIMMessage alloc] init];
            TIMImageElem *imageElem = [[TIMImageElem alloc] init];
            imageElem.path = imageModel.path;
            
            [message addElem:imageElem];
            
        }
        
    }
    return message;
}

#pragma mark 屏幕旋转
- (void)enterLandscapeScreen {
    
    self.noneBtn.hidden = true;
//    [_inputController.view endEditing:true];
//    [self.superview addSubview:_inputController.view];
//    _inputController.view.frame = CGRectMake(0, kScreen_Height - 44, kScreen_Width, 44);
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    _inputController.view.hidden = true;
    [_inputController.inputBar resignFirstResponder];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.isLandscape = true;
    [self.tableView reloadData];
    self.tableView.backgroundColor = UIColor.clearColor;
    _inputController.delegate = nil;

}

- (void)enterPortraitScreen {
     
//    CGFloat inputHeight = TTextView_Height + kBottom_SafeHeight;
//
//    _inputController.view.frame = CGRectMake(0, self.frame.size.height - inputHeight, kScreen_Width, inputHeight);
//    [self addSubview:_inputController.view];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset(0);
        make.bottom.equalTo(self->_inputController.view.mas_top);
    }];
    self->_inputController.view.hidden = false;
    if (self.messages.count == 0) {
        self.noneBtn.hidden = false;
    }
    self.isLandscape = false;
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.tableView reloadData];
    _inputController.delegate = self;
    self.hidden = false;

    
}

- (void)startToEdit {
    
    self.inputController.view.hidden = false;
    [self.inputController.inputBar becomeFirstResponder];
}
- (void)stopToEdit {
    self.inputController.view.hidden = true;
       [self.inputController.view endEditing:true];
}


#pragma mark TInputControllerDelegate

- (void)inputController:(TUIInputController *)inputController didChangeHeight:(CGFloat)height {
    
    __weak typeof(self) ws = self;
       [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
           CGRect msgFrame = self.tableView.frame;
           msgFrame.size.height = ws.frame.size.height - height;
           self.tableView.frame = msgFrame;

           CGRect inputFrame = ws.inputController.view.frame;
           inputFrame.origin.y = msgFrame.origin.y + msgFrame.size.height;
           inputFrame.size.height = height;
           ws.inputController.view.frame = inputFrame;
           
           NSLog(@"%@,%@",self.tableView, self.inputController.view);
           [self scrollToMessageBottom];
           
       } completion:nil];
    
}
- (void)scrollToMessageBottom {
    
    if (self.messages.count > 1) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
    
}
- (void)inputController:(TUIInputController *)inputController didSendMessage:(NSString *)msg {
    
    [self sendMessageWithContent:msg];
    
}

- (void)inputController:(TUIInputController *)inputController onFaceKeyboardIsShow:(BOOL)isShow {
    
    if (self.faceKeyboardIsShowCallback) {
        self.faceKeyboardIsShowCallback(isShow);
    }
    
}

- (void)inputController:(TUIInputController *)inputController onPrepareSendPhotos:(NSArray<UIImage *> *)images {
    
    [self sendImageMessageWithImages:images];
}

#pragma mark tableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NCNMessageCellModel *message = self.messages[indexPath.row];
    if (message == nil) {
        return nil;
    }
    if (message.classForCoder == NCNTextMessageCellModel.class) {
        message.reuseIdentifier = NCN_IM_Cell_Reuse_Identifier_Text;
    } else if (message.classForCoder == NCNImageMessageCellModel.class) {
        message.reuseIdentifier = NCN_IM_Cell_Reuse_Identifier_Image;
    }
    NCNMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:message.reuseIdentifier forIndexPath:indexPath];
    cell.model = message;
    cell.style = self.isLandscape;
    kWeakSelf(self);
    cell.failedBtnClickCallback = ^(NCNMessageCell * _Nonnull cell, NCNMessageCellModel * _Nonnull model) {
        [weakself sendMessageWithCellModel:model];
    };
    cell.bubbleViewClickCallback = ^(NCNMessageCell * _Nonnull cell, NCNMessageCellModel * _Nonnull model) {
        [weakself presentImageWithCell:cell model:model];
    };
    cell.bubbleViewLongPressedCallback = ^(NCNMessageCell * _Nonnull cell, NCNMessageCellModel * _Nonnull model) {
        [weakself bubbleViewLongPressedWithCell:cell model:model];
    };
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NCNMessageCellModel *model = self.messages[indexPath.row];
    CGFloat height = model.contentSize.height + 20;
    
    return height;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.inputController reset];
    
}


#pragma mark message cell action
- (void)presentImageWithCell:(NCNMessageCell *)cell model:(NCNMessageCellModel *)model {
    
    if (model.classForCoder == NCNImageMessageCellModel.class) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:[(NCNImageMessageCellModel *)model path]];
        if (image) {
            NCNImageBrowserVC *vc = [NCNImageBrowserVC imageBrowserWithImage:image];
            [self.belongVC presentViewController:vc animated:true completion:nil];
        }
       
    }
    
    
}
- (void)bubbleViewLongPressedWithCell:(NCNMessageCell *)cell model:(NCNMessageCellModel *)model {

    self.currentLongPressModel = model;
    NSMutableArray *items = @[].mutableCopy;
    if (model.isSelf) {
        UIMenuItem *revokeItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeMessageAction)];
        [items addObject:revokeItem];
    }
    CGRect frame = [cell convertRect:cell.bounds fromView:self];
    frame.origin.y = fabsf(frame.origin.y) + (kScreen_Height - self.height);
    if (model.classForCoder == NCNTextMessageCellModel.class) {
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessageAction)];
        [items addObject:copyItem];
    }
    
    if (items.count > 0) {
        [self canBecomeFirstResponder];
        [UIMenuController.sharedMenuController setMenuItems:items];
        [[UIMenuController sharedMenuController] setTargetRect:frame inView:self.belongVC.view];
        [UIMenuController.sharedMenuController setMenuVisible:true];
    }

}

//- (BOOL)canBecomeFirstResponder {
//
//    return true;
//}
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//
//    if (action == @selector(copyMessageAction) || action == @selector(revokeMessageAction)) {
//        return true;
//    }
//    return false;
//}

- (void)copyMessageAction {
    
    if (self.currentLongPressModel.classForCoder == NCNTextMessageCellModel.class) {
        NCNTextMessageCellModel *textModel = (NCNTextMessageCellModel *)self.currentLongPressModel;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:textModel.content];
    }
    
}

- (void)revokeMessageAction {

    kWeakSelf(self);
    [self.messagequeue addOperationWithBlock:^{
        
        TIMMessage *message = weakself.currentLongPressModel.message;
        
        [weakself.groupConversation revokeMessage:message succ:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[weakself.messages indexOfObject:weakself.currentLongPressModel] inSection:0];
                [weakself.messages removeObjectAtIndex:indexPath.row];
                [weakself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            });
            
        } fail:^(int code, NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [YJProgressHUD showMessage:[NCNLivingHelper im_errorMsgWithCode:code defaultErrMsg:@"撤回失败！"] inView:weakself];
            });
        }];
    }];
    
    
}



- (TIMMessage *)lastMessage {
    
    return self.messages.firstObject.message;
}


#pragma mark lazy


- (DYButton *)noneBtn {
    
    if (!_noneBtn) {
        _noneBtn = [DYButton buttonWithType:UIButtonTypeCustom];
        [_noneBtn setDirection:1];
        [_noneBtn setImage:[NSBundle living_loadImageWithName:@"noneMessage@3x"]];
        [_noneBtn setTitle:@"暂时没有人发言" forState:UIControlStateNormal];
        _noneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_noneBtn setTextColor:YQDColor(152, 158, 180, 1)];
    }
    
    return  _noneBtn;
    
}

- (NSOperationQueue *)messagequeue {
    
    if (!_messagequeue) {
        _messagequeue = [[NSOperationQueue alloc] init];
        _messagequeue.name = @"ncn_im_message_handler";
        _messagequeue.maxConcurrentOperationCount = 1;
    }
    return _messagequeue;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
