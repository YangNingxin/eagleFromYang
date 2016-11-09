//
//  CLoginViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolModel.h"

@interface CLoginViewController : UIViewController
{
    SchoolModel *_hotSchoolModel;
    BOOL isAgree;
}

/**
 *  type如果是0，为教育id登录
 *  type如果是1，为手机号登录
 */
@property (nonatomic, assign) int type;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectSchoolButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectSchoolImageView;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassButton;

- (IBAction)forgetPasswordAction:(UIButton *)sender;
- (IBAction)selectSchoolAction:(UIButton *)sender;
- (IBAction)backAction:(UIButton *)sender;
- (IBAction)loginAction:(UIButton *)sender;

@property (nonatomic, weak) IBOutlet UIButton *loginBtn;
- (IBAction)agreeELUAAction:(UIButton *)sender;
- (IBAction)enterELUAAction:(UIButton *)sender;

@property (nonatomic, weak) IBOutlet UIButton *backBtn;

// 其他登录方式图片
@property (nonatomic, weak) IBOutlet UIImageView *otherImageView;
- (IBAction)otherLoginButotnAction:(UIButton *)button;

- (void)showShuzixuexiaoLoginButton:(BOOL)flag;

@end
