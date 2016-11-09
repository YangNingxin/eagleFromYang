//
//  RegistrationDataHelper.m
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "RegistrationDataHelper.h"

@implementation RegistrationDataHelper

/**
 *  获取签到列表
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getRegistrationList:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock {

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetRegistrationList];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"RegistrationListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取签到的用户列表
 *
 *  @param registration_id 签到列表ID
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getRegistrationUserListByRegID:(int)registration_id
                                        success:(BdRequestSuccess)successBlock
                                           fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetRegistrationUserList];
    
    [params setObject:@(registration_id) forKey:@"registration_id"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"RegistarUserListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
*  创建一个点到对象
*
*  @param name         签到的名称
*  @param type         签到的对象类型，0--群组
*  @param type_id      到的群组对象id
*  @param user_count   一共的签到人数
*  @param time         签到时间，格式为：2015-10-11 12:00
*  @param pic_md       图片的md，图片先调上传接口上传。使用upload接口上传
*  @param longitude    经度，客户端在创建时获取
*  @param latitude     纬度，客户端在创建时获取
*  @param successBlock
*  @param failBlock
*
*  @return
*/
+ (NSOperation *)createRegistrationWithName:(NSString *)name
                                       type:(int)type
                                    type_id:(int)type_id
                                 user_count:(int)user_count
                                       time:(NSString *)time
                                     pic_md:(NSString *)pic_md
                                  longitude:(float)longitude
                                   latitude:(float)latitude
                                    success:(BdRequestSuccess)successBlock
                                       fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiCreateRegistration];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:name forKey:@"name"];
    [params setObject:time forKey:@"time"];
    [params setObject:pic_md forKey:@"pic_md"];

    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(type_id) forKey:@"type_id"];
    [params setObject:@(user_count) forKey:@"user_count"];
    [params setObject:@(longitude) forKey:@"longitude"];
    [params setObject:@(latitude) forKey:@"latitude"];

    
    NSOperation *operation = [BaseHttpRequest POST:url parameters:params fileParameters:nil success:^(id responseObject) {
        successBlock([self praseClassData:@"CreateRegistarModel"
                           responseObject:responseObject]);
    } failure:failBlock];
    
    return operation;
}

/**
 *  一次性创建一个点到对象
 *
 *  @param name         签到的名称
 *  @param type         签到的对象类型，0--群组
 *  @param type_id      到的群组对象id
 *  @param user_count   一共的签到人数
 *  @param time         签到时间，格式为：2015-10-11 12:00
 *  @param pic_md       图片的md，图片先调上传接口上传。使用upload接口上传
 *  @param longitude    经度，客户端在创建时获取
 *  @param latitude     纬度，客户端在创建时获取
 *  @param users        签到的用户信息，格式：user_id-status,user_id-status，
 多个用户之间用英文逗号分隔，用户id和状态之间用-分隔。
 status定义：0--正常已到, 1--迟到, 2--早退, 4--缺勤
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)createOnceRegistrationWithName:(NSString *)name
                                           type:(int)type
                                        type_id:(int)type_id
                                     user_count:(int)user_count
                                           time:(NSString *)time
                                         pic_md:(NSString *)pic_md
                                      longitude:(float)longitude
                                       latitude:(float)latitude
                                          users:(NSString *)users
                                        success:(BdRequestSuccess)successBlock
                                           fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiRegisterRegistration];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:name forKey:@"name"];
    [params setObject:time forKey:@"time"];
    if (pic_md) {
       [params setObject:pic_md forKey:@"pic_md"];
    }
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(type_id) forKey:@"type_id"];
    [params setObject:@(user_count) forKey:@"user_count"];
    [params setObject:@(longitude) forKey:@"longitude"];
    [params setObject:@(latitude) forKey:@"latitude"];
    [params setObject:users forKey:@"users"];

    NSOperation *operation = [BaseHttpRequest POST:url parameters:params fileParameters:nil success:^(id responseObject) {
        successBlock([self praseClassData:@"ErrorModel"
                           responseObject:responseObject]);
    } failure:failBlock];
    
    return operation;
}

/**
 *  编辑考勤
 *
 *  @param rid          签到ID
 *  @param users        签到的用户信息，格式：user_id-status,user_id-status，
 多个用户之间用英文逗号分隔，用户id和状态之间用-分隔。
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)editRegistrationWithID:(int)rid
                                  users:(NSString *)users
                                 pic_md:(NSString *)pic_md
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiUpdateRegister];
    
    [params setObject:@(rid) forKey:@"registration_id"];
    [params setObject:users forKey:@"users"];
    if (pic_md) {
        [params setObject:pic_md forKey:@"pic_md"];
    }

    NSOperation *operation = [BaseHttpRequest POST:url parameters:params fileParameters:nil success:^(id responseObject) {
        successBlock([self praseClassData:@"ErrorModel"
                           responseObject:responseObject]);
    } failure:failBlock];
   
    return operation;
}

@end
