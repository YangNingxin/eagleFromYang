//
//  VerifyPassViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "VerifyPassViewController.h"
#import "Register.h"

@interface VerifyPassViewController ()

@end

@implementation VerifyPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    _titleLabel.text = @"用户密码(2/2)";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    
    self.finishButton.backgroundColor = kThemeColor;
    self.finishButton.layer.cornerRadius = 4.0;
    
    self.view1.top += 20;
    self.view2.top += 20;
    self.finishButton.top += 20;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.passText1 resignFirstResponder];
    [self.passText2 resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)finishAction:(UIButton *)sender {
    NSString *pass1 = self.passText1.text;
    NSString *pass2 = self.passText2.text;
    if (pass1 && pass1.length >0 && pass2 && pass2.length > 0&& [pass1 isEqualToString:pass2]) {
        
        [SVProgressHUD showWithStatus:@"注册..." maskType:SVProgressHUDMaskTypeClear];

        [DataHelper registerWithVerifyCode:[Register shareManager].code
                                 telephone:[Register shareManager].telephone
                                      type:[Register shareManager].type
                                       pwd:pass1
                                   success:^(id responseObject) {
                                       UserModel *model = responseObject;
                                       if (model.error_code == 0 && model.user && model.user.uid) {
                                           
                                           [Account shareManager].userModel = model;
                                           
                                           // 注册成功
                                           [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(2)];
                                           [[Account shareManager] setIsLogined:YES];
                                           
                                       } else {
                                           
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:model.error_msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                           [alert show];
                                       }
                                       [SVProgressHUD dismiss];

                                   }
                                      fail:^(NSError *error) {
                                          [SVProgressHUD dismiss];

                                      }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
