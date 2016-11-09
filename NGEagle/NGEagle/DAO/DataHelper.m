//
//  DataHelper.m
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "DataHelper.h"
#import "DesCode.h"

@implementation DataHelper

// 开机接口
+ (NSOperation *)getBootData:(BdRequestSuccess)successBlock
                        fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", API_SERVER, kApiBoot];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              NSLog(@"responseObject is %@", responseObject);
                                              
                                              successBlock([self praseClassData:@"BootInitModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getAllLoginNodeWithKeyWord:(NSString *)kw
                                    success:(BdRequestSuccess)successBlock
                                       fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", API_SERVER, kApiGetAllLoginNode];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (kw) {
        [parameters setObject:kw forKey:@"kw"];
    }
    NSOperation *operation = [BaseHttpRequest GET:url
                                      parameters:parameters
                                         success:^(id responseObject) {
                                             NSLog(@"responseObject is %@", responseObject);
                                             
                                             successBlock([self praseClassData:@"SchoolModel"
                                                                responseObject:responseObject]);
                                         }
                                         failure:failBlock];
    return operation;
}

+ (NSOperation *)getAllSubjectInfoForXuehu:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetAllSubjectInfoForXuehu];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              NSLog(@"responseObject is %@", responseObject);
                                              
                                              successBlock([self praseClassData:@"IntSubjectModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getHotLoginNode:(BdRequestSuccess)successBlock
                            fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", API_SERVER, kApiGetHotLoginNode];
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"SchoolModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  根据第三方token进行登录 edit delete
 *
 *  @param access_token
 *  @param node_id      学校节点
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)loginByOtherToken:(NSString *)access_token
                           node_id:(NSString *)node_id
                           success:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:node_id forKey:@"node_id"];
    [parameters setObject:access_token forKey:@"access_token"];

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiLoginByOtherToken];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"UserModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)loginByNode:(NSString *)node_id
                    username:(NSString *)username
                    password:(NSString *)password
                          ey:(BOOL)ey
                     success:(BdRequestSuccess)successBlock
                        fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:node_id forKey:@"node_id"];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:[DesCode desEncryptWithString:password] forKey:@"password"];
    [parameters setObject:@(1) forKey:@"ey"];

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiLoginById];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"UserModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  其他登录方式
 *
 *  @param type         目前可取telephone、email
 *  @param username     用户名
 *  @param password     密码
 *  @param ey           是否加密
 */
+ (NSOperation *)loginByTypeAndId:(NSString *)type
                         username:(NSString *)username
                         password:(NSString *)password
                               ey:(BOOL)ey
                          success:(BdRequestSuccess)successBlock
                             fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:type forKey:@"type"];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:[DesCode desEncryptWithString:password] forKey:@"password"];
    [parameters setObject:@(1) forKey:@"ey"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiLoginByPhone];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"UserModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}


+ (NSOperation *)getVerifyCode:(NSString *)phone
                 register_flag:(BOOL)register_flag
                       success:(BdRequestSuccess)successBlock
                          fail:(BdRequestFail)failBlock{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phone forKey:@"telephone"];
    [parameters setObject:@(register_flag) forKey:@"register_flag"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetVerifyCode];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)registerWithVerifyCode:(NSString *)code
                              telephone:(NSString *)telephone
                                   type:(int)type
                                    pwd:(NSString *)pwd
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:telephone forKey:@"telephone"];
    [parameters setObject:@(type) forKey:@"type"];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:pwd forKey:@"pwd1"];
    [parameters setObject:pwd forKey:@"pwd2"];

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiRegisterWithVerifyCode];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"UserModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
    
}

