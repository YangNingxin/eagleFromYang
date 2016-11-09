//
//  UserModel.h
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@class User;
@class Subject;

@protocol User
@end

@protocol School
@end

@protocol NG_Class
@end

@protocol Project
@end


@protocol Subject
@end

/**
 *  用户model
 */
@interface UserModel : ErrorModel

/**
 *  token
 */
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) User *user;

@end

@interface User : JSONModel {

}
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *nick_pinyin;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic) int age;
@property (nonatomic) BOOL friend_flag;
/**
 *  兴趣
 */
@property (nonatomic, strong) NSString *interesting;

/**
 *  0保密，1男，2女
 */
@property (nonatomic ,strong) NSString *sex;


- (NSString *)sexName;
- (NSString *)birthdayName;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL is_first_login;

/**
 *  个人简介
 */
@property (nonatomic, strong) NSString *intro;

@property (nonatomic, strong) NSArray<School> *schooles;
@property (nonatomic, strong) NSArray<NG_Class> *classes;
@property (nonatomic, strong) NSArray<Project> *projects;
@property (nonatomic, strong) NSArray<Subject> *subject;
@property (nonatomic, strong) NSArray<Subject> *interest_subject;
@property (nonatomic, strong) NSString *webapp_url;

- (NSString *)schoolToString;

/**
 *  学科字符串：数学、英语
 */
@property (nonatomic, strong) NSString *subjectToString;

/**
 *  type如果是0，为教育id登录
 *  type如果是1，为手机号登录
 *  type如果是100，为数字学校登录方式，客户端本身的定义
 */
@property (nonatomic) int login_type;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *node_id;


/**
 *  0--正常已到, 1--迟到, 2--早退, 4--缺勤
 */
@property (nonatomic) int sign_status;

/**
 *  0--未读，1--已读，2--已发回执，4--用户已删除
 */
@property (nonatomic) int read_status;

@end

/**
 *  学校
 */
@interface School : JSONModel

@property (nonatomic, assign) int sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *memberCount;
@property (nonatomic, strong) NSString *school_id;
@property (nonatomic, strong) NSString *class_id;
@property (nonatomic, strong) NSString *huanxin_id;

@end

/**
 *  班级
 */
@interface NG_Class : JSONModel

@property (nonatomic, assign) int cid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *memberCount;
@property (nonatomic, strong) NSString *school_id;
@property (nonatomic, strong) NSString *class_id;
@property (nonatomic, strong) NSString *stage;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *huanxin_id;

@end

/**
 *  项目
 */
@interface Project : JSONModel

@property (nonatomic, assign) int pid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *admin_id;
@property (nonatomic, strong) NSString *node_id;
@property (nonatomic, strong) NSString *operation_id;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, assign) BOOL is_admin;
@property (nonatomic, assign) int status;

@end

/**
 *  擅长学科
 */
@interface Subject : JSONModel

@property (nonatomic, assign) int sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int parent_id;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, assign) int ctime;
@property (nonatomic, assign) int status;

/**
 *  是否选中
 */
@property (nonatomic) BOOL isSelected;

@end


