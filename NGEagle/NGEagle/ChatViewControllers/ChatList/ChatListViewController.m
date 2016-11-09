/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ChatListViewController.h"
#import "ChatListCell.h"
#import "NSDate+Category.h"
#import "ChatViewController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "NSDateUtil.h"

#import "UserDao.h"
#import "GroupDao.h"
#import "UserInfoModel.h"
#import "GroupInfoModel.h"

@interface ChatListViewController ()<IChatManagerDelegate,ChatViewControllerDelegate>

@end

@implementation ChatListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];

    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshDataSource];
    }];
    
    [self.tableView.header beginRefreshing];
    // 删除好友的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteConversation:) name:@"deleteConversation" object:nil];
}

- (void)deleteConversation:(NSNotification *)aNote {
    NSString *userName = [aNote object];
    
    for (int i = 0; i < self.dataSource.count; i++) {
        
        EMConversation *converation = [self.dataSource objectAtIndex:i];
        if ([converation.chatter isEqualToString:userName]) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
            [self.dataSource removeObjectAtIndex:i];
            
            [self.tableView reloadData];
            
            break;
        }
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshDataSource];
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

- (void)removeChatroomConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (conversation.conversationType == eConversationTypeChatRoom) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
           ^(EMConversation *obj1, EMConversation* obj2){
               EMMessage *message1 = [obj1 latestMessage];
               EMMessage *message2 = [obj2 latestMessage];
               if(message1.timestamp > message2.timestamp) {
                   return(NSComparisonResult)NSOrderedAscending;
               }else {
                   return(NSComparisonResult)NSOrderedDescending;
               }
           }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDateUtil formatDate:[NSDate dateWithTimeIntervalInMilliSecondSince1970:lastMessage.timestamp]];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 计算系统消息
- (NSString *)subSystemTitleMessageByConversation:(EMConversation *)conversation {
    
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        NSString *content = ((EMTextMessageBody *)messageBody).text;
        NSDictionary *dict = [CCJsonKit getObjectFromJsonString:content];
        ret = dict[@"msg_content"];
    }

    return ret;
}


// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                
                ret = didReceiveText;
                
            } break;
            case eMessageBodyType_Voice:{
                ret = @"[语音]";
            } break;
            case eMessageBodyType_Location: {
                ret = @"[位置]";
            } break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    

    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    // 单聊
    if (conversation.conversationType == eConversationTypeChat) {
        
        // 系统消息
        if ([conversation.chatter isEqualToString:HXSystemAccount]) {
            
            cell.placeholderImage = [UIImage imageNamed:@"system_icon"];
            cell.name = @"[系统消息]";
            cell.detailMsg = [self subSystemTitleMessageByConversation:conversation];
            
        } else {
            
            NSDictionary *extDict = conversation.ext;
            
            cell.placeholderImage = [UIImage imageNamed:@"default_head"];
            cell.name = conversation.chatter;
            
            if ([extDict objectForKey:@"logo"]) {
                cell.imageURL = [NSURL URLWithString:extDict[@"logo"]];
                cell.name = extDict[@"nick"];
            } else {
                [self setUserInfoByUid:conversation cell:cell];
            }
            
            cell.detailMsg = [self subTitleMessageByConversation:conversation];

        }
        
    } else {
        
        NSDictionary *extDict = conversation.ext;
        
        cell.placeholderImage = [UIImage imageNamed:@"icon_group_chat"];
        cell.name = conversation.chatter;
        
        if (extDict) {
            cell.imageURL = [NSURL URLWithString:extDict[@"logo"]];
            cell.name = extDict[@"nick"];
        } else {
            [self setGroupInfoByGid:conversation cell:cell];
        }
        
        cell.detailMsg = [self subTitleMessageByConversation:conversation];

    }
    
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
    if (indexPath.row % 2 == 1) {
        cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}


/**
 *  设置用户
 *
 *  @param conversation
 *  @param cell
 */