/**
 *  为教育ID登陆的用户绑定手机号
 *
 *  @param code          验证码
 *  @param telephone     手机号
 *  @param pwd1          密码
 *  @param pwd2          密码
 *  @param ey            是否加密
 *  @param password_flag 绑定手机号的同时，是否重置密码。1表示重置，0表示不重置。教育ID登录，初次绑定手机时需重置密码。换绑手机不需要
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)bindTelephoneWithVerifyCode:(NSString *)code
                                   telephone:(NSString *)telephone
                                        pwd1:(NSString *)pwd1
                                        pwd2:(NSString *)pwd2
                                          ey:(BOOL)ey
                               password_flag:(BOOL)password_flag
                                     success:(BdRequestSuccess)successBlock
                                        fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:telephone forKey:@"telephone"];
    [parameters setObject:code forKey:@"code"];
    if (pwd1) {
        [parameters setObject:[DesCode desEncryptWithString:pwd1] forKey:@"pwd1"];

    }
    if (pwd2) {
        [parameters setObject:[DesCode desEncryptWithString:pwd2] forKey:@"pwd2"];

    }
    [parameters setObject:@(1) forKey:@"ey"];
    [parameters setObject:@(password_flag) forKey:@"password_flag"];

    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiBindTelephoneWithVerifyCode];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)changeUserInfoWithDictParams:(NSDictionary *)params
                                      success:(BdRequestSuccess)successBlock
                                         fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiChangeUserInfo];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)uploadLogo:(UIImage *)image
                    success:(BdRequestSuccess)successBlock
                       fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiUploadLogo];
    NSMutableDictionary *fileDict = [NSMutableDictionary dictionary];
    [fileDict setObject:UIImagePNGRepresentation(image) forKey:@"file"];
    [fileDict setObject:@"image" forKey:@"fileName"];
    NSOperation *operation = [BaseHttpRequest POST:url parameters:nil fileParameters:fileDict success:^(id responseObject) {
        successBlock([self praseClassData:@"ResourceModel"
                           responseObject:responseObject]);
    } failure:failBlock];
    return operation;
}

+ (NSOperation *)getCourseList:(int)page
                      page_num:(int)page_num
                          sort:(int)sort
                           lat:(float)lat
                           lon:(float)lon
                            kw:(NSString *)kw
                        params:(NSDictionary *)params2
                       success:(BdRequestSuccess)successBlock
                          fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetCourseList];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(page_num) forKey:@"page_num"];
    [params setObject:@(sort) forKey:@"sort"];
    [params setObject:@(lat) forKey:@"lat"];
    [params setObject:@(lon) forKey:@"lon"];
    [params setObject:kw forKey:@"kw"];
    
    if (params2) {
       [params addEntriesFromDictionary:params2]; 
    }
    
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CourseModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取我的课程
 *
 *  @param page
 *  @param page_num
 *  @param owner
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getMyCourseList:(int)page
                        page_num:(int)page_num
                           owner:(BOOL)owner
                         success:(BdRequestSuccess)successBlock
                            fail:(BdRequestFail)failBlock {
   
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetCourseList];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(page_num) forKey:@"page_num"];
    [params setObject:@(owner) forKey:@"owner"];
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CourseModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  老师端修改班次状态
 *
 *  @param opencourse_id 课程ID
 *  @param openclass_id  班级ID
 *  @param status        1--已开课, 2--已结束, 3--取消开课
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)modifyOpenclasssStatusByOpencourseId:(int)opencourse_id
                                         openclass_id:(int)openclass_id
                                               status:(int)status
                                              success:(BdRequestSuccess)successBlock
                                                 fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiModifyOpenclasssStatus];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(opencourse_id) forKey:@"opencourse_id"];
    [params setObject:@(openclass_id) forKey:@"openclass_id"];
    [params setObject:@(status) forKey:@"status"];
       
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getCourseTypes:(BdRequestSuccess)successBlock
                           fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetCourseTypes];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CourseFilterModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getOrganizationTypes:(BdRequestSuccess)successBlock
                                 fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetOrganizationTypes];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ItemModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getHotSearchWords:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetHotSearchWords];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"HotSearchModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getCourseClassListWithCourseId:(int)course_id
                                           page:(int)page
                                        pageNum:(int)pageNum
                                        success:(BdRequestSuccess)successBlock
                                           fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(course_id) forKey:@"id"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(pageNum) forKey:@"page_num"];

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetCourseClassList];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ClassListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}


+ (NSOperation *)appointCourseClassWithCourseId:(int)course_id
                                       class_id:(int)class_id
                                        success:(BdRequestSuccess)successBlock
                                           fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(course_id) forKey:@"course_id"];
    [params setObject:@(class_id) forKey:@"class_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAppointCourseClass];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}
+ (NSOperation *)cancelCourseClassWithCourseId:(int)course_id
                                      class_id:(int)class_id
                                       success:(BdRequestSuccess)successBlock
                                          fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(course_id) forKey:@"course_id"];
    [params setObject:@(class_id) forKey:@"class_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiCancelCourseClass];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getCourseAppointmentInfo:(int)course_id
                                  success:(BdRequestSuccess)successBlock
                                     fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(course_id) forKey:@"id"];

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetCourseAppointmentInfo];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CourseDetailModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getClassAppointmentInfo:(int)class_id
                                 success:(BdRequestSuccess)successBlock
                                    fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(class_id) forKey:@"id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetClassAppointmentInfo];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ClassDetailModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getAppraisesWithTypeID:(int)type_id
                                   type:(int)type
                                   page:(int)page
                                pageNum:(int)pageNum
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(type_id) forKey:@"type_id"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(pageNum) forKey:@"page_num"];

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetAppraises];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CommentListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)getAppraiseTagsWithType:(int)type
                                 success:(BdRequestSuccess)successBlock
                                    fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:@(type) forKey:@"type"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetAppraiseTags];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"TagsModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)addAppraiseWithType:(int)type
                             type_id:(int)type_id
                                 tag:(NSString *)tag
                                star:(float)star
                             content:(NSString *)content
                             success:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(type_id) forKey:@"type_id"];
    [params setObject:tag forKey:@"tag"];
    [params setObject:content forKey:@"content"];
    [params setObject:@(star) forKey:@"star"];

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddAppraise];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  关注操作
 *
 *  @param action       1关注 0取消关注
 *  @param type         对象类型，1表示机构学校
 *  @param object_id    对象id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)followActionWithAction:(int)action
                                   type:(int)type
                              object_id:(int)object_id
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(object_id) forKey:@"id"];
    
    NSString *url;
    if (action == 1) {
        url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddFollow];
    } else if (action == 0) {
        url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiDeleteFollow];
    }
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)resetPwdWithVerifyCode:(NSString *)telephone
                                   pwd1:(NSString *)pwd1
                                   pwd2:(NSString *)pwd2
                                   code:(NSString *)code
                                     ey:(BOOL)ey
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:telephone forKey:@"telephone"];
    [parameters setObject:@(1) forKey:@"ey"];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:[DesCode desEncryptWithString:pwd1] forKey:@"pwd1"];
    [parameters setObject:[DesCode desEncryptWithString:pwd2] forKey:@"pwd2"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiResetPwdWithVerifyCode];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}


/**
 *  获取班级成员列表
 *
 *  @param groupId      群组id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getGroupUserByGroupId:(int)groupId
                               success:(BdRequestSuccess)successBlock
                                  fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(groupId) forKey:@"id"];
  
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetGroupUser];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"MemberListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取机构列表
 *
 *  @param kw           关键词
 *  @param lat          纬度
 *  @param lon          经度
 *  @param page         页
 *  @param page_num     数量
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getOrganizationList:(NSString *)kw
                                 lat:(float)lat
                                 lon:(float)lon
                                page:(int)page
                            page_num:(int)page_num
                             success:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:kw forKey:@"kw"];
    [parameters setObject:@(lat) forKey:@"lat"];
    [parameters setObject:@(lon) forKey:@"long"];
    [parameters setObject:@(page) forKey:@"page"];
    if (page_num != -1) {
        [parameters setObject:@(page_num) forKey:@"page_num"];
    }

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetOrganizationList];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"OrganListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取我所在机构
 *
 *  @param successBlock 成功
 *  @param failBlock    失败
 *
 *  @return
 */
