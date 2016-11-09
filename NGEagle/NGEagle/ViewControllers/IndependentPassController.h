//
//  IndependentPassController.h
//  NGEagle
//
//  Created by Liang on 15/8/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "VerifyPassViewController.h"

@interface IndependentPassController : VerifyPassViewController

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *code;

// 是否是忘记密码，默认为NO
@property (nonatomic) BOOL isForgetPassword;

/**
 *  是否是数字学校登的
 */
@property (nonatomic) BOOL isNumberSchool;

@end
