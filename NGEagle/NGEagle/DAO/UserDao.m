//
//  UserDao.m
//  NGEagle
//
//  Created by Liang on 15/8/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "UserDao.h"
#import "ChineseToPinyin.h"

#define kTableName @"EAGLE_USER"

@implementation UserDao

+ (void)createUser {
    
    NSString *sql = [NSString stringWithFormat:
                     @"create table if not exists %@ (uid text primary key, logo text, name text, telephone text, nick text, flag text);",
                     kTableName];
    BOOL ret = [[DBManager shareManager].database executeUpdate:sql];
    if (!ret) {
        NSLog(@"创建失败");
    }
}

+ (void)insertUser:(User *)user {
    
    NSString *sql = [NSString stringWithFormat:@"insert or replace into %@ values ('%@', '%@', '%@', '%@', '%@', '%d')",
                     kTableName, user.uid, user.logo, user.name, user.telephone, user.nick, user.friend_flag];
    BOOL ret = [[DBManager shareManager].database executeUpdate:sql];
    if (!ret) {
        NSLog(@"插入失败");
    }
}

+ (User *)selectUserByUid:(NSString *)uid {
    
    User *user = [[User alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where uid = '%@';",
                     kTableName, uid];
    FMResultSet *reslut = [[DBManager shareManager].database executeQuery:sql];
    if ([reslut next]) {
        
        user.uid = [reslut stringForColumn:@"uid"];
        user.logo = [reslut stringForColumn:@"logo"];
        user.name = [reslut stringForColumn:@"name"];
        user.telephone = [reslut stringForColumn:@"telephone"];
        user.nick = [reslut stringForColumn:@"nick"];
        
        NSString *nick_pinyin = [ChineseToPinyin pinyinFromChiniseString:user.nick];
        if (nick_pinyin) {
            user.nick_pinyin = nick_pinyin;
        } else {
            user.nick_pinyin = @"";
        }
        user.friend_flag = [reslut boolForColumn:@"flag"];
    }
    return user;
}

+ (NSMutableArray *)selectFriend {
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where flag = '%d';",
                     kTableName, 1];
    FMResultSet *reslut = [[DBManager shareManager].database executeQuery:sql];
    
    while ([reslut next]) {
        User *user = [[User alloc] init];

        user.uid = [reslut stringForColumn:@"uid"];
        user.logo = [reslut stringForColumn:@"logo"];
        user.name = [reslut stringForColumn:@"name"];
        user.telephone = [reslut stringForColumn:@"telephone"];
        user.nick = [reslut stringForColumn:@"nick"];
        
        NSString *nick_pinyin = [ChineseToPinyin pinyinFromChiniseString:user.nick];
        if (nick_pinyin) {
            user.nick_pinyin = nick_pinyin;
        } else {
            user.nick_pinyin = @"";
        }
        
        user.friend_flag = [reslut boolForColumn:@"flag"];
        
        [array addObject:user];
    }
    return array;
}

+ (void)deleteUserByID:(NSString *)uid {
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where uid = '%@';",
                     kTableName, uid];
    BOOL ret = [[DBManager shareManager].database executeUpdate:sql];
    if (!ret) {
        NSLog(@"删除失败");
    }
}

@end