+ (NSOperation *)getMyOrganization:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock {
   
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetMyOrganization];
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"OrganListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取附近课程列表
 *
 *  @param lat          纬度
 *  @param lon          经度
 *  @param range        范围，默认10
 *  @param page         page
 *  @param page_num     page_num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getNearbyCourseList:(float)lat
                                 lon:(float)lon
                               range:(float)range
                                page:(int)page
                            page_num:(int)page_num
                             success:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (range != -1) {
        [parameters setObject:@(range) forKey:@"range"];
    }
    [parameters setObject:@(lat) forKey:@"lat"];
    [parameters setObject:@(lon) forKey:@"long"];
    [parameters setObject:@(page) forKey:@"page"];
    if (page_num != -1) {
        [parameters setObject:@(page_num) forKey:@"page_num"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetNearbyCourseList];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CourseModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取课程任务列表
 *
 *  @param courseID        课程ID
 *  @param teacher_user_id 老师ID
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getCourseTasksByCourseId:(int)courseID
                          teacher_user_id:(int)teacher_user_id
                                  success:(BdRequestSuccess)successBlock
                                     fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(courseID) forKey:@"id"];
    if (teacher_user_id != 0) {
        [parameters setObject:@(teacher_user_id) forKey:@"teacher_user_id"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetCourseTasks];
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"TaskModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  根据任务获取班级列表
 *
 *  @param taskId       任务id
 *  @param page         页码
 *  @param pageNum      页数
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getClassListByTaskId:(int)taskId
                                 page:(int)page
                              pageNum:(int)pageNum
                              success:(BdRequestSuccess)successBlock
                                 fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(taskId) forKey:@"task_id"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(pageNum) forKey:@"page_num"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetClassByTaskId];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ClassListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  提交任务单
 *
 *  @param taskId        任务id
 *  @param content       内容
 *  @param resource_type image, video, audio
 *  @param file          image, video, audio 数组
 *  @param openclass_id 所上班次ID
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)submitTaskAnswerWithTaskID:(int)taskId
                                 author_uid:(int)author_uid
                                    content:(NSString *)content
                              resource_type:(NSString *)resource_type
                                       file:(NSDictionary *)file
                               openclass_id:(int)openclass_id
                                    success:(BdRequestSuccess)successBlock
                                       fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(taskId) forKey:@"task_id"];
    [parameters setObject:@(author_uid) forKey:@"author_uid"];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:resource_type forKey:@"resource_type"];
    
    if (openclass_id != 0) {
        [parameters setObject:@(openclass_id) forKey:@"openclass_id"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiSubmitTaskAnswer];
    
    NSOperation *operation;
    
    if ([resource_type isEqualToString:@"image"]) {
        
        NSMutableArray *fileArray = [NSMutableArray array];
        
        NSArray *images = [file objectForKey:@"data"];
        
        for (UIImage *image in images) {
            
            NSMutableDictionary *fileDict = [NSMutableDictionary dictionary];
            [fileDict setObject:[NSString stringWithFormat:@"%@[]",resource_type] forKey:@"fileName"];
            [fileDict setObject:UIImagePNGRepresentation(image) forKey:@"file"];
            
            [fileArray addObject:fileDict];
        }
        
        operation = [BaseHttpRequest POST:url parameters:parameters fileArray:fileArray success:^(id responseObject) {
            
            successBlock([self praseClassData:@"ErrorModel"
                               responseObject:responseObject]);
        } failure:failBlock];
        
    } else if ([resource_type isEqualToString:@"video"] || [resource_type isEqualToString:@"audio"]) {
        
        NSMutableDictionary *fileDict = [NSMutableDictionary dictionary];
        
        NSData *data = [NSData dataWithContentsOfURL:file[@"data"]];
        
        [fileDict setObject:data forKey:@"file"];
        [fileDict setObject:[NSString stringWithFormat:@"%@[]",resource_type] forKey:@"fileName"];
        
        operation = [BaseHttpRequest POST:url parameters:parameters fileParameters:fileDict success:^(id responseObject) {
            successBlock([self praseClassData:@"ErrorModel"
                               responseObject:responseObject]);
        } failure:failBlock];
    }
    
    
    return operation;
}

