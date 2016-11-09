//
//  FriendListModel.h
//  NGEagle
//
//  Created by Liang on 15/8/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "UserModel.h"

@interface FriendListModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<User> *data;

@end
