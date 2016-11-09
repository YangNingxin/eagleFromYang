//
//  GroupDao.h
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "GroupInfoModel.h"

@interface GroupDao : NSObject

+ (void)createGroup;

+ (void)insertGroup:(GroupInfo *)group;

+ (GroupInfo *)selectGroupInfoByGid:(NSString *)gid;

+ (void)deleteGroupInfoByGid:(NSString *)gid;

@end
