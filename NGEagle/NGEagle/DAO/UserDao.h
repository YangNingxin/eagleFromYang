//
//  UserDao.h
//  NGEagle
//
//  Created by Liang on 15/8/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface UserDao : NSObject

+ (void)createUser;

+ (void)insertUser:(User *)user;

+ (User *)selectUserByUid:(NSString *)uid;

+ (NSMutableArray *)selectFriend;

+ (void)deleteUserByID:(NSString *)uid;

@end