/**
 *  获取task的答案列表
 *
 *  @param taskId       任务ID
 *  @param openclass_id 非0时，获取特定班次该任务单的答案列表
 *  @param author_uid   非0时，获取该用户提交的该任务单的答案列表
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getTaskAnswersByTaskId:(int)taskId
                           openclass_id:(int)openclass_id
                             author_uid:(int)author_uid
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(taskId) forKey:@"task_id"];
    
    if (openclass_id != 0) {
        [params setObject:@(openclass_id) forKey:@"openclass_id"];
    }
    if (author_uid != 0) {
        [params setObject:@(author_uid) forKey:@"author_uid"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetTaskAnswersByTaskId];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"TaskAnswerModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取学生任务单的提交情况
 *
 *  @param taskId       任务ID
 *  @param openclass_id 班次ID
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getStudentsStatusByTaskAndClass:(int)taskId
                                    openclass_id:(int)openclass_id
                                         success:(BdRequestSuccess)successBlock
                                            fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(taskId) forKey:@"task_id"];
    
    if (openclass_id != 0) {
        [params setObject:@(openclass_id) forKey:@"openclass_id"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetStudentsStatusByTaskAndClass];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"TaskStatueModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  修改任务单答案的状态
 *
 *  @param answerId     答案ID
 *  @param status       状态，3表示推荐到光荣榜，1表示从光荣榜上撤掉
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)modifyTaskAnswerStatusByAnswerId:(int)answerId
                                           status:(int)status
                                          success:(BdRequestSuccess)successBlock
                                             fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(answerId) forKey:@"answer_id"];
    [params setObject:@(status) forKey:@"status"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiModifyTaskAnswerStatus];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取个人财富
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getWealth:(BdRequestSuccess)successBlock
                      fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetWealth];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"WealthModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;

}

/**
 *  获取交易记录
 *
 *  @param page         <#page description#>
 *  @param page_num
 *  @param successBlock <#successBlock description#>
 *  @param failBlock    <#failBlock description#>
 *
 *  @return <#return value description#>
 */
