//
//  RegisterApiMacro.h
//  NGEagle
//
//  Created by Liang on 15/9/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

//########################### *******签到相关******** ###########################

// 获取签到列表
#define kApiGetRegistrationList @"/index.php?app=interface&mod=Registration&act=getRegistrationList"

// 获取签到的用户列表
#define kApiGetRegistrationUserList @"/index.php?app=interface&mod=Registration&act=getRegistrationUserList"

// 创建签到
#define kApiCreateRegistration @"/index.php?app=interface&mod=Registration&act=create"

// 创建签到，并且是把人状态设置好好，一次性提交
#define kApiRegisterRegistration @"/index.php?app=interface&mod=Registration&act=register"

//// 根据签到对象id签到
//#define kApiEditRegister @"/index.php?app=interface&mod=Registration&act=registerWithId"

// 更新签到
#define kApiUpdateRegister @"/index.php?app=interface&mod=Registration&act=updateRegister"