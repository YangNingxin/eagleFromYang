//
//  BindPhoneViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "IndependentPassController.h"

@interface BindPhoneViewController ()

@end

@implementation BindPhoneViewController

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
        label.text = @"为了您的账户安全，请先验证您绑定的手机号";
    } else {
        label.text = @"为了给您提供更多的服务，和更好的保障您的账户安全，请您绑定手机号。我们将对您的手机号绝对保密。";
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    if (self.isForgetPassword) {
        _leftButton.hidden = NO;
        _titleLabel.text = @"验证手机";

    } else {
        _leftButton.hidden = YES;
        _titleLabel.text = @"绑定手机号";
    }
    self.view1.top += 70;
    self.view2.top += 70;
    self.nextButton.top += 70;
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    
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
        
        IndependentPassController *passVc = [[IndependentPassController alloc]
                                            initWithNibName:@"VerifyPassViewController" bundle:nil];
        passVc.phoneNumber = self.phoneText.text;
        passVc.code = self.codeText.text;
        passVc.isForgetPassword = self.isForgetPassword;
        passVc.isNumberSchool = self.isNumberSchool;
        [self.navigationController pushViewController:passVc animated:YES];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
