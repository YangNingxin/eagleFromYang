//
//  ChatDataHelper.h
//  NGEagle
//
//  Created by Liang on 15/8/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "DataHelper.h"

@interface ChatDataHelper : DataHelper

/**
 *  获取好友列表
 *
 *  @param token 不传
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getFriend:(NSString *)token
                   success:(BdRequestSuccess)successBlock
                      fail:(BdRequestFail)failBlock;

/**
 *  获取用户通讯录的统计信息
 *
 *  @param token
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getContactStatistic:(NSString *)token
                             success:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock;

/**
 *  获取个人信息
 *
 *  @param uid          用户id
 *  @param successBlock 成功
 *  @param failBlock    失败
 *
 *  @return
 */
+ (NSOperation *)getUserInfoByUid:(NSString *)uid
                          success:(BdRequestSuccess)successBlock
                             fail:(BdRequestFail)failBlock;

/**
 *  获取群组信息
 *
 *  @param gid          群组id
 *  @param successBlock 成功
 *  @param failBlock    失败
 *
 *  @return
 */
+ (NSOperation *)getGroupInfoById:(NSString *)gid
                          success:(BdRequestSuccess)successBlock
                             fail:(BdRequestFail)failBlock;

/**
 *  获取用户所在的群组
 *
 *  @param type         群组类型，0表示全部，1表示学校群组，2表示班级群组，3表示自定义群组。分别对应school，class，definded
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getGroupByType:(int)type
                        success:(BdRequestSuccess)successBlock
                           fail:(BdRequestFail)failBlock;

/**
 *  搜索联系人
 *
 *  @param  keywords	string	搜索关键字
 *  @param  type	Int	搜索类型，0搜群组加好友，1搜好友，2搜群组
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)contactSearchWithKeyWords:(NSString *)keyword
                                      type:(int)type
                                   success:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock;

/**
 *  删除好友
 *
 *  @param uid
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)delFriend:(NSString *)uid
                   success:(BdRequestSuccess)successBlock
                      fail:(BdRequestFail)failBlock;

/**
 * 添加好友
 *
 *  @param uid
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)addFriend:(NSString *)uid
                   success:(BdRequestSuccess)successBlock
                      fail:(BdRequestFail)failBlock;

/**
 *  确认好友请求
 *
 *  @param uid
 *  @param status 1表示通过，2表示拒绝
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)confirmFriendRequest:(NSString *)uid
                               status:(int)status
                              success:(BdRequestSuccess)successBlock
                                 fail:(BdRequestFail)failBlock;
/**
 *  添加群成员
 *
 *  @param gid          群组id
 *  @param uid          用户id。当操作用户为群主的时候，该代表对方用户id。当操作用户不是群主时，该设置成用户id
 *  @param uids         多个用户id。只用在群主添加多成员的情况
 *  @param cmd          用户操作类型。0为申请，1为同意，2为拒绝
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)addGroupUserWithGid:(NSString *)gid
                                 uid:(NSString *)uid
                                uids:(NSString *)uids
                                 cmd:(int)cmd
                             success:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock;

/**
 *  删除群成员
 *
 *  @param gid          群组id
 *  @param uid          用户id 用户推出群组或者群主踢人。当uid等于操作用户id时，表示退出该群。否则为踢人
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)delGroupUserWithGid:(NSString *)gid
                                 uid:(NSString *)uid
                             success:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock;

/**
 *  解散群
 *
 *  @param gid          群组id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)delGroupWithGid:(NSString *)gid
                         success:(BdRequestSuccess)successBlock
                            fail:(BdRequestFail)failBlock;

/**
 *  获取动态
 *
 *  @param curId        当前ID
 *  @param isNewer      0代表获取老数据 1代表获取新数据
 *  @param type         群组类型 1为班级 2学校 3自定义组
 *  @param gid          群组id
 *  @param other_uid    其他人Uid
 *  @param num          条目
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getDynamicListWithCurrentId:(NSString *)curId
                                      newer:(BOOL)isNewer
                                       type:(int)type
                                        gid:(NSString *)gid
                                  other_uid:(NSString *)other_uid
                                        num:(int)num
                                    success:(BdRequestSuccess)successBlock
                                       fail:(BdRequestFail)failBlock;

/**
 *  发布动态
 *
 *  @param strContent   内容
 *  @param type   	群组类型 1班级 2学校 3自定义组 默认0
 *  @param resourceDict 附件\附件类型 图片image 视频video 音频audio
 *  @param permission   权限 0为所有人可见 1为好友可见 2为私密
 *  @param strGid       群组Id
 *  @param strPid       转发父Id
 *  @param strAtIds     at ids
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)publishDynamicWithContent:(NSString *)strContent
                                      type:(int)type
                                  resource:(NSDictionary *)resourceDict
                                permission:(int)permission
                                       gid:(NSString *)strGid
                                       pid:(NSString *)strPid
                                    at_ids:(NSString *)strAtIds
                                   success:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock;

/**
 *  评论
 *
 *  @param strContent   内容
 *  @param strType      评论的对象类型，0表示动态（其他后面定义）
 *  @param strTypeId    评论的对象id，type为0时表示动态id
 *  @param strPid       回复某人评论时使用，回复的评论id
 *  @param strPuid      回复某人评论时使用，回复的用户id
 *  @param strAtIds
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)addCommentWithContent:(NSString *)strContent
                                  type:(NSString *)strType
                                typeId:(NSString *)strTypeId
                                   pid:(NSString *)strPid
                                  puid:(NSString *)strPuid
                                at_ids:(NSString *)strAtIds
                               success:(BdRequestSuccess)successBlock
                                  fail:(BdRequestFail)failBlock;

/**
 *  对动态的赞
 *
 *  @param strType   赞的对象类型，0表示动态（其他后面定义）
 *  @param strTypeId 赞的对象id，type为0时表示动态id
 *  @param strDel    0为赞，1为删除赞
 *
 *  @return
 */
+ (NSOperation *)addSupportType:(NSString *)strType
                         typeId:(NSString *)strTypeId
                            del:(NSString *)strDel
                        success:(BdRequestSuccess)successBlock
                           fail:(BdRequestFail)failBlock;

/**
 *  删除动态
 *
 *  @param did          动态id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)deleteDynamicById:(NSString *)did
                           success:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock;

/**
 *  获取评论列表
 *
 *  @param strType      评论对象类型，0表示动态（其他的后面定义）
 *  @param strTypeId    对象id
 *  @param strCurid     当前评论id，0代表获取最新
 *  @param strNum       需要的数目
 *  @param strNewer     是否获取更新, 0老数据 1新数据
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+(NSOperation *)getCommentListType:(NSString *)strType
                            typeId:(NSString *)strTypeId
                             curId:(NSString *)strCurid
                               num:(int)num
                             newer:(BOOL)isNewer
                           success:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock;
@end