- (void)setUserInfoByUid:(EMConversation *)conversation cell:(ChatListCell *)cell{
    
    NSMutableDictionary *extDict;
    
    if (!conversation.ext) {
        extDict = [NSMutableDictionary dictionary];
    } else {
        extDict = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
    }
    
    NSString *uid = conversation.chatter;
    
    [[DBManager shareManager] openDataBase];
    [UserDao createUser];
    
    // 去数据库中取数据
    User *user = [UserDao selectUserByUid:uid];
    if (user.uid.length > 0) {
        
        cell.imageURL = [NSURL URLWithString:user.logo];
        cell.name = user.nick;
        
        [extDict setObject:user.logo forKey:@"logo"];
        [extDict setObject:user.nick forKey:@"nick"];
        
        conversation.ext = extDict;
        
    } else {
        
        [ChatDataHelper getUserInfoByUid:uid success:^(id responseObject) {
            UserInfoModel *infoModel = responseObject;
            if (infoModel.error_code == 0) {
                if (infoModel.user.uid) {
                    
                    [UserDao insertUser:infoModel.user];
                    
                    cell.imageURL = [NSURL URLWithString:infoModel.user.logo];
                    cell.name = infoModel.user.nick;
                    
                    [extDict setObject:infoModel.user.logo forKey:@"logo"];
                    [extDict setObject:infoModel.user.nick forKey:@"nick"];
                    
                    conversation.ext = extDict;
                }
            }

        } fail:^(NSError *error) {
            
        }];
    }
    
    
}

- (void)setGroupInfoByGid:(EMConversation *)conversation cell:(ChatListCell *)cell {
    
    NSString *gid = conversation.latestMessage.ext[@"gid"];
    if (!gid) {
        return;
    }

    NSMutableDictionary *extDict;
    
    if (!conversation.ext) {
        extDict = [NSMutableDictionary dictionary];
    } else {
        extDict = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
    }
    [[DBManager shareManager] openDataBase];
    [GroupDao createGroup];
    
    // 去数据库中取数据
    GroupInfo *group = [GroupDao selectGroupInfoByGid:gid];
    if (group.gid) {
        
        cell.imageURL = [NSURL URLWithString:group.logo];
        cell.name = group.name;
        
        [extDict setObject:group.logo forKey:@"logo"];
        [extDict setObject:group.name forKey:@"nick"];
        
        conversation.ext = extDict;
        
    } else {
        
        [ChatDataHelper getGroupInfoById:gid success:^(id responseObject) {
            GroupInfoModel *infoModel = responseObject;
            if (infoModel.error_code == 0) {
                if (infoModel.data.gid.length > 0) {
                    
                    [GroupDao insertGroup:infoModel.data];
                    
                    cell.imageURL = [NSURL URLWithString:infoModel.data.logo];
                    cell.name = infoModel.data.name;
                    
                    [extDict setObject:infoModel.data.logo forKey:@"logo"];
                    [extDict setObject:infoModel.data.name forKey:@"nick"];
                    
                    conversation.ext = extDict;
                }
            }
        } fail:^(NSError *error) {
            
        }];
    }
    
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    
    NSString *chatter = conversation.chatter;
    chatController = [[ChatViewController alloc] initWithChatter:chatter conversationType:conversation.conversationType];
    chatController.delelgate = self;
    chatController.userInfoDict = conversation.ext;
    chatController.isSystemMsg = [conversation.chatter isEqualToString:HXSystemAccount];
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

- (void)didReceiveMessage:(EMMessage *)message {
    NSLog(@"message is %@", message.messageBodies);
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public

-(void)refreshDataSource
{
    [[Account shareManager] getUnReadMessageNumber];

    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
    [self.tableView.header endRefreshing];
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}

#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
//    return @"http://img0.bdstatic.com/img/image/shouye/jianbihua0525.jpg";
    return nil;
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    return chatter;
}

@end
