//
//  RegistrationListModel.h
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol RegistrationList
@end

@interface RegistrationListModel : ErrorModel
@property (nonatomic, strong) NSMutableArray<RegistrationList> *data;
@end

@interface RegistrationList : JSONModel

@property (nonatomic) int rid;                  //签到的id
@property (nonatomic, strong) NSString *name;   // "一次性签到2", //名字
@property (nonatomic) int user_id;              // "18", //创建签到的用户id
@property (nonatomic) int type;                 // "0", //签到对象的类型，0表示群组
@property (nonatomic) int target_id;            // "1", //签到对象的id
@property (nonatomic, strong) NSString *sign_time;// "2015-07-30 12:00", //签到时间
@property (nonatomic) float latitude;           // "39.201", //纬度
@property (nonatomic) float longitude;          // "176.32111", //经度
@property (nonatomic) int total_nr;             // "6", //总人数
@property (nonatomic) int later_nr;             //迟到人数
@property (nonatomic) int disappear_nr;         // "2", //缺勤人数
@property (nonatomic, strong) NSString *face;   //封面图

@end