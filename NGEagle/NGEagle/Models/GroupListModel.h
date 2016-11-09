//
//  GroupListModel.h
//  NGEagle
//
//  Created by Liang on 15/8/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "GroupInfoModel.h"


@interface GroupListModel : ErrorModel

@property (nonatomic, strong) NSArray<GroupInfo> *classes;
@property (nonatomic, strong) NSArray<GroupInfo> *defined;
@property (nonatomic, strong) NSArray<GroupInfo> *school;

@end





