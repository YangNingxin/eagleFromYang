//
//  TaskStatueModel.h
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol TaskUser <User>

@end

/**
 *  任务提交状态
 */
@interface TaskStatueModel : ErrorModel
@property (nonatomic, strong) NSArray<TaskUser> *data;
@end


@interface TaskUser : User

/**
 *  1表示已提交，0表示未提交
 */
@property (nonatomic, assign) BOOL is_submit_task;

@end