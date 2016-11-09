//
//  MemberListModel.h
//  NGEagle
//
//  Created by Liang on 15/8/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

#import "UserModel.h"

@interface MemberListModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<User> *users;

@end



