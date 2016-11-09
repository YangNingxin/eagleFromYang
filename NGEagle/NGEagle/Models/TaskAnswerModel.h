//
//  TaskAnswerModel.h
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "ResourceModel.h"
#import "UserModel.h"

@protocol TaskAnswer

@end

/**
 *  任务答案
 */
@interface TaskAnswerModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<TaskAnswer> *data;

@end

@interface TaskAnswer : JSONModel

@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSArray<Resource> *resource;

@property (nonatomic) int answerId;     //id
@property (nonatomic) int opentask_id;  //task id
@property (nonatomic) int openclass_id; //对应的班次id
@property (nonatomic) int user_id;      //完成任务的学生用户id
@property (nonatomic, strong) NSString *content; //内容
@property (nonatomic) int agree_nr;     //赞的数量
@property (nonatomic) int disagree_nr;  //踩的数量
@property (nonatomic) int ctime;    //提交时间，unix时间戳
@property (nonatomic) BOOL is_agree;
@property (nonatomic) float height;

@end
