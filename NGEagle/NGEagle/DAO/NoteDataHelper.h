//
//  NoteDataHelper.h
//  NGEagle
//
//  Created by Liang on 15/9/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "DataHelper.h"

@interface NoteDataHelper : DataHelper

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
                                         fail:(BdRequestFail)failBlock;

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
                                     fail:(BdRequestFail)failBlock;

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
                                            fail:(BdRequestFail)failBlock;

/**
 *  发布通知
 *
 *  @param title        标题
 *  @param content      内容
 *  @param face         封面
 *  @param type         通知发送的对象类型，1自定义分组,2学校,3班级,4个人,10机构,20开放班级,21虚拟班级。除个人外，同群组的type定义，将通讯录返回的type填入即可。
 *  @param targets      0-101,0-103。多个发布对象，type-type_id，type为0时表示群组，type_id为群组id。目前只支持0
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
                                 fail:(BdRequestFail)failBlock;

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
                                            fail:(BdRequestFail)failBlock;
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
                                                 fail:(BdRequestFail)failBlock;

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
                                                fail:(BdRequestFail)failBlock;
@end
