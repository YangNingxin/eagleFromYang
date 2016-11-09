//
//  AddressDetailViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "StringSizeUtil.h"
#import "HeadCell.h"
#import "TwoLabelCell.h"
#import "ChatViewController.h"

@interface AddressDetailViewController ()

@end

@implementation AddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadCell" bundle:nil] forCellReuseIdentifier:@"HeadCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell" bundle:nil] forCellReuseIdentifier:@"TwoLabelCell"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
    }];
    [self.tableView.header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"个人资料";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

/**
 *  显示添加好友的button
 */
- (void)showAddFriendView {
    UIButton *addButton = [[UIButton alloc] initWithFrame:
                           CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    addButton.backgroundColor = UIColorFromRGB(0x50c0bb);
    [addButton setTitle:@"添加好友" forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"icon_add_friend"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"icon_add_friend"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = 99;
    [self.view addSubview:addButton];
}

- (void)showFriendView {
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, SCREEN_HEIGHT-44, SCREEN_WIDTH/2, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        switch (i) {
            case 0:
                button.backgroundColor = UIColorFromRGB(0xee6267);
                [button setTitle:@"删除好友" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_delete_friend"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_delete_friend"] forState:UIControlStateHighlighted];

                break;
            case 1:
                button.backgroundColor = UIColorFromRGB(0x50c0bb);
                [button setImage:[UIImage imageNamed:@"icon_send_msg"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_send_msg"] forState:UIControlStateHighlighted];

                [button setTitle:@"发送消息" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)button {
    
    if (button.tag == 100) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    } else {
        
        NSMutableDictionary *extDict = [NSMutableDictionary dictionary];
        [extDict setObject:self.user.logo forKeyedSubscript:@"logo"];
        [extDict setObject:self.user.nick forKeyedSubscript:@"nick"];
        
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:self.user.uid isGroup:NO];
        chatController.userInfoDict = extDict;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark
#pragma mark UIAlertViewDelegete

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"正在删除" maskType:SVProgressHUDMaskTypeClear];
        [ChatDataHelper delFriend:self.user.uid success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriendListNote" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteConversation" object:self.user.uid];
                
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showSuccessWithStatus:model.error_msg];
            }
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }];
    }
}

/**
 *  添加好友事件
 */
- (void)addButtonAction {
    [SVProgressHUD showWithStatus:@"发送请求..." maskType:SVProgressHUDMaskTypeClear];
    
    [ChatDataHelper addFriend:self.user.uid success:^(id responseObject) {
        ErrorModel *model = responseObject;
        if (model.error_code == 0) {
            [SVProgressHUD showSuccessWithStatus:@"请求已发出"];
        } else {
            [SVProgressHUD showErrorWithStatus:model.error_msg];
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求发送失败"];
    }];
}

- (void)getDataFromServer {
    
    [ChatDataHelper getUserInfoByUid:self.user.uid success:^(id responseObject) {
        UserInfoModel *userInfoModel = responseObject;
        if (userInfoModel.error_code == 0 && userInfoModel.user) {
            
            for (int i = 99; i < 3; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:i];
                [button removeFromSuperview];
                button = nil;
            }
            
            self.user = userInfoModel.user;
            [self.tableView reloadData];
            
            if (![self.user.uid isEqualToString:[Account shareManager].userModel.user.uid]) {
                if (self.user.friend_flag) {
                    [self showFriendView];
                } else {
                    [self showAddFriendView];
                }
            }
        }
        
        [self.tableView.header endRefreshing];
        
    } fail:^(NSError *error) {
        [self.tableView.header endRefreshing];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else if (indexPath.section == 1) {
        return 44;
    } else {
        CGFloat height = [StringSizeUtil getContentSizeHeight:self.user.intro
                                                         font:[UIFont systemFontOfSize:15.0]
                                                        width:SCREEN_WIDTH-130];
        if (height <= 20) {
            height = 44;
        } else {
            height += 20;
        }
        return height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell" forIndexPath:indexPath];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:self.user.logo]];
        cell.nameLabel.text = self.user.nick;
        cell.sexLabel.text = [NSString stringWithFormat:@"%@  %d岁", self.user.sexName, self.user.age];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        TwoLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell" forIndexPath:indexPath];
        cell.valueLabel.numberOfLines = 0;
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                    cell.keyLabel.text = @"个人账号";
                    cell.valueLabel.text = self.user.uid;
                    break;
                case 1:
                    cell.keyLabel.text = @"所在学校";
                    cell.valueLabel.text = self.user.schoolToString;
                    break;
                case 2:
                    cell.keyLabel.text = @"兴趣爱好";
                    cell.valueLabel.text = self.user.interesting;
                    break;
               
                default:
                    break;
            }
           
        } else {
            cell.keyLabel.text = @"个人简介";
            cell.valueLabel.text = self.user.intro;
            [cell.valueLabel sizeToFit];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
