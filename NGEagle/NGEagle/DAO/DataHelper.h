//
//  DataHelper.h
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHttpRequest.h"

@interface DataHelper : NSObject

// 开机接口
+ (NSOperation *)getBootData:(BdRequestSuccess)successBlock
                        fail:(BdRequestFail)failBlock;

// 获取登录节点
+ (NSOperation *)getAllLoginNodeWithKeyWord:(NSString *)kw
                                    success:(BdRequestSuccess)successBlock
                                       fail:(BdRequestFail)failBlock;
// 获取所有学科
+ (NSOperation *)getAllSubjectInfoForXuehu:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock;

// 获取热门学校节点
+ (NSOperation *)getHotLoginNode:(BdRequestSuccess)successBlock
                            fail:(BdRequestFail)failBlock;

/**
 *  节点登录
 *
 *  @param node_id      节点id
 *  @param username     用户名
 *  @param password     密码
 *  @param ey           是否加密
 */
+ (NSOperation *)loginByNode:(NSString *)node_id
                    username:(NSString *)username
                    password:(NSString *)password
                          ey:(BOOL)ey
                     success:(BdRequestSuccess)successBlock
                        fail:(BdRequestFail)failBlock;

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
                              fail:(BdRequestFail)failBlock;

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
                            fail:(BdRequestFail)failBlock;

/**
 *  获取验证码
 *
 *  @param phone        手机号
 *  @param register_flag   手机号 //是否是注册使用，0表示不是，1表示是。1时，接口会检测手机号是否已经被注册
 *  @param successBlock <#successBlock description#>
 *  @param failBlock    <#failBlock description#>
 *
 *  @return <#return value description#>
 */
+ (NSOperation *)getVerifyCode:(NSString *)phone
                 register_flag:(BOOL)register_flag
                       success:(BdRequestSuccess)successBlock
                          fail:(BdRequestFail)failBlock;


/**
 *  手机号注册
 *
 *  @param code         验证码
 *  @param telephone    手机号
 *  @param type         类型
 *  @param pwd          密码
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)registerWithVerifyCode:(NSString *)code
                              telephone:(NSString *)telephone
                                   type:(int)type
                                    pwd:(NSString *)pwd
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock;

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
                                        fail:(BdRequestFail)failBlock;

/**
 *  完善用户信息
 *
 *  @param params       字段太多选择字典
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)changeUserInfoWithDictParams:(NSDictionary *)params
                                      success:(BdRequestSuccess)successBlock
                                         fail:(BdRequestFail)failBlock;

+ (NSOperation *)uploadLogo:(UIImage *)image
                    success:(BdRequestSuccess)successBlock
                       fail:(BdRequestFail)failBlock;

/**
 *  获取课程列表
 *
 *  @param page         页码
 *  @param page_num     页数
 *  @param sort         排序方式，1--最新，2--最热（访问量）
 *  @param school_id    机构对应的学校id，即机构信息里面的id
 *  @param category_id  课程分类id，从分类接口获取
 *  @param lat          当前用户所在的纬度
 *  @param lon          当前用户所在的经度
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getCourseList:(int)page
                      page_num:(int)page_num
                          sort:(int)sort
                           lat:(float)lat
                          lon:(float)lon
                            kw:(NSString *)kw
                        params:(NSDictionary *)params2
                       success:(BdRequestSuccess)successBlock
                          fail:(BdRequestFail)failBlock;

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
                            fail:(BdRequestFail)failBlock;

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
                                                 fail:(BdRequestFail)failBlock;


/**
 *  获取课程分类
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getCourseTypes:(BdRequestSuccess)successBlock
                           fail:(BdRequestFail)failBlock;

/**
 *  获取机构类型列表
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getOrganizationTypes:(BdRequestSuccess)successBlock
                                 fail:(BdRequestFail)failBlock;


/**
 *  获取热搜词
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getHotSearchWords:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock;


/**
 *  获取课程班级列表
 *
 *  @param course_id    课程id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getCourseClassListWithCourseId:(int)course_id
                                           page:(int)page
                                        pageNum:(int)pageNum
                                        success:(BdRequestSuccess)successBlock
                                           fail:(BdRequestFail)failBlock;


/**
 *  预约课程
 *
 *  @param course_id    课程id
 *  @param class_id     班级id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)appointCourseClassWithCourseId:(int)course_id
                                       class_id:(int)class_id
                                        success:(BdRequestSuccess)successBlock
                                           fail:(BdRequestFail)failBlock;

/**
 *  取消预约
 *
 *  @param course_id    课程id
 *  @param class_id     班级id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)cancelCourseClassWithCourseId:(int)course_id
                                      class_id:(int)class_id
                                       success:(BdRequestSuccess)successBlock
                                          fail:(BdRequestFail)failBlock;

/**
 *  根据课程id获取课程的预约状态，包括一共多少班，还有几个班可以预约，当前用户是否可以预约，已经预约开课的班级id
 *
 *  @param course_id    课程id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getCourseAppointmentInfo:(int)course_id
                                  success:(BdRequestSuccess)successBlock
                                     fail:(BdRequestFail)failBlock;

/**
 *  获取班级的预约状态信息
 *
 *  @param class_id     班级id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getClassAppointmentInfo:(int)class_id
                                 success:(BdRequestSuccess)successBlock
                                    fail:(BdRequestFail)failBlock;


/**
 *  获取特定对象的评价列表
 *
 *  @param type_id      对象的id
 *  @param type         评价的类型，1表示开放课程
 *  @param page
 *  @param pageNum
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getAppraisesWithTypeID:(int)type_id
                                   type:(int)type
                                   page:(int)page
                                pageNum:(int)pageNum
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock;


/**
 *  评价系统--获取评价的标签列表
 *
 *  @param type         0表示通用类型，1表示开放课程类型
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getAppraiseTagsWithType:(int)type
                                 success:(BdRequestSuccess)successBlock
                                    fail:(BdRequestFail)failBlock;

/**
 *  添加评论
 *
 *  @param type         评价的对象类型，1表示开放课程
 *  @param type_id      评价的对象id
 *  @param tag          选择的标签id，多个用英文逗号分隔
 *  @param star         评的星级，1到5
 *  @param content      内容
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)addAppraiseWithType:(int)type
                             type_id:(int)type_id
                                 tag:(NSString *)tag
                                star:(float)star
                             content:(NSString *)content
                             success:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock;

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
                                   fail:(BdRequestFail)failBlock;

/**
 *  重置密码
 *
 *  @param telephone    手机号
 *  @param pwd1
 *  @param pwd2
 *  @param code
 *  @param ey
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)resetPwdWithVerifyCode:(NSString *)telephone
                                   pwd1:(NSString *)pwd1
                                   pwd2:(NSString *)pwd2
                                   code:(NSString *)code
                                     ey:(BOOL)ey
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock;

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
                                  fail:(BdRequestFail)failBlock;

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
                                fail:(BdRequestFail)failBlock;

/**
 *  获取我所在机构
 *
 *  @param successBlock 成功
 *  @param failBlock    失败
 *
 *  @return
 */
