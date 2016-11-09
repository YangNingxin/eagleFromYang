//
//  CLoginViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CLoginViewController.h"
#import "SelectSchoolViewController.h"
#import "UserModel.h"
#import "TMCache.h"
#import "BindPhoneViewController.h"
#import "UserDao.h"
#import "WebViewController.h"
#import "XZLoginViewController.h"
#import "AppDelegate.h"

@interface CLoginViewController () <UIActionSheetDelegate>

@end

@implementation CLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isAgree = YES;
    
    self.userTextField.placeholder = @"请输入手机号";
    self.passTextField.placeholder = @"请输入密码";
    
    /*
    if (self.type == 1) {
       
    } else {
     
        self.userTextField.placeholder = @"请输入教育ID";
        self.passTextField.placeholder = @"请输入密码";
        
        self.forgetPassButton.hidden = YES;
        self.otherImageView.hidden = YES;
        self.backBtn.hidden = NO;
        
        for (int i = 0; i < 10; i++) {
            [self.view viewWithTag:300+i].hidden = YES;
        }
        
        [DataHelper getHotLoginNode:^(id responseObject) {
            _hotSchoolModel = responseObject;
            
            @try {
                SchoolInfo *info = _hotSchoolModel.data[0];
                [Account shareManager].node_id = info.node_id;
                [Account shareManager].node_name = info.name;
                [self.selectSchoolButton setTitle:[Account shareManager].node_name forState:UIControlStateNormal];

            }
            @catch (NSException *exception) {
                
            }
            
        } fail:^(NSError *error) {
            
        }];
    }*/
    if (iPhone4) {
        [self.view viewWithTag:100].top -= 50;
    }
    
    [self showShuzixuexiaoLoginButton:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.userTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    if ([Account shareManager].schoolInfo.node_id) {
        [self.selectSchoolButton setTitle:[Account shareManager].schoolInfo.name forState:UIControlStateNormal];
    } else {
        [self.selectSchoolButton setTitle:@"登录节点" forState:UIControlStateNormal];
    }
//    if (self.type == 1) {
//        if (APPDELEGATE.bootModel.other_login.count > 0) {
//            OtherLogin *otherLogin = APPDELEGATE.bootModel.other_login[0];
//            if ([otherLogin.channel isEqualToString:NS_Channel]) {
//                [self showShuzixuexiaoLoginButton:YES];
//            }
//        }
//    }
}

- (void)showShuzixuexiaoLoginButton:(BOOL)flag {
    
    [self.view viewWithTag:300].hidden = !flag;
    [self.view viewWithTag:303].hidden = !flag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lostFirstFources {
    [self.userTextField resignFirstResponder];
    [self.passTextField resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self lostFirstFources];
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)forgetPasswordAction:(UIButton *)sender {
    BindPhoneViewController *bindPhoneVc = [[BindPhoneViewController alloc] initWithNibName:@"VerifyCodeViewController" bundle:nil];
    bindPhoneVc.isForgetPassword = YES;
    bindPhoneVc.register_flag = NO;
    [self.navigationController pushViewController:bindPhoneVc animated:YES];
}

- (IBAction)selectSchoolAction:(UIButton *)sender {
    SelectSchoolViewController *selectVc = [[SelectSchoolViewController alloc] initWithNibName:@"SelectSchoolViewController" bundle:nil];
    [self.navigationController pushViewController:selectVc animated:YES];
}

- (IBAction)loginAction:(UIButton *)sender {
    
    if (![Account shareManager].schoolInfo.node_id) {
        [self.view makeToast:@"请选择登录节点！" duration:1.2 position:@"center"];
        return;
    }
    
    NSString *username = self.userTextField.text;
    NSString *password = self.passTextField.text;
    
    if (username && username.length != 0 && password && password.length != 0) {
        username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        [self.view makeToast:@"手机号和密码不能为空！" duration:1.2 position:@"center"];
        return;
    }
    
    [self lostFirstFources];

    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];

    [DataHelper loginByNode:[Account shareManager].schoolInfo.node_id username:username password:password ey:NO success:^(id responseObject) {
        [self loginSuccessWithResponseObject:responseObject];
        
    } fail:^(NSError *error) {
        [self loginFail:error];
    }];
    
    /*
    if (self.type == 0) {
        
    } else {
        [DataHelper loginByTypeAndId:@"telephone" username:username password:password ey:NO success:^(id responseObject) {
            [self loginSuccessWithResponseObject:responseObject];
        } fail:^(NSError *error) {
            [self loginFail:error];
        }];
    }
    */
}