+ (NSOperation *)getTradingRecordsForOpencoursePage:(int)page
                                           page_num:(int)page_num
                                            success:(BdRequestSuccess)successBlock
                                               fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
  
    [parameters setObject:@(page) forKey:@"page"];
    if (page_num != -1) {
        [parameters setObject:@(page_num) forKey:@"page_num"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetTradingRecordsForOpencourse];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"OrderModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;

}

/**
 *  删除交易记录
 *
 *  @param billId       交易记录ID
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)deleteTradingRecordBillID:(int)billId
                                   success:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(billId) forKey:@"bill_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetTradingRecordsForOpencourse];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;

}

/**
 *  获取学习课程
 *
 *  @param type         1表示正在学，2表示已学完
 *  @param page         页码
 *  @param page_num     条目
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getStudyCourseListWithType:(int)type
                                       page:(int)page
                                   page_num:(int)page_num
                                    success:(BdRequestSuccess)successBlock
                                       fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(type) forKey:@"type"];

    [parameters setObject:@(page) forKey:@"page"];
    if (page_num != -1) {
        [parameters setObject:@(page_num) forKey:@"page_num"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetStudyCourseList];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CourseModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
    

}


/**
 *  修改密码
 *
 *  @param oldPass      旧密码
 *  @param strPass      新密码
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)modifyPassWordWithOldPass:(NSString *)oldPass
                                   newPass:(NSString *)strPass
                                   success:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:oldPass forKey:@"pwd"];
    [parameters setObject:strPass forKey:@"pwd1"];
    [parameters setObject:strPass forKey:@"pwd2"];
   
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiModifyPassword];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
    

}


/**
 *  验证用户密码是否正确
 *
 *  @param password     密码
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)checkPassword:(NSString *)password
                       success:(BdRequestSuccess)successBlock
                          fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:password forKey:@"password"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiCheckPassword];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;

}

/**
 *  获取课程消息列表
 *
 *  @param status       消息状态，-1--全部，0--未读，1--已读
 *  @param set_read     是否将获取的消息设置为已读，1--设置，0--不设置。当为1时，当次获取的未读消息都会标志为已读
 *  @param page
 *  @param page_num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getOpencourseMessageWithStatus:(int)status
                                       set_read:(int)set_read
                                           page:(int)page
                                       page_num:(int)page_num
                                        success:(BdRequestSuccess)successBlock
                                           fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(status) forKey:@"status"];
    [parameters setObject:@(set_read) forKey:@"set_read"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(page_num) forKey:@"page_num"];

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetOpencourseMessage];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CourseMessageModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  检查课程消息
 *
 *  @param token
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)checkMessageWithToken:(NSString *)token
                               success:(BdRequestSuccess)successBlock
                                  fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiCheckMessage];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CourseMessageNumber"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取用户关注的机构列表
 *
 *  @param token
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getFollowOrganizationListWithToken:(NSString *)token
                                               page:(int)page
                                           page_num:(int)page_num
                                            success:(BdRequestSuccess)successBlock
                                               fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(page_num) forKey:@"page_num"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetFollowOrganizationList];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"OrganListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}


/**
 *  上传资源
 *
 *  @param data         数据
 *  @param file_type    资源类型，有image、audio、video
 *  @param from         来源，如chat（聊天）、eagle（学乎）
 *  @param use_type     用途，如common（通用）
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)uploadResource:(NSData *)data
                      file_type:(NSString *)file_type
                           from:(NSString *)from
                       use_type:(NSString *)use_type
                        success:(BdRequestSuccess)successBlock
                           fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiUploadResource];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:file_type forKey:@"file_type"];
    
    if (from) {
        [parameters setObject:from forKey:@"from"];
    }
    if (use_type) {
        [parameters setObject:use_type forKey:@"use_type"];
    }
    
    NSMutableDictionary *fileDict = [NSMutableDictionary dictionary];
    
    [fileDict setObject:data forKey:@"file"];
    [fileDict setObject:file_type forKey:@"fileName"];
    
//    [fileDict setObject:@"image" forKey:@"fileName"];
    
    NSOperation *operation = [BaseHttpRequest POST:url parameters:parameters fileParameters:fileDict success:^(id responseObject) {
        successBlock([self praseClassData:@"UpLoadResourceModel"
                           responseObject:responseObject]);
    } failure:failBlock];
    return operation;
}

/**
 *  获取举报类型
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getReportList:(BdRequestSuccess)successBlock
                          fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetReportList];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ReportModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  举报
 *
 *  @param type         举报对象类型，1用户2资源3微课4课程集5学校6班级7试题8问题
 *  @param target_id    对象id
 *  @param content      内容
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)reportByType:(int)type
                    target_id:(int)target_id
                      content:(NSString *)content
                      success:(BdRequestSuccess)successBlock
                         fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiReport];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(type) forKey:@"type"];
    [parameters setObject:@(target_id) forKey:@"target_id"];

    if (content) {
        [parameters setObject:content forKey:@"content"];
    }
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取我的收藏
 *
 *  @param status       是否学完，0--全部，-1--未学完，1--已学完
 *  @param page
 *  @param num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getCollectionByStatus:(int)status
                                  page:(int)page
                                   num:(int)num
                               success:(BdRequestSuccess)successBlock
                                  fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetCollection];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(status) forKey:@"status"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(num) forKey:@"num"];

  
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取收藏的课程集
 *
 *  @param status       是否学完，0--全部，-1--未学完，1--已学完
 *  @param page
 *  @param num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getCollectionAlbumByStatus:(int)status
                                       page:(int)page
                                        num:(int)num
                                    success:(BdRequestSuccess)successBlock
                                       fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetCollectionAlbum];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(status) forKey:@"status"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(num) forKey:@"num"];
    
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

// 获取学习记录
+ (NSOperation *)getUserStudyRecordByPage:(int)page
                                      num:(int)num
                                  success:(BdRequestSuccess)successBlock
                                     fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetUserStudyRecord];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(num) forKey:@"num"];
    
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"StudyRecordModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取发布给自己的课程集列表
 *
 *  @param subject_id   学科id
 *  @param grade_id     年级id
 *  @param page
 *  @param num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getPublishToMeAlbumBySubject_id:(int)subject_id
                                        grade_id:(int)grade_id
                                            page:(int)page
                                             num:(int)num
                                         success:(BdRequestSuccess)successBlock
                                            fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetPublishToMeAlbum];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(subject_id) forKey:@"subject_id"];
    [parameters setObject:@(grade_id) forKey:@"grade_id"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(num) forKey:@"num"];
    
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

// 获取推荐给我的微课
+ (NSOperation *)getPublishToMeWeikeByPage:(int)page
                                       num:(int)num
                                subject_id:(int)subject_id
                                  grade_id:(int)grade_id
                                   success:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetPublishToMeWeike];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(num) forKey:@"num"];
    [parameters setObject:@(subject_id) forKey:@"subject_id"];
    [parameters setObject:@(grade_id) forKey:@"grade_id"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取问答列表
 *
 *  @param type          类型。0待我解答,1我提问，2我回答过，3推荐给我
 *  @param status        问题状态，0未完成，1已完成
 *  @param page
 *  @param num
 *  @param structure_ids 知识点id串，逗号分隔
 *  @param kw            搜索关键词
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getQuestionListByType:(int)type
                                status:(int)status
                                  page:(int)page
                                   num:(int)num
                         structure_ids:(NSString *)structure_ids
                                    kw:(NSString *)kw
                               success:(BdRequestSuccess)successBlock
                                  fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetQuestionList];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(type) forKey:@"type"];
    
    if (status != -1) {
        [parameters setObject:@(status) forKey:@"status"];
    }

    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(num) forKey:@"num"];
    
    if (structure_ids) {
        [parameters setObject:structure_ids forKey:@"structure_ids"];
    }
    if (kw) {
        [parameters setObject:kw forKey:@"kw"];
    }
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"QuestionListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  通用赞
 *
 *  @param isSupport    1赞，0取消赞
 *  @param type         1表示评论，2表示问题回答，3表示动态，4表示资源，5表示问题，6表示微课，7表示开放课程，8表示开放科学计划的任务单，9表示课程集，10表示笔记
 *  @param target_id    id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)supportByAction:(BOOL)isSupport
                            type:(int)type
                       target_id:(int)target_id
                         success:(BdRequestSuccess)successBlock
                            fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddSupport];
    if (!isSupport) {
        url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiDeleteSupport];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(type) forKey:@"type"];
    [parameters setObject:@(target_id) forKey:@"id"];
    
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;

}










































/***************************************************************************************/

