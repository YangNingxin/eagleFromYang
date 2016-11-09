//
//  CourseMessageModel.h
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "CourseModel.h"
#import "ClassListModel.h"

@class CourseNumber;

@protocol CourseMessage <NSObject>

@end

@interface CourseMessageModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<CourseMessage> *data;

@end


@interface CourseMessage : JSONModel

@property (nonatomic, strong) Course *opencourse;
@property (nonatomic, strong) ClassList *openclass;

@property (nonatomic) int mid;//: "8", //消息的id，send_type，send_uid，recv_type，recv_uid，msg_type，msg_subtype定义见重要数据说明
@property (nonatomic) int send_type;//: "20",
@property (nonatomic) int send_uid;//: "17",
@property (nonatomic) int recv_type;//: "1",
@property (nonatomic) int recv_uid;//: "15",
@property (nonatomic) int msg_type;//: "5",
@property (nonatomic) int msg_subtype;//: "0",
@property (nonatomic, strong) NSString *msg_title;//: "",
@property (nonatomic, strong) NSString *msg_content;
//: "您所预约的课程班次感受微观世界已确定开班，请您注意按时去上课", //消息的内容

@property (nonatomic, strong) NSString *msg_time;//: "2015-08-19 22:18", //消息发送的时间
@property (nonatomic) BOOL status;//: "0", //状态，0--未读，1--已读

@end


/**
 *  检查课程消息个数
 */
@interface CourseMessageNumber : ErrorModel

@property (nonatomic, strong) CourseNumber *course;
@property (nonatomic, strong) CourseNumber *announcement;

@end


@interface CourseNumber : JSONModel

@property (nonatomic) BOOL has_new;
@property (nonatomic) int countNumber;

@end