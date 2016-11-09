//
//  UserTagSubscribeModel.h
//  NGEagle
//
//  Created by Liang on 16/5/2.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol UserTagSubscribe <NSObject>

@end

/**
 *  获取用户订阅的知识点
 */
@interface UserTagSubscribeModel : ErrorModel
@property (nonatomic, strong) NSArray<UserTagSubscribe> *data;
@end

@interface UserTagSubscribe : JSONModel

@property (nonatomic, strong) NSString *sid;//1", //知识点id
@property (nonatomic, strong) NSString *name;//识字与写字", //知识点名称
@property (nonatomic, strong) NSString *parent_id;//0",
@property (nonatomic, strong) NSString *level;//1",
@property (nonatomic, strong) NSString *subject_id;//1",
@property (nonatomic, strong) NSString *category_id;//0",
@property (nonatomic, strong) NSString *stage_id;//1",
@property (nonatomic, strong) NSString *grade_id;//0",
@property (nonatomic, strong) NSString *semester_id;//0",
@property (nonatomic, strong) NSString *version_id;//0",
@property (nonatomic, strong) NSString *textbook_id;//0",
@property (nonatomic, strong) NSString *visitor_nr;//0",
@property (nonatomic, strong) NSString *ctime;//1425031398",
@property (nonatomic, strong) NSString *mtime;//0",
@property (nonatomic, strong) NSString *status;//1",
@property (nonatomic) BOOL subscribe_flag; //1--已定阅，0--未订阅
@property (nonatomic, strong) NSString *weike_count;//120", //微课数量，目前只使用微课数量
@property (nonatomic, strong) NSString *album_count;// 0 //课程集数量

@end