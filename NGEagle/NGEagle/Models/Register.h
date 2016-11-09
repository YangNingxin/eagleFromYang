//
//  Register.h
//  NGEagle
//
//  Created by Liang on 15/7/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Register : NSObject

/*
 * 1--教师，2--学生，3--家长
 */
@property (nonatomic, assign) int type;

/**
 *  验证码
 */
@property (nonatomic, strong) NSString *verifyCode;

/**
 *  密码
 */
@property (nonatomic, strong) NSString *password;

/**
 *  手机号
 */
@property (nonatomic, strong) NSString *telephone;

/**
 *  验证码
 */
@property (nonatomic, strong) NSString *code;

+ (Register *)shareManager;

@end
