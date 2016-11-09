//
//  DBManager.m
//  NGEagle
//
//  Created by Liang on 15/8/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "DBManager.h"
#import "FCFileManager.h"

static DBManager *share = nil;

@interface DBManager()

@end

@implementation DBManager

+ (DBManager *)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[DBManager alloc] init];
    });
    return share;
}

/**
 *  打开数据库
 */
- (void)openDataBase {
    
    if (!self.database) {
        NSString *sqlitePath = [NSString stringWithFormat:@"%@%@",[Account shareManager].userModel.user.uid, kSqilteName];
        NSString *dbPath = [FCFileManager pathForDocumentsDirectoryWithPath:sqlitePath];
        self.database = [[FMDatabase alloc] initWithPath:dbPath];
    }
    
    //打开数据库
    BOOL res = [self.database open];
    if (res == NO) {
        NSLog(@"打开失败");
    }   
}

@end
