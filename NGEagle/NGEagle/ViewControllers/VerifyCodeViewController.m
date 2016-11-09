//
//  VerifyCodeViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "VerifyCodeViewController.h"
#import "VerifyPassViewController.h"
#import "SelectSchoolViewController.h"


static const int max = 60;

@interface VerifyCodeViewController () <UITextFieldDelegate>

@end

@implementation VerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    _titleLabel.text = @"验证信息(1/2)";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    
    self.codeButton.backgroundColor = kThemeColor;
    self.codeButton.layer.cornerRadius = 4.0;
    
    self.nextButton.backgroundColor = kThemeColor;
    self.nextButton.layer.cornerRadius = 4.0;
    
    self.view1.top += 20;
    self.view2.top += 20;
    self.nextButton.top += 20;
    
    // 如果是注册的话，加入选择学校
    if (self.register_flag) {
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 83, SCREEN_WIDTH, 40)];
        tempView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:tempView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        imageView.image = [UIImage imageNamed:@"school_node_flag"];
        imageView.contentMode = UIViewContentModeCenter;
        [tempView addSubview:imageView];
        
        _schoolText = [[UITextField alloc] initWithFrame:CGRectMake(55, 5, 244, 30)];
        _schoolText.placeholder = @"请选择注册节点";
        _schoolText.delegate = self;
        _schoolText.font = [UIFont systemFontOfSize:14.0];
        [tempView addSubview:_schoolText];
        
        self.view1.top += 40;
        self.view2.top += 40;
        self.nextButton.top += 40;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    SelectSchoolViewController *selectVc = [[SelectSchoolViewController alloc] initWithNibName:@"SelectSchoolViewController" bundle:nil];
    [self.navigationController pushViewController:selectVc animated:YES];

    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_schoolText) {
        if ([Account shareManager].schoolInfo.node_id) {
            _schoolText.text = [Account shareManager].schoolInfo.name;
        }
    }
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    
    if (self.register_flag) {
        if (_schoolText.text.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择注册节点！"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
    }
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
        
        [Register shareManager].telephone = self.phoneText.text;
        [Register shareManager].code = self.codeText.text;
        
        
        VerifyPassViewController *passVc = [[VerifyPassViewController alloc]
                                            initWithNibName:@"VerifyPassViewController" bundle:nil];
        [self.navigationController pushViewController:passVc animated:YES];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)codeButtonAction:(UIButton *)sender {
    
    if ([PredicateUtil isMobileNumberClassification:self.phoneText.text]) {
        
        _telephone = self.phoneText.text;
        
        [SVProgressHUD showWithStatus:@"正在发送验证码" maskType:SVProgressHUDMaskTypeClear];
        
        [DataHelper getVerifyCode:self.phoneText.text register_flag:self.register_flag success:^(id responseObject) {
            
            ErrorModel *errorModle = responseObject;
            
            if (errorModle.error_code == 0) {
                
                [self initTimer];
                [self.view makeToast:@"验证码已发送，请耐心等待。" duration:1.2 position:@"center"];
                self.codeButton.enabled = NO;

            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorModle.error_msg  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            [SVProgressHUD dismiss];
            
        } fail:^(NSError *error) {
            
            [SVProgressHUD dismiss];

        }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.phoneText resignFirstResponder];
    [self.codeText resignFirstResponder];
}

- (void)initTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction {
    
    second ++;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%d秒", max -second] forState:UIControlStateNormal];
    
    if(second >= max) {
        
        self.codeText.enabled = YES;
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
