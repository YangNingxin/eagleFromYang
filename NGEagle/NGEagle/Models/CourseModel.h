//
//  CourseModel.h
//  NGEagle
//
//  Created by Liang on 15/7/25.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol Course
@end

@protocol Grade
@end

@interface CourseModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<Course, Optional> *data;

@end

@interface Course : JSONModel

@property (nonatomic, strong) NSArray<Grade, Optional> *grades;

@property (nonatomic, strong) NSString *cid;// "1", //课程id
@property (nonatomic, strong) NSString *name;// "旅行基金讲解", //课程名称
@property (nonatomic, strong) NSString *type;// "1", //课程类型,0线下,1视频授课,2微课授课,3混合方式,4其他
@property (nonatomic, strong) NSString *desc;// "介绍旅行基金的使用方法", //介绍，富文本直接在h5中展示
@property (nonatomic, strong) NSString *auth_id;// "0", //权限id
@property (nonatomic, strong) NSString *user_id;// "14", //作者用户id
@property (nonatomic, strong) NSString *class_id;// "50", //作者所在班级id
@property (nonatomic, strong) NSString *school_id;// "10", //作者所在学校id
@property (nonatomic, strong) NSString *subject_id;// "0", //学科id
@property (nonatomic, strong) NSString *category_id;// "1", //分类id
@property (nonatomic, strong) NSString *least_nr;// "10", //最少人数
@property (nonatomic, strong) NSString *most_nr;// "50", //最多人数
@property (nonatomic, strong) NSString *credit;// "1", //学分
@property (nonatomic, strong) NSString *openlesson_nr;// "2", // 课时数
@property (nonatomic, strong) NSString *openlesson_hour;// "4", //总课时时长，单位小时
@property (nonatomic, strong) NSString *price;// "200", //价格
@property (nonatomic, strong) NSString *score;// "0", //评分
@property (nonatomic, strong) NSString *star;// "0", //星级
@property (nonatomic, strong) NSString *visitor_nr;// "0", /访问次数
@property (nonatomic, strong) NSString *face;// "http;//117.121.26.76/index.php?app=interface&mod=Resource&act=image&md=227969bbca64286ea48ff6e80f23ec2a", //封面图

// 课程详情页
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *agree_nr; //赞的数量
@property (nonatomic, strong) NSNumber<Optional> *is_agree; //是否赞过，0表示没有，1表示有
@property (nonatomic, strong) NSString<Optional> *comment_count; //该课程评论的数量
@property (nonatomic) int openclass_count; //开班的数量
@property (nonatomic) int openclass_appointment_count; //还可预约的班级数量
@property (nonatomic) BOOL is_appointment; //课程的是否可预约，1表示可以，0表示不可以
@property (nonatomic, strong) NSString *address; // "北京市海淀区颐和园", //上课地点
@property (nonatomic) float distance; //距离上课地点的距离，单位km，-1表示没有取到距离


@property (nonatomic, strong) NSString<Optional> *latitude;//"0",
@property (nonatomic, strong) NSString<Optional> *longitude;//"0",


/**
 *  对象
 */
@property (nonatomic, strong) NSString<Optional> *objectStudent;

@end

@interface Grade : JSONModel

@property (nonatomic, strong) NSString *gid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *stage_id;

@end