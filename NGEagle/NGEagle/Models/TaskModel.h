//
//  TaskModel.h
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "ResourceModel.h"

@protocol Task
@end

/**
 *  任务单列表
 */
@interface TaskModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<Task> *data;

@end


@interface Task : JSONModel

@property (nonatomic) int tid; //任务id
@property (nonatomic, strong) NSString *name; //名称
@property (nonatomic) int type;         //任务类型,0必须提交,1选择提交
@property (nonatomic) int user_id;      //发布任务的用户id
@property (nonatomic) int school_id;    //发布任务的用户所在学校
@property (nonatomic) int opencourse_id; //所属的课程id
@property (nonatomic) int openlesson_id; //所属的课时id
@property (nonatomic, strong) NSString *content; //任务的文本描述信息
@property (nonatomic) BOOL is_submit;            //该任务用户是否已经提交过，0表示没有，1表示有
@property (nonatomic, strong) NSString *url;    //任务单详情页url
@property (nonatomic) BOOL is_appoint_course;   //当前用户是否预约了该课程，0表示没有，只能查看任务信息，不能提交。1表示有
@property (nonatomic) int teacher_user_id;      //布置该任务的任课老师，同对应的lesson的user

@property (nonatomic, strong) NSMutableArray<Resource> *resource;

@end
