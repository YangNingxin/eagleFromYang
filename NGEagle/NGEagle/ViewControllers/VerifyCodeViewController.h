//
//  VerifyCodeViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "PredicateUtil.h"
#import "Register.h"

@interface VerifyCodeViewController : BaseViewController {
    int second;
    NSString *_telephone;
    UITextField *_schoolText;
}

// 是否需要检验手机号
@property (nonatomic) BOOL register_flag;

@property (nonatomic, strong) NSTimer *timer;


@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

- (IBAction)nextButtonAction:(UIButton *)sender;
- (IBAction)codeButtonAction:(UIButton *)sender;

@end
