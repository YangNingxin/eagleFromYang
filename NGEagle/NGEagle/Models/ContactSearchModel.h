//
//  ContactSearchModel.h
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "GroupInfoModel.h"
#import "UserModel.h"

@interface ContactSearchModel : ErrorModel

@property (nonatomic, strong) NSArray <GroupInfo> *groups;
@property (nonatomic, strong) NSArray <User> *friends;

@end