+ (NSOperation *)getMyOrganization:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock;
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
                                fail:(BdRequestFail)failBlock;

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
                                     fail:(BdRequestFail)failBlock;

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
                                 fail:(BdRequestFail)failBlock;

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
                                       fail:(BdRequestFail)failBlock;

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
                                   fail:(BdRequestFail)failBlock;

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
                                            fail:(BdRequestFail)failBlock;
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
                                             fail:(BdRequestFail)failBlock;

/**
 *  获取个人财富
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getWealth:(BdRequestSuccess)successBlock
                      fail:(BdRequestFail)failBlock;

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
                                               fail:(BdRequestFail)failBlock;

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
                                      fail:(BdRequestFail)failBlock;

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
                                       fail:(BdRequestFail)failBlock;

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
                                      fail:(BdRequestFail)failBlock;

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
                          fail:(BdRequestFail)failBlock;

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
                                           fail:(BdRequestFail)failBlock;

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
                                  fail:(BdRequestFail)failBlock;

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
                                               fail:(BdRequestFail)failBlock;

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
                           fail:(BdRequestFail)failBlock;
/**
 *  获取举报类型
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getReportList:(BdRequestSuccess)successBlock
                          fail:(BdRequestFail)failBlock;

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
                         fail:(BdRequestFail)failBlock;

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
                                  fail:(BdRequestFail)failBlock;

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
                                       fail:(BdRequestFail)failBlock;

// 获取学习记录
+ (NSOperation *)getUserStudyRecordByPage:(int)page
                                      num:(int)num
                                  success:(BdRequestSuccess)successBlock
                                     fail:(BdRequestFail)failBlock;

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
                                            fail:(BdRequestFail)failBlock;

// 获取推荐给我的微课
+ (NSOperation *)getPublishToMeWeikeByPage:(int)page
                                       num:(int)num
                                subject_id:(int)subject_id
                                  grade_id:(int)grade_id
                                   success:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock;

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
                                  fail:(BdRequestFail)failBlock;

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
                            fail:(BdRequestFail)failBlock;












+ (void)setCookieWithURL:(NSString *)url;

// 清空cookie
+ (void)clearCookie;

+ (JSONModel *)praseClassData:(NSString *)className responseObject:(id)responseObject;

@end
