//
//  DBManager.h
//  NGEagle
//
//  Created by Liang on 15/8/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define kSqilteName @"Eagle.sqlite"  //数据库名字

@interface DBManager : NSObject

@property (nonatomic, strong) FMDatabase *database;

+ (DBManager *)shareManager;

/**
 *  打开数据库
 */
- (void)openDataBase;

@end
