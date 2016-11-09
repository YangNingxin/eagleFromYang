//
//  ClassListModel.h
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol ClassList

@end

@interface ClassListModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<ClassList> *data;

@end


@interface ClassList : JSONModel


@property (nonatomic) int cid;// "1";//开放班级id

@property (nonatomic, strong) NSString *name;// "旅行基金讲解第一次开课";//班级名称

@property (nonatomic) int opencourse_id;// "1";//所属的课程id

@property (nonatomic) int class_id;// "0";//对应的实体班级的id

@property (nonatomic, strong) NSString *sequence;// "1";//开班的序列

@property (nonatomic, strong) NSString *desc;// "第一次开课";//描述

@property (nonatomic, strong) NSString *address;// "北京市海淀区颐和园";//地址

@property (nonatomic) float location_lat;// "39.9922";//开课地点纬度

@property (nonatomic) float location_long;// "116.268";//开课地点经度

@property (nonatomic) int least_nr;// "10";//最少开课人数

@property (nonatomic) int most_nr;// "50";//最多开课人数

@property (nonatomic) float price;// "200";//价格

@property (nonatomic, strong) NSString *score;// "1";//审核评分级别

@property (nonatomic, strong) NSString *user_score;// "0";//用户评分级别

@property (nonatomic) int visitor_nr;// "0";//访问次数

@property (nonatomic) int agree_nr;// "0";//赞次数

@property (nonatomic) int disagree_nr;// "0";//踩次数

@property (nonatomic, strong) NSString *start_time;// "2015-07-25";//开始时间

@property (nonatomic, strong) NSString *end_time;// "2015-07-26";//结束时间

@property (nonatomic) int student_nr;// "0";//已经报名的学生人数

@property (nonatomic) int surplus_nr;// "50";//剩余可报名人数


@property (nonatomic) int class_status; // 1 可以预约 2 预约未开始 3 预约已结束 4 人员已满

@property (nonatomic) BOOL is_cancel_appointment;// "1";//当前学生是否可退款

@property (nonatomic) int lesson_nr;// "2" //课时数

@property (nonatomic, strong) NSString *url;// "http;////117.121.26.76/index.php?app=webapp&mod=Opencourse&act=classDetail&id=1";//班次详情页的url

@property (nonatomic, strong) NSString *group_name;// "";//所在群组的名称

@property (nonatomic) int group_type;// "0";//所在群组的类型，0普通,1学校,2行政班级,3兴趣小组,4讨论组,5匿名,6临时,10机构,20开放班级,21虚拟班级

@property (nonatomic) int group_id;// "0";//所在群组的id

/**
 *  教师ID，新增
 */
@property (nonatomic) int teacher_user_id;

/**
 * 针对老师端的班次状态：0--初始化，未开课，1--已开课，2--已结束，3--取消开课
 */
@property (nonatomic) int status;

@end

