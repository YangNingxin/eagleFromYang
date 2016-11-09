//
//  Note.h
//  NGEagle
//
//  Created by Liang on 15/7/30.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

/**
 * 打开跳转到app的schema, 统一schema, type区分功能, params为参数数组, 转为json
 * @param, type
 *          1--首页到课程列表
 *              params: {"type":1}
 *          2--首页到活动列表
 *              params: {"type":2}
 *          3--首页到微课列表
 *              params: {"type":3}
 *          4--获取附近的机构
 *              params: {"type":4}
 *          5--获取附近的课程
 *              params: {"type":5}
 *          6--课程详情页跳转机构详情页, params为机构id, 机构详情页url
 *              params: {"type":6,"school_id":10,"url":"http://117.121.26.76/index.php?            app=webapp&mod=Opencourse&act=organizationBasic&id=10"}
 *          7--课程详情页, 跳转到班级列表, params为课程id
 *              params: {"type":7,"course_id":10}
 *          8--课程详情页, 跳转到评价列表, params为课程id
 *              params: {"type":8,"course_id":10}
 *          9--课程详情页, 跳转到地图显示授课地点, params为经纬度, 课程名称
 *              params: {"type":9,"longitude":112.12,"latitude":39.102,"name":"学乎学院"}
 *             班级详情页, 跳转到地图显示授课地点, params为经纬度, 班级名称
 *              params: {"type":9,"longitude":112.12,"latitude":39.102,"name":"一班"}
 *          10--班级详情页, 跳转到班级成员列表, params为班级id, 群组id, 群组类型
 *              params: {"type":10,"class_id":1,"group_id":10,"group_type":1}
 *          11--任务单列表页, 调起app提交任务, params为任务id
 *              params: {"type":11,"task_id":1}
 */