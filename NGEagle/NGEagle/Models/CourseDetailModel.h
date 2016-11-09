//
//  CourseDetailModel.h
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@class CourseDetail;

@interface CourseDetailModel : ErrorModel

@property (nonatomic, strong) CourseDetail *data;

@end

@interface CourseDetail : JSONModel

@property (nonatomic) int cid; //;//"1", //课程id
@property (nonatomic, strong) NSString *name;//"旅行基金", //课程名称，分享时使用
@property (nonatomic, strong) NSString *desc;//"旅行基金说明", //课程名称，分享时使用
@property (nonatomic, strong) NSString *face;//"http://117.121.26.76/index.php?app=interface&mod=Resource&act=image&md=227969bbca64286ea48ff6e80f23ec2a", //图片，分享时使用
@property (nonatomic, strong) NSString *url;//"http://117.121.26.76/index.php?app=webapp&mod=Opencourse&act=courseBasic&id=1", //课程详情页html5地址，分享的网页地址
@property (nonatomic) int openclass_count;//"2", //开班的数量
@property (nonatomic) int openclass_appointment_count;//2, //当前可预约的班级数量
@property (nonatomic) int status;//"1", //状态，具体说明：1--当前课程可预约，点击按钮进入课程的班级列表
                                                    //2--已经预约当前课程，且预约的班级还没有上完，不能再预约，点击按钮到所预约班次的详情页
                                                    //3--当前课程不能预约，按钮不可点击
@property (nonatomic) int appoint_class_id;//"1", //status为2时，已经预约的班级id，其他情况下为0
@property (nonatomic, strong) NSString *class_detail_url;//"http://117.121.26.76/index.php?app=webapp&mod=Opencourse&act=classDetail&id=1", //status为2时，已经预约的班级h5详情页url，其他情况下为空
@property (nonatomic, strong) NSString *button_info;//"查看班次", //显示在button上的文字
@property (nonatomic, strong) NSString *tip;//"开设2个班，有1个班可预约" //提示语


@end