//
//  StudyRecordModel.h
//  NGEagle
//
//  Created by Liang on 16/5/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "CCCourseListModel.h"

/**
 *  学习记录
 */
@interface StudyRecordModel : ErrorModel

@property (nonatomic) int study_time;//: 4728, //总学习时长，单位s
@property (nonatomic, strong) NSString *format_study_time;//: "78.8分钟", //格式化用于显示的学习时长
@property (nonatomic) int weike_count;//: 24, //微课数量
@property (nonatomic) int album_count;//: 4, //课程集数量
@property (nonatomic) int count;//: 28,  //总数量，用于计算翻页
@property (nonatomic, strong) NSArray<CCCourse> *data;

@end

