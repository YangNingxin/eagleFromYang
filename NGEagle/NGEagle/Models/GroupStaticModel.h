//
//  GroupStaticModel.h
//  NGEagle
//  统计用户的好友，群组，关注个数
//  Created by Liang on 15/8/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@class GroupStatic;

@interface GroupStaticModel : ErrorModel

@property (nonatomic, strong) GroupStatic *data;

@end


@interface GroupStatic : JSONModel

@property (nonatomic) int class_count;//: 1, //班级数量
@property (nonatomic) int group_count;//: 1, //群组数量
@property (nonatomic) int follow_organization_count;//: 0 //关注的机构数量

@end