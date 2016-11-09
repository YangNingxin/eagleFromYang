//
//  CCCourseListModel.h
//  NGEagle
//
//  Created by Liang on 16/4/30.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol CCCourse <NSObject>

@end

@protocol FormatResource  <NSObject>

@end

/**
 *  课程列表model
 */
@interface CCCourseListModel : ErrorModel

@property (nonatomic, strong) NSArray<CCCourse> *data;

@end

@interface CCCourse : JSONModel

@property (nonatomic) int cid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;//一元二次方程",
@property (nonatomic) int auth_id;//6",
@property (nonatomic) int user_id;//14",
@property (nonatomic) int type_id;//2",
@property (nonatomic, strong) NSString *hint_at;//0",
@property (nonatomic, strong) NSString *score;//0",
@property (nonatomic, strong) NSString *price;//0",
@property (nonatomic, strong) NSString *star;//0",
@property (nonatomic, strong) NSString *agree_nr;
@property (nonatomic, strong) NSString *visitor_nr;//20",
@property (nonatomic, strong) NSString *ctime;//1459006593",
@property (nonatomic, strong) NSString *mtime;//1461424126",
@property (nonatomic) int status;//0",
@property (nonatomic) int obj_type_id;//: 501, //501表示微课, 505表示同步课程  !!!!502是课程集
@property (nonatomic, strong) NSString *face;//http://117.121.26.76/index.php?app=interface&mod=Resource&act=image&md=d9ac25ea75f95617f7ffa68173e4c078",
@property (nonatomic, strong) NSString *format_ctime;//2016-03-26",
@property (nonatomic, strong) NSString *format_mtime;//2016-04-23",
@property (nonatomic, strong) NSString *url;//http://117.121.26.76/index.php?app=weike&mod=Index&act=weikeStudy&weike_id=39006",
@property (nonatomic, strong) NSString *webapp_url;//http://117.121.26.76/index.php?app=webapp&mod=Weike&act=weikePlay&id=39006", //移动端网页地址
@property (nonatomic, strong) NSString *stage;//初中",
@property (nonatomic, strong) NSString *grade;//初中二年级",
@property (nonatomic, strong) NSString *subject;//数学",
@property (nonatomic, strong) NSString *study_user_count;//1",
@property (nonatomic) BOOL transcode_flag;
@property (nonatomic, strong) NSArray<FormatResource> *format_resources;
@property (nonatomic, strong) User *user;

// 针对课程集添加，元素个数
@property (nonatomic) int element_count;
@property (nonatomic, strong) NSString *format_study_ctime;
@end

@interface FormatResource : JSONModel

@property (nonatomic) int fid;
@property (nonatomic) int time;
@property (nonatomic, strong) NSString *format_time;
@property (nonatomic, strong) NSString *access_method;
@property (nonatomic, strong) NSString *url;

@end