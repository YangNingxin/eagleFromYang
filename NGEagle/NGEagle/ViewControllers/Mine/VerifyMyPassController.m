//
//  VerifyMyPassController.m
//  NGEagle
//
//  Created by Liang on 15/8/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "VerifyMyPassController.h"
#import "ChangeMyPhoneController.h"

@interface VerifyMyPassController ()

@end

@implementation VerifyMyPassController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verfify_pass1"]];
    headImageView.top = 70;
    headImageView.left = SCREEN_WIDTH/2 - headImageView.width/2;
    [self.view addSubview:headImageView];
    
    self.view1.hidden = YES;
    self.view2.top += 90;
    self.finishButton.top += 90;
    self.passText2.placeholder = @"请输入您的密码";
    
    // Do any additional setup after loading the view.
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"更换关联手机";
    [self.finishButton setTitle:@"下一步" forState:UIControlStateNormal];
}

- (IBAction)finishAction:(UIButton *)sender {
    
    if (self.passText2.text > 0) {
        
        [SVProgressHUD showWithStatus:@"验证密码..." maskType:SVProgressHUDMaskTypeClear];
        [DataHelper checkPassword:self.passText2.text success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                
                [SVProgressHUD dismiss];
                
                ChangeMyPhoneController *changeVc = [[ChangeMyPhoneController alloc] initWithNibName:@"VerifyCodeViewController" bundle:nil];
                changeVc.password = self.passText2.text;
                [self.navigationController pushViewController:changeVc animated:YES];
                
            } else {
                [SVProgressHUD showErrorWithStatus:model.error_msg];
            }
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
        
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
