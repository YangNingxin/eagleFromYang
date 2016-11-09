//
//  ModifyPassViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/13.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ModifyPassViewController.h"

@interface ModifyPassViewController ()

@end

@implementation ModifyPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemArray = @[ @"请输入旧密码",
                    @"请输入新密码",
                    @"请再次输入新密码" ];
    // Do any additional setup after loading the view from its nib.
}


- (void)configBaseUI {
    
    [super configBaseUI];
    _titleLabel.text = @"修改密码";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setTitle:@"完成" forState:UIControlStateNormal];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)rightButtonAction {
    
    NSString *strMsg = @"";
        
    NSString *oldPass = textField1.text;
    NSString *newPass1 = textField2.text;
    NSString *newPass2 = textField3.text;
    
    oldPass = [oldPass stringByReplacingOccurrencesOfString:@" " withString:@""];
    newPass1 = [newPass1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    newPass2 = [newPass2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([oldPass isEqualToString:@""]||[newPass1 isEqualToString:@""]||[newPass2 isEqualToString:@""]) {
        strMsg = @"密码不能为空！";
    }
    
    if ([newPass1 isEqualToString:newPass2] == NO) {
        strMsg = @"两次输入的新密码不一致！";
    }
    
    if ([newPass1 isEqualToString:newPass2]&&[newPass1 isEqualToString:oldPass]) {
        
        strMsg = @"亲，输入的新密码跟旧密码是一样的喔！";
    }
    
    if ([strMsg isEqualToString:@""]) {
        
        [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
        
        [DataHelper modifyPassWordWithOldPass:oldPass newPass:newPass1 success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                
                // 密码修改成功之后，要重新进行登录验证。
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(1)];
                
            } else {
                [SVProgressHUD showErrorWithStatus:model.error_msg];
            }
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:strMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return 2;
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
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
        textField.font = [UIFont systemFontOfSize:15.0];
        textField.backgroundColor = [UIColor clearColor];
        textField.tag = 100;
        [textField setSecureTextEntry:YES];
        [cell.contentView addSubview:textField];
        
        if (indexPath.section == 0) {
            textField1 = textField;
            textField.placeholder = _itemArray[0];

        } else {
            if (indexPath.row == 0) {
                textField2 = textField;
                textField.placeholder = _itemArray[1];

            } else
            {
                textField3 = textField;
                textField.placeholder = _itemArray[2];

            }
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
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
