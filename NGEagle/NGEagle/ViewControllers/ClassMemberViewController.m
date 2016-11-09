//
//  ClassMemberViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/30.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ClassMemberViewController.h"
#import "MemberListCell.h"
#import "AddressDetailViewController.h"
#import "ChatViewController.h"

@interface ClassMemberViewController ()

@end

@implementation ClassMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
    }];
    
    [self.tableView.header beginRefreshing];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)getDataFromServer {
    
    [DataHelper getGroupUserByGroupId:self.group_id success:^(id responseObject) {
        
        self.memberListModel = responseObject;
//      self.descLabel.text = [NSString stringWithFormat:@"共有%ld成员", self.memberListModel.users.count];
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
        
        if (self.isCanChat) {
            [self showSendMessageView];
        }
        
    } fail:^(NSError *error) {
        
        [self.tableView.header endRefreshing];

    }];
}


/**
 *  显示发送消息view
 */
- (void)showSendMessageView {
    
    self.tableView.height -= 44;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:
                           CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    sendButton.backgroundColor = UIColorFromRGB(0x50c0bb);
    [sendButton setTitle:@"加入群聊" forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"icon_send_msg"] forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"icon_send_msg"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    sendButton.tag = 99;
    [self.view addSubview:sendButton];
}

- (void)sendButtonAction {
    
    if ([self.huanxin_id length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该群没有环信ID，暂时不能聊天" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSMutableDictionary *extDict = [NSMutableDictionary dictionary];
    [extDict setObject:@"" forKeyedSubscript:@"logo"];
    [extDict setObject:self.name forKeyedSubscript:@"nick"];
    [extDict setObject:[NSString stringWithFormat:@"%d", self.group_id] forKey:@"gid"];
    
    ChatViewController *chatController = [[ChatViewController alloc]
                                          initWithChatter:self.huanxin_id isGroup:YES];
    chatController.userInfoDict = extDict;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleLabel.text = @"成员列表";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    
    [self.chatButton setBackgroundImage:[UIImage imageNamed:@"button_course"] forState:UIControlStateNormal];

    [self.tableView registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memberListModel.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"cell";
    MemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    
    User *user = self.memberListModel.users[indexPath.row];
    
    cell.member = user;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellStyleValue1;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    User *user = self.memberListModel.users[indexPath.row];

    AddressDetailViewController *addressVc = [[AddressDetailViewController alloc] initWithNibName:@"AddressDetailViewController" bundle:nil];
    addressVc.user = user;
    addressVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressVc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chatButtonAction:(UIButton *)sender {
    
}
@end
