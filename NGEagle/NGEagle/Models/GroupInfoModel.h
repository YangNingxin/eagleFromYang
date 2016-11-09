//
//  GroupInfoModel.h
//  NGEagle
//
//  Created by Liang on 15/8/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "UserModel.h"
#import "CourseModel.h"

@class GroupInfo;


@protocol GroupInfo

@end

@interface GroupInfoModel : ErrorModel

@property (nonatomic, strong) GroupInfo *data;

@end


@interface GroupInfo : JSONModel

@property (nonatomic, strong) Course *opencourse;
@property (nonatomic, strong) User *owner;

@property (nonatomic, strong) NSString *gid;//: "101",//群组id
@property (nonatomic, strong) NSString *name;//: "初中三年级1班", //群组名称
@property (nonatomic) int type;//: "2", //群组类型，1--学校，2--班级，3--自定义，10--机构，20--开放班级，21--虚拟班级
@property (nonatomic, strong) NSString *desc;//: "[2013级初中1班]默认群组",
@property (nonatomic, strong) NSString *create_time;//: "", //创建时间，unix时间戳
@property (nonatomic, strong) NSString *tag;//: "",
@property (nonatomic, strong) NSString *logo;//: "", //头像
@property (nonatomic) int memberCount;//: "21", //成员数量
@property (nonatomic) int owner_id;//: "14", //群主用户id
@property (nonatomic) int target_id;//: "50", //对象id
@property (nonatomic) int school_id;//: 0,
@property (nonatomic) int class_id;//: "50",
@property (nonatomic, strong) NSString *huanxin_id;//: "92650251332092360", //环信id
@property (nonatomic) BOOL is_member;//: 1, //是否是群组成员，1--是，0--不是

@end

