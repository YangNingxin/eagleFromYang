//
//  SetViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SetViewController.h"
#import "ModifyPassViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // @"非wifi下是否自动播放课程"
    _itemArray = @[ @"修改密码",
                    @"清空聊天记录" ];
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本：%@", APP_VERSION];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *loginOutBtn = [UIButton new];
    loginOutBtn.backgroundColor = [UIColor redColor];
    loginOutBtn.layer.cornerRadius = 4.0;
    loginOutBtn.layer.masksToBounds = YES;
    loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [loginOutBtn addTarget:self action:@selector(loginOutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginOutBtn];
    
    [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(35);
        make.bottom.mas_offset(-40);
    }];
}

- (void)loginOutBtnAction {
    [self rightButtonAction];
}

- (void)configBaseUI {
    
    [super configBaseUI];
    _titleLabel.text = @"系统设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)rightButtonAction {
    [SVProgressHUD showWithStatus:@"正在退出..." maskType:SVProgressHUDMaskTypeClear];
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        
        if (!error) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(1)];
            [SVProgressHUD showSuccessWithStatus:@"成功退出"];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"退出失败，请重试"];
        }
        
    } onQueue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idfa = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfa];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfa];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = _itemArray[indexPath.row];
        label.tag = 100;
        [cell.contentView addSubview:label];
        
//        if (indexPath.row == 0) {
//            
//            UISwitch *wifiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 5, 50, 30)];
//            wifiSwitch.tag = 101;
//            [cell.contentView addSubview:wifiSwitch];
//            
//        } else
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellStyleValue1;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        ModifyPassViewController *modifyVc = [[ModifyPassViewController alloc] initWithNibName:@"ModifyPassViewController" bundle:nil];
        [self.navigationController pushViewController:modifyVc animated:YES];
        
    } else if (indexPath.row == 1) {
        
        [SVProgressHUD showWithStatus:@"清空..." maskType:SVProgressHUDMaskTypeClear];
        // 清空聊天记录
        [[EaseMob sharedInstance].chatManager removeAllConversationsWithDeleteMessages:YES append2Chat:YES];
        [SVProgressHUD showSuccessWithStatus:@"清除成功"];
        
    }
   
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
