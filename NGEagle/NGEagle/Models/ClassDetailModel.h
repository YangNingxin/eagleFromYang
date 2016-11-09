//
//  ClassDetailModel.h
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@class ClassDetail;
@interface ClassDetailModel : ErrorModel

@property (nonatomic, strong) ClassDetail *data;

@end


@interface ClassDetail : JSONModel

@property (nonatomic) int cid;//2", //班级id
@property (nonatomic, strong) NSString *name;//旅行基金讲解第二次开课", //名称
@property (nonatomic) int opencourse_id;//1", //对应的课程id
@property (nonatomic, strong) NSString *desc;//第二次开课", //描述
@property (nonatomic, strong) NSString *address;//北京市海淀区颐和园", //开课地址
@property (nonatomic) float location_lat;//39.9922", //经度
@property (nonatomic) float location_long;//116.268", //纬度

/**
当前状态，具体说明    1--用户未预约该班次，可以预约，点击按钮后到课程的班级列表页进行预约
                   2--用户未预约该班次，人员已满， 不能预约，按钮不可点击
                   3--用户未预约该班次，预约时间未开始，不能预约，按钮不可点击
                   4--用户未预约该班次，预约时间已结束，不能预约，按钮不可点击
                   5--用户未预约该班次，已预约该课程其他班次，不能预约，按钮不可点击
                   6--用户已预约该班次，未开课，不能评价，按钮不可点击
                   7--用户已预约该班次，已开课，可以评价，点击按钮到课程评价页
                   8--用户已预约该班次，已开课，已评价，不能重复评价，按钮不可点击
 
任课老师端具体说明    11--课程处于初始化状态，显示两个按钮：取消开课，确定开课
                   12--已确定开课，班次还未开始上，按钮不可点击
                   13--已确定开课，班次进行中，按钮不可点击
                   14--已确定开课，班次已结束，按钮可点击，结束班次
                   15--班次课程已取消，不显示按钮
                   16--班次课程已结束，不显示按钮
 
非任课老师具体说明    提示文字和按钮都不显示
 */
@property (nonatomic) int status;


@property (nonatomic, strong) NSString *button_info;//预约课程", //班级详情页button上的提示文字
@property (nonatomic, strong) NSString *tip;//已选0人, 剩余50人" //班级详情页下方的提示语

@property (nonatomic, strong) NSString *group_id;
@property (nonatomic, strong) NSString *huanxin_id;

@property (nonatomic) BOOL is_cancel_appointment;

@end