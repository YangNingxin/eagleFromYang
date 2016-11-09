//
//  OrganListModel.h
//  NGEagle
//
//  Created by Liang on 15/8/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol Organ

@end

@interface OrganListModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<Organ> *data;

@end

@interface Organ : JSONModel

@property (nonatomic, strong) NSString *oid;//"10", //机构id
@property (nonatomic, strong) NSString *global_code;//"XS00001",
@property (nonatomic, strong) NSString *rank;//"0",
@property (nonatomic, strong) NSString *type_id;//"1", //机构类型，1--普通学校，2--虚拟学校，3--高等院校，4--科研机构，5--科普场馆，6--企业，7--校外教育机构，8--社会团体，9--普通学校联盟，10--海外教育机构
@property (nonatomic, strong) NSString *name;//"学乎学院", //机构名称
@property (nonatomic, strong) NSString *alias;//"",
@property (nonatomic, strong) NSString *title;//"",
@property (nonatomic, strong) NSString *address;//"北京市海淀区", //地址
@property (nonatomic, strong) NSString *email;//"xuehu@snsnlearn.com",
@property (nonatomic, strong) NSString *telephone;//"",
@property (nonatomic, strong) NSString *location;//"100089",

@property (nonatomic, strong) NSString<Optional> *latitude;//"0",
@property (nonatomic, strong) NSString<Optional> *longitude;//"0",

@property (nonatomic, strong) NSString *master_name;//"张福",
@property (nonatomic, strong) NSString *admin_id;//"0",
@property (nonatomic, strong) NSString *homepage_url;//"http://snslearn.com/",
@property (nonatomic, strong) NSString *logo_url;//"http://snslearn.com/public/default_school_logo.png",
@property (nonatomic, strong) NSString *logo_md;//"",
@property (nonatomic, strong) NSString *province_id;//"110000",
@property (nonatomic, strong) NSString *city_id;//"110100",
@property (nonatomic, strong) NSString *district_id;//"110108",
@property (nonatomic, strong) NSString *desc;//"",
@property (nonatomic, strong) NSString *establish_time;//"1339430400",
@property (nonatomic, strong) NSString *follow_nr;//"1", //关注人数
@property (nonatomic, strong) NSString *agree_nr;//"0",  //赞数量
@property (nonatomic, strong) NSString *disagree_nr;//"0", //踩数量
@property (nonatomic) float distance;

@property (nonatomic, strong) NSString *url;//"http://117.121.26.76/index.php?app=webapp&mod=Opencourse&act=organizationBasic&id=10" //打开h5详情页的url
@property (nonatomic, strong) NSString<Optional> *course_count;
@property (nonatomic) BOOL is_follow;


@end