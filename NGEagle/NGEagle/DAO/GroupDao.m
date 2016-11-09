//
//  GroupDao.m
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "GroupDao.h"

#define kTableName @"EAGLE_GROUP"

@implementation GroupDao


+ (void)createGroup {
    
    NSString *sql = [NSString stringWithFormat:
                     @"create table if not exists %@ (gid text primary key, logo text, name text, huanxin_id text);",
                     kTableName];
    BOOL ret = [[DBManager shareManager].database executeUpdate:sql];
    if (!ret) {
        NSLog(@"创建失败");
    }
}

+ (void)insertGroup:(GroupInfo *)group {
    
    NSString *sql = [NSString stringWithFormat:@"insert or replace into %@ values ('%@', '%@', '%@', '%@')",
                     kTableName, group.gid, group.logo, group.name, group.huanxin_id];
    BOOL ret = [[DBManager shareManager].database executeUpdate:sql];
    if (!ret) {
        NSLog(@"插入失败");
    }
}

+ (GroupInfo *)selectGroupInfoByGid:(NSString *)gid {
    
    GroupInfo *group = [[GroupInfo alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where gid = '%@';",
                     kTableName, gid];
    FMResultSet *reslut = [[DBManager shareManager].database executeQuery:sql];
    if ([reslut next]) {
        
        group.gid = [reslut stringForColumn:@"gid"];
        group.logo = [reslut stringForColumn:@"logo"];
        group.name = [reslut stringForColumn:@"name"];
        group.huanxin_id = [reslut stringForColumn:@"huanxin_id"];
    }
    return group;
}

+ (void)deleteGroupInfoByGid:(NSString *)gid {
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where gid = '%@';",
                     kTableName, gid];
    BOOL ret = [[DBManager shareManager].database executeUpdate:sql];
    if (!ret) {
        NSLog(@"删除失败");
    }
}


@end
