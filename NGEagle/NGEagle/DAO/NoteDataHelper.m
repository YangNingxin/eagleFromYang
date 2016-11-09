//
//  NoteDataHelper.m
//  NGEagle
//
//  Created by Liang on 15/9/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NoteDataHelper.h"

@implementation NoteDataHelper

/**
 *  获取发布给自己的通知列表
 *
 *  @param status       状态，-1--全部，0--未读，1--已读
 *  @param page
 *  @param page_num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getPublishToMeListWithStatus:(int)status
                                         page:(int)page
                                     page_num:(int)page_num
                                      success:(BdRequestSuccess)successBlock
                                         fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(page_num) forKey:@"page_num"];
    [parameters setObject:@(status) forKey:@"status"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetPublishToMeList];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"NotifationModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;

}

/**
 *  获取我发布的通知
 *
 *  @param page
 *  @param page_num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getMyPublishListWithPage:(int)page
                                 page_num:(int)page_num
                                  success:(BdRequestSuccess)successBlock
                                     fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(page_num) forKey:@"page_num"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetMyPublishList];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"NotifationModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  设置通知为已读状态
 *
 *  @param announcementId 通知id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)setReadStatusWithAnnouncementId:(int)announcementId
                                         success:(BdRequestSuccess)successBlock
                                            fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(announcementId) forKey:@"announcement_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiSetReadStatus];
    
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
 *  发布通知
 *
 *  @param title        标题
 *  @param content      内容
 *  @param face         封面
 *  @param type         通知发送的对象类型，1自定义分组,2学校,3班级,4个人,10机构,20开放班级,21虚拟班级。除个人外，同群组的type定义，将通讯录返回的type填入即可。
 *  @param type_id      通知发布对象的id，如班级id、群组id、学校id等 1，3
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)publishNoteWithTitle:(NSString *)title
                              content:(NSString *)content
                                 face:(NSString *)face
                                 type:(int)type
                              targets:(NSString *)targets
                              success:(BdRequestSuccess)successBlock
                                 fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiPublishNote];
    
    [params setObject:title forKey:@"title"];
    [params setObject:content forKey:@"content"];
    [params setObject:targets forKey:@"targets"];

    if (face) {
        [params setObject:face forKey:@"face"];
    }
    
    NSOperation *operation = [BaseHttpRequest POST:url parameters:params fileParameters:nil success:^(id responseObject) {
        successBlock([self praseClassData:@"ErrorModel"
                           responseObject:responseObject]);
    } failure:failBlock];
    
    return operation;
}

/**
 *  获取通知详情
 *
 *  @param announcementId 通知ID
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getNoteDetailWithAnnouncementId:(int)announcementId
                                         success:(BdRequestSuccess)successBlock
                                            fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(announcementId) forKey:@"announcement_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetNoteDetail];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"NotifationDetailModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取一个通知发布的群组列表
 *
 *  @param announcementId 通知ID
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getPublishedGroupsWithAnnouncementId:(int)announcementId
                                              success:(BdRequestSuccess)successBlock
                                                 fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(announcementId) forKey:@"announcement_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetPublishedGroups];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"NotifationGroupModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取通知的用户阅读状态
 *
 *  @param announcementId 通知ID
 *  @param gid            当发布对象是群组时，获取一个群组的用户的阅读状态。为0表示取所有发布用户的阅读状态
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getUserReadStatusWithAnnouncementId:(int)announcementId
                                                 gid:(int)gid
                                             success:(BdRequestSuccess)successBlock
                                                fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(announcementId) forKey:@"announcement_id"];
    [parameters setObject:@(gid) forKey:@"gid"];

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetUserReadStatus];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"NotifationUserModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}
@end