+ (void)setCookieWithURL:(NSString *)url {
    
    NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
    NSString *strValue = [Account shareManager].userModel.token;
    [cookiePropertiesUser setObject:@"loginToken" forKey:NSHTTPCookieName];
    if (strValue) {
        [cookiePropertiesUser setObject:strValue forKey:NSHTTPCookieValue];
    }
    if (url) {
        [cookiePropertiesUser setObject:url forKey:NSHTTPCookieDomain];
    }
    [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesUser setObject:@"0" forKey:NSHTTPCookieVersion];
    
    // set expiration to one month from now or any NSDate of your choosing
    // this makes the cookie sessionless and it will persist across web sessions and app launches
    /// if you want the cookie to be destroyed when your app exits, don't set this
    [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    

    
}

/**
 *  清除cookie
 *
 *  @param urlString
 */
+ (void)clearCookieWithURL:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
        }
    }
}

+ (void)clearCookie {
    [self clearCookieWithURL:[Account shareManager].server];
}

+ (JSONModel *)praseClassData:(NSString *)className responseObject:(id)responseObject {
    
    NSError *error;
    Class cs = NSClassFromString(className);
    JSONModel *model = [[cs alloc] initWithDictionary:responseObject error:&error];
    if (error) {
        NSLog(@"Class：%@ ========解析失败：%@", className, error);
    }
    return model;
}

@end