- (void)loginSuccessWithResponseObject:(id)responseObject {
    
    UserModel *userModel = responseObject;
    
    [SVProgressHUD dismiss];
    
    if (userModel && userModel.error_code == 0 && userModel.user && userModel.user.uid) {
        
        // 保存登录信息
        userModel.user.login_type = self.type;
        userModel.user.username = self.userTextField.text;
        userModel.user.password = self.passTextField.text;
        
        // 把登录用户存入数据库
        [[DBManager shareManager] openDataBase];
        [UserDao createUser];
        [UserDao insertUser:userModel.user];
        
        // 通过Account账号单例，存储登录信息
        [Account shareManager].userModel = userModel;
        
        // 缓存登录信息到本地，加密过的
        [[TMCache sharedCache] setObject:userModel forKey:@"userModel"];
        
        NSString *newId = [NSString stringWithFormat:@"%@_%@", [Account shareManager].schoolInfo.node_id,userModel.user.uid];
        
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:newId password:HXDefaultPassword completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error && loginInfo) {

                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];

                EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                [options setDisplayStyle:ePushNotificationDisplayStyle_messageSummary];
                [options setNickname:userModel.user.nick];
                [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
                
                NSLog(@"环信=====================登陆成功");
            }
        } onQueue:nil];
        
        if (userModel.user.telephone.length > 0) {
            
            // 登录成功
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(0)];

            // 标记登录成功
            [[Account shareManager] setIsLogined:YES];
            
        } else {
            BindPhoneViewController *bindPhoneVc = [[BindPhoneViewController alloc] initWithNibName:@"VerifyCodeViewController" bundle:nil];
            bindPhoneVc.register_flag = YES;
            [self.navigationController pushViewController:bindPhoneVc animated:YES];
        }
        
    } else {
        
        // 登录失败
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                        message:userModel.error_msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)loginFail:(NSError *)error{
    
    [SVProgressHUD dismiss];
    // 登录失败
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                    message:@"请检查您的网络连接。"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)agreeELUAAction:(UIButton *)sender{
    
    if (isAgree == YES) {
        
        [sender setImage:[UIImage imageNamed:@"un_select_agree"] forState:UIControlStateNormal];
        self.loginBtn.enabled = NO;
        isAgree = NO;
        
    }else {
        
        [sender setImage:[UIImage imageNamed:@"select_agree"] forState:UIControlStateNormal];
        self.loginBtn.enabled = YES;
        isAgree = YES;
    }
}


- (IBAction)enterELUAAction:(UIButton *)sender{
    
    WebViewController *webVc = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    webVc.webTitle = @"使用和隐私条款";
    webVc.url = [NSString stringWithFormat:@"%@/public/yonghuxieyi.html",API_SERVER];
    [self.navigationController pushViewController:webVc animated:YES];
}


#pragma mark
#pragma mark otherLoginButot

- (IBAction)otherLoginButotnAction:(UIButton *)button {
    if (button.tag == 300) {
        
        XZLoginViewController *loginVc = [[XZLoginViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        loginVc.otherLogin = APPDELEGATE.bootModel.other_login[0];
        [self.navigationController pushViewController:loginVc animated:YES];
        
    } else if (button.tag == 301) {
        CLoginViewController *loginVc = [[CLoginViewController alloc] initWithNibName:@"CLoginViewController" bundle:nil];
        loginVc.type = 0;
        [self.navigationController pushViewController:loginVc animated:YES];
    } else {
        
        UIActionSheet *sheet = [[UIActionSheet alloc]
                                initWithTitle:@"请选择您要注册的用户类型"
                                delegate:self
                                cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"我要成为老师", @"我要成为学生", @"我要成为家长", nil];
        [sheet showInView:self.view];
    }
}

#pragma mark
#pragma mark ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 3) {
        return;
    }
    switch (buttonIndex) {
        case 0:
             [Register shareManager].type = 1;
            break;
        case 1:
            [Register shareManager].type = 2;
            break;
        case 2:
            [Register shareManager].type = 3;
        default:
            break;
    }
//    if (buttonIndex == 0) { // 注册学生
//        [Register shareManager].type = 2;
//    } else { // 注册老师
//        [Register shareManager].type = 1;
//    }
    VerifyCodeViewController *verifyVc = [[VerifyCodeViewController alloc] initWithNibName:@"VerifyCodeViewController" bundle:nil];
    verifyVc.register_flag = YES;
    [self.navigationController pushViewController:verifyVc animated:YES];
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
