//
//  ChatDataHelper.m
//  NGEagle
//
//  Created by Liang on 15/8/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ChatDataHelper.h"
#import "FCFileManager.h"
#import "EMVoiceConverter.h"

@implementation ChatDataHelper

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
                      fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetFriend];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"FriendListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

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
                                fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetContactStatistic];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:nil
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"GroupStaticModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;

}

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
                             fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetUserInfoByUid];
    
    [params setObject:uid forKey:@"uid"];
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"UserInfoModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

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
                             fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetGroupInfoById];
    
    [params setObject:gid forKey:@"gid"];
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"GroupInfoModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取用户所在的群组
 *
 *  @param type         获取用户所在的群组，分为三部分：自定义群组、班级群组、学校群组
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getGroupByType:(int)type
                        success:(BdRequestSuccess)successBlock
                           fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetGroup];
    if (type != -1) {
        [params setObject:@(type) forKey:@"type"];
    }
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"GroupListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

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
                                      fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiContactSearch];
    
    [params setObject:@(type) forKey:@"type"];
    [params setObject:keyword forKey:@"keywords"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ContactSearchModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

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
                      fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiDelFriend];
    
    [params setObject:uid forKey:@"uid"];
    
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
                      fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddFriend];
    
    [params setObject:uid forKey:@"uid"];
    
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
                                 fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiConfirmFriendRequest];
    
    [params setObject:uid forKey:@"uid"];
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
                                 fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddGroupUser];
    
    [params setObject:uid forKey:@"uid"];
    [params setObject:uids forKey:@"uids"];
    [params setObject:gid forKey:@"gid"];
    [params setObject:@(cmd) forKey:@"cmd"];
    
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
                                fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiDelGroupUser];
    
    [params setObject:uid forKey:@"uid"];
    [params setObject:gid forKey:@"gid"];
    
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
                            fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiDelGroup];
    
    [params setObject:gid forKey:@"gid"];
    
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
+(NSOperation *)getDynamicListWithCurrentId:(NSString *)curId
                                      newer:(BOOL)isNewer
                                       type:(int)type
                                        gid:(NSString *)gid
                                  other_uid:(NSString *)other_uid
                                        num:(int)num
                                    success:(BdRequestSuccess)successBlock
                                       fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetDynamicList];
    
    [params setObject:curId forKey:@"curId"];
    [params setObject:@(isNewer) forKey:@"newer"];
    [params setObject:@(num) forKey:@"num"];
    
    if (type != -1) {
        [params setObject:@(type) forKey:@"type"];
    }
    if (gid) {
        [params setObject:gid forKey:@"gid"];
    }
    if (other_uid) {
        [params setObject:other_uid forKey:@"other_uid"];
    }

    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"DynamicsListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)publishDynamicWithContent:(NSString *)strContent
                                      type:(int)type
                                  resource:(NSDictionary *)resourceDict
                                permission:(int)permission
                                       gid:(NSString *)strGid
                                       pid:(NSString *)strPid
                                    at_ids:(NSString *)strAtIds
                                   success:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:strContent forKey:@"content"];
    [parameters setObject:@(type) forKey:@"type"];
    [parameters setObject:@(permission) forKey:@"permission"];
    if (strGid) {
        [parameters setObject:strGid forKey:@"gid"];
    }
    if (strPid) {
        [parameters setObject:strPid forKey:@"pid"];
    }
    if (strAtIds) {
        [parameters setObject:strPid forKey:@"at_ids"];
    }
    
    NSString *resource_type = @"no_resource";
    
    switch ([resourceDict[@"type"] intValue]) {
        case 0:
            resource_type = @"image";
            break;
        case 1:
            resource_type = @"video";
            break;
        case 2:
            resource_type = @"audio";
            break;
        default:
            break;
    }
    if (![resource_type isEqualToString:@"no_resource"]) {
        [parameters setObject:resource_type forKey:@"resource_type"];
    }

    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddDynamic];
    
    NSOperation *operation;
    
    if ([resource_type isEqualToString:@"image"]) {
        
        NSMutableArray *fileArray = [NSMutableArray array];
        
        NSArray *images = [resourceDict objectForKey:@"data"];
        
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
        
        NSData *data;
        if ([resource_type isEqualToString:@"video"]) {
            // 本地视频取出来是一个url
            data = [NSData dataWithContentsOfURL:resourceDict[@"ext_file"]];
        } else {
            // 录音取出来是一个filePath
            // 如果存在路径就删除掉
            NSString *amrPath = [FCFileManager pathForCachesDirectoryWithPath:recordAmrAudioName];
            if ([FCFileManager existsItemAtPath:amrPath]) {
                [FCFileManager removeItemAtPath:amrPath];
            }
            [EMVoiceConverter wavToAmr:resourceDict[@"ext_file"] amrSavePath:amrPath];
            data = [NSData dataWithContentsOfFile:amrPath];
        }
        
        [fileDict setObject:data forKey:@"file"];
        [fileDict setObject:[NSString stringWithFormat:@"%@[]",resource_type] forKey:@"fileName"];
        
        operation = [BaseHttpRequest POST:url parameters:parameters fileParameters:fileDict success:^(id responseObject) {
            successBlock([self praseClassData:@"ErrorModel"
                               responseObject:responseObject]);
        } failure:failBlock];
    } else {
        operation = [BaseHttpRequest POST:url parameters:parameters fileParameters:nil success:^(id responseObject) {
            successBlock([self praseClassData:@"ErrorModel"
                               responseObject:responseObject]);
        } failure:failBlock];
    }
    return operation;
}

+ (NSOperation *)addCommentWithContent:(NSString *)strContent
                                  type:(NSString *)strType
                                typeId:(NSString *)strTypeId
                                   pid:(NSString *)strPid
                                  puid:(NSString *)strPuid
                                at_ids:(NSString *)strAtIds
                               success:(BdRequestSuccess)successBlock
                                  fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddComment];
    
    [params setObject:strContent forKey:@"content"];
    [params setObject:strTypeId forKey:@"typeId"];
    [params setObject:strType forKey:@"type"];
    
    if (strPid) {
        [params setObject:strPid forKey:@"pid"];
    }
    if (strPuid) {
        [params setObject:strPuid forKey:@"puid"];
    }
    if (strAtIds) {
        [params setObject:strAtIds forKey:@"at_ids"];
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

+ (NSOperation *)addSupportType:(NSString *)strType
                         typeId:(NSString *)strTypeId
                            del:(NSString *)strDel
                        success:(BdRequestSuccess)successBlock
                           fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddSupprotDynamic];
    
    [params setObject:strTypeId forKey:@"typeId"];
    [params setObject:strType forKey:@"type"];
    [params setObject:strDel forKey:@"del"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)deleteDynamicById:(NSString *)did
                           success:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiDeleteDynamic];
    
    [params setObject:did forKey:@"id"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"ErrorModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+(NSOperation *)getCommentListType:(NSString *)strType
                            typeId:(NSString *)strTypeId
                             curId:(NSString *)strCurid
                               num:(int)num
                             newer:(BOOL)isNewer
                           success:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetDynamicCommentList];
    
    [params setObject:strTypeId forKey:@"typeId"];
    [params setObject:strCurid forKey:@"curId"];
    [params setObject:strType forKey:@"type"];
    [params setObject:@(num) forKey:@"num"];
    [params setObject:@(isNewer) forKey:@"newer"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"DynamicsCommentModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}
@end











