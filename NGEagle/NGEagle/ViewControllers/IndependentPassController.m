//
//  IndependentPassController.m
//  NGEagle
//
//  Created by Liang on 15/8/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "IndependentPassController.h"
#import "TMCache.h"

@interface IndependentPassController ()

@end

@implementation IndependentPassController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeadView];

    // Do any additional setup after loading the view.
}

- (void)initHeadView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 70)];
    headView.backgroundColor = kThemeColor;
    [self.view addSubview:headView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 50)];
    label.font = [UIFont systemFontOfSize:12.0];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    [headView addSubview:label];
    
    if (self.isForgetPassword) {
        label.text = @"重置密码";
        
        _titleLabel.text = @"重置密码";

    } else {
        _titleLabel.text = @"设置独立密码";

        label.text = @"设置独立密码用于手机号登录";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    self.view1.top += 70;
    self.view2.top += 70;
    self.finishButton.top += 70;
}

- (IBAction)finishAction:(UIButton *)sender {
    NSString *pass1 = self.passText1.text;
    NSString *pass2 = self.passText2.text;
    if (pass1 && pass1.length >0 && pass2 && pass2.length > 0&& [pass1 isEqualToString:pass2]) {
        
        [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
        
        // 忘记密码
        if (self.isForgetPassword) {
            [DataHelper resetPwdWithVerifyCode:self.phoneNumber pwd1:pass1 pwd2:pass2 code:self.code ey:NO success:^(id responseObject) {
                
                ErrorModel *model = responseObject;
                
                if (model.error_code == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"重置成功"];
                    NSArray *viewControllers = self.navigationController.viewControllers;
                    if (viewControllers.count > 1) {
                        [self.navigationController popToViewController:viewControllers[1] animated:YES];
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:model.error_msg];
                }
                
            } fail:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"重置失败"];

            }];
            
        } else {
            
            // 绑定手机号
            [DataHelper bindTelephoneWithVerifyCode:self.code telephone:self.phoneNumber pwd1:pass1 pwd2:pass2 ey:NO password_flag:YES success:^(id responseObject) {
                ErrorModel *model = responseObject;
                
                [SVProgressHUD dismiss];
                
                if (model.error_code == 0) {
                    
                    //************************************* 如果是数字学校用户，记住手机号和密码 ****************************
                    if (self.isNumberSchool) {
                        
                        [Account shareManager].userModel.user.login_type = 1;
                        [Account shareManager].userModel.user.username = self.phoneNumber;
                        [Account shareManager].userModel.user.password = self.passText1.text;
                        
                        [[TMCache sharedCache] setObject:[Account shareManager].userModel forKey:@"userModel"];
                    }
                    
                    // 绑定手机成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(0)];
                    [[Account shareManager] setIsLogined:YES];
                    
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:model.error_msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } fail:^(NSError *error) {
                
                [SVProgressHUD dismiss];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }
      
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
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
