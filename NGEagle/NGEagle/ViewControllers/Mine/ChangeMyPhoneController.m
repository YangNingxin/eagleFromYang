//
//  ChangeMyPhoneController.m
//  NGEagle
//
//  Created by Liang on 15/8/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ChangeMyPhoneController.h"

@interface ChangeMyPhoneController ()

@end

@implementation ChangeMyPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verfify_pass2"]];
    headImageView.top = 70;
    headImageView.left = SCREEN_WIDTH/2 - headImageView.width/2;
    [self.view addSubview:headImageView];
    
    
    self.view1.top += 100;
    self.view2.top += 100;
    self.nextButton.top += 100;
    // Do any additional setup after loading the view.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    _titleLabel.text = @"更换关联手机";
    [self.nextButton setTitle:@"完成" forState:UIControlStateNormal];

}

- (void)nextButtonAction:(UIButton *)sender {
    
    
    if (![PredicateUtil isMobileNumberClassification:self.phoneText.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机格式不正确"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (_telephone) {
        if (![_telephone isEqualToString:self.phoneText.text]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送验证码的手机号不一致"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
    }
    
    if (self.codeText.text.length != 0) {
     
        [SVProgressHUD showWithStatus:@"绑定..." maskType:SVProgressHUDMaskTypeClear];
        
        // 绑定手机号
        [DataHelper bindTelephoneWithVerifyCode:self.codeText.text telephone:self.phoneText.text pwd1:self.password pwd2:self.password ey:NO password_flag:YES success:^(id responseObject) {
            ErrorModel *model = responseObject;
            
            
            if (model.error_code == 0) {
                
                [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            } else {
                
                [SVProgressHUD dismiss];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:model.error_msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } fail:^(NSError *error) {
            
            [SVProgressHUD dismiss];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
