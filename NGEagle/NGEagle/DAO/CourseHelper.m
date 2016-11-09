//
//  CourseHelper.m
//  NGEagle
//
//  Created by Liang on 16/5/1.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CourseHelper.h"

@implementation CourseHelper

/**
 *  获取课程列表
 *
 *  @param page         页码
 *  @param num
 *  @param type         目前1
 *  @param school_id    学校id，校内时填写
 *  @param course_type  课程类型，501--微课，505--同步课程
 *  @param params2
 *  @param kw
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getWeikeList:(int)page
                          num:(int)num
                         type:(int)type
                    school_id:(int)school_id
                       params:(NSDictionary *)params2
                           kw:(NSString *)kw
                    self_flag:(int)self_flag
                      success:(BdRequestSuccess)successBlock
                         fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetWeikeList];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(num) forKey:@"num"];
    [params setObject:@(self_flag) forKey:@"self_flag"];
    [params setObject:@(1) forKey:@"type"];
    [params setObject:@(school_id) forKey:@"school_id"];

    if (kw) {
        [params setObject:kw forKey:@"kw"];
    }
    
    if (params2) {
        [params addEntriesFromDictionary:params2];
    }
    
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取我推荐的微课
 *
 *  @param page
 *  @param num
 *  @param type_id      微课类型id
 *  @param subject_id   学科id
 *  @param stage_id     学段id
 *  @param grade_id     年级id
 *  @param kw
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getMyPublishWeikeList:(int)page
                                   num:(int)num
                               type_id:(int)type_id
                            subject_id:(int)subject_id
                              stage_id:(int)stage_id
                              grade_id:(int)grade_id
                                    kw:(NSString *)kw
                               success:(BdRequestSuccess)successBlock
                                  fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetMyPublishWeike];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(num) forKey:@"num"];
    [params setObject:@(type_id) forKey:@"type_id"];
    [params setObject:@(subject_id) forKey:@"subject_id"];
    [params setObject:@(grade_id) forKey:@"grade_id"];
    [params setObject:@(grade_id) forKey:@"grade_id"];

    if (kw) {
        [params setObject:kw forKey:@"kw"];
    }
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取课程集
 *
 *  @param page页码
 *  @param num
 *  @param type
 *  @param school_id    学校id，校内时填写
 *  @param kw
 *  @param self_flag    0--全部，1--只取自己发布的，2--除自己发布的之外的
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getWeikeAlbum:(int)page
                           num:(int)num
                          type:(int)type
                     school_id:(int)school_id
                            kw:(NSString *)kw
                     self_flag:(int)self_flag
                       success:(BdRequestSuccess)successBlock
                          fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetWeikeAlbumList];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(num) forKey:@"num"];
    
    [params setObject:@(1) forKey:@"type"];
    [params setObject:@(school_id) forKey:@"school_id"];
    [params setObject:@(self_flag) forKey:@"self_flag"];

    if (kw) {
        [params setObject:kw forKey:@"kw"];
    }
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取我推荐的课程集
 */
+ (NSOperation *)getMyPublishWeikeAlbumList:(int)page
                                        num:(int)num
                                    type_id:(int)type_id
                                 subject_id:(int)subject_id
                                   stage_id:(int)stage_id
                                   grade_id:(int)grade_id
                                         kw:(NSString *)kw
                                    success:(BdRequestSuccess)successBlock
                                       fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetMyPublishWeikeAlbum];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(num) forKey:@"num"];
    [params setObject:@(type_id) forKey:@"type_id"];
    [params setObject:@(subject_id) forKey:@"subject_id"];
    [params setObject:@(grade_id) forKey:@"grade_id"];
    [params setObject:@(grade_id) forKey:@"grade_id"];
    
    if (kw) {
        [params setObject:kw forKey:@"kw"];
    }
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}
/**
 *  获取推荐课程
 *
 *  @param type         获取推荐课程类型，0表示全部（获取云课堂时使用）,1表示校内
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getRecommendCourses:(int)type
                             success:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetRecommendCourses];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
 
    [params setObject:@(type) forKey:@"type"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}


/**
 *  获取课程筛选
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getCourseTypeFilters:(BdRequestSuccess)successBlock
                                 fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetTypeFilters];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CourseFilterListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}
/**
 *  获取订阅列表
 *
 *  @param type         订阅的标签类型，1--学科，2--知识点。目前只支持2
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getUserSubscribeTagDetail:(int)type
                                      page:(int)page
                                       num:(int)num
                                   success:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetUserSubscribeTagDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(2) forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(num) forKey:@"num"];

    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"SubscribeTagListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  获取用户关于知识点和学科的订阅状态
 *
 *  @param type         1--学科，2--知识点
 *  @param stage_id     学段id
 *  @param subject_id   学科id
 *  @param weike_stat   是否统计绑定的微课数量，0--不统计，1--统计。目前只考虑微课数量
 *  @param album_stat   是否统计绑定的课程集数量，0--不统计，1--统计。暂不考虑
 *  @param page
 *  @param num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getUserTagSubscribeInfo:(int)type
                                stage_id:(int)stage_id
                              subject_id:(int)subject_id
                              weike_stat:(int)weike_stat
                              album_stat:(int)album_stat
                                    page:(int)page
                                     num:(int)num
                                 success:(BdRequestSuccess)successBlock
                                    fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetUserTagSubscribeInfo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(2) forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(num) forKey:@"num"];
    
    [params setObject:@(weike_stat) forKey:@"weike_stat"];
    [params setObject:@(stage_id) forKey:@"stage_id"];
    [params setObject:@(subject_id) forKey:@"subject_id"];

    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"UserTagSubscribeModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}
/**
 *  设置用户标签
 *
 *  @param type         1学科，2知识点
 *  @param ids          type下对应的id串，逗号分隔
 *  @param action       添加的方式，0--重置,会删除之前设置的，1--新增
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)setUserTag:(int)type
                        ids:(NSString *)ids
                     action:(int)action
                    success:(BdRequestSuccess)successBlock
                       fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiSetUserTag];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(2) forKey:@"type"];
    [params setObject:ids forKey:@"ids"];
    [params setObject:@(action) forKey:@"action"];
    
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
 *  删除用户标签
 *
 *  @param type         1学科，2知识点
 *  @param ids          type下对应的id串，逗号分隔
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)delUserTag:(int)type
                        ids:(NSString *)ids
                    success:(BdRequestSuccess)successBlock
                       fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiDelUserTag];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(2) forKey:@"type"];
    [params setObject:ids forKey:@"ids"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"StageAndSubjectsModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}
/**
 *  一次性获取所有学段和学科
 *
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getStageAndSubjects:(BdRequestSuccess)successBlock
                                fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetStageAndSubjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"StageAndSubjectsModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  订阅--根据订阅的知识点id更换匹配的微课 edit delete
 *
 *  @param type         标签的类型，1--学科，2--知识点，目前只支持2
 *  @param target_id    知识点id
 *  @param cur_id       上次更换时返回的课程列表，最后一个的课程id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)changeSubscribeTagCourses:(int)type
                                 target_id:(int)target_id
                                    cur_id:(int)cur_id
                                   success:(BdRequestSuccess)successBlock
                                      fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiChangeSubscribeTagCourses];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(target_id) forKey:@"target_id"];
    [params setObject:@(cur_id) forKey:@"cur_id"];

    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CCCourseListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  添加评论，具备盖楼和@的功能
 *
 *  @param type         评论对象的类型：0--动态,1--回答，5--微课，6--课程集，7--开放课程，8--课程集的课时
 *  @param typeId       评论对象的id
 *  @param content      内容
 *  @param pid          如果是回复某条评论，填写要回复的评论的id
 *  @param puid         如果是回复某条评论，填写要回复的评论的作者id
 *  @param at_ids       需要@某些人时，填写要@的用户id，多个id之间用英文逗号分隔
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)addComment:(int)type
                     typeId:(int)typeId
                    content:(NSString *)content
                        pid:(int)pid
                       puid:(int)puid
                     at_ids:(NSString *)at_ids
                    success:(BdRequestSuccess)successBlock
                       fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddCourseComment];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(typeId) forKey:@"typeId"];
    [params setObject:@(pid) forKey:@"pid"];
    [params setObject:@(puid) forKey:@"puid"];
    [params setObject:content forKey:@"content"];
    if (at_ids) {
        [params setObject:at_ids forKey:@"at_ids"];
    }
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"AddCommentSuccess"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  添加笔记
 *
 *  @param type         创建笔记的对象类型，1--微课，2--课程集的课时
 *  @param target_id    对象id
 *  @param content      笔记内容
 *  @param mark_at      针对微课有效，表示添加笔记时微课的播放时间
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)addNote:(int)type
               target_id:(int)target_id
                 content:(NSString *)content
                 mark_at:(int)mark_at
                 success:(BdRequestSuccess)successBlock
                    fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAddCourseNote];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(target_id) forKey:@"target_id"];
    [params setObject:@(mark_at) forKey:@"mark_at"];
    [params setObject:content forKey:@"content"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"AddNoteSuccess"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  发布提问
 *
 *  @param content           提问内容
 *  @param stage_id          学段id
 *  @param grade_id          年级id
 *  @param subject_id        学科id
 *  @param desc_image        描述图片md串，多个逗号分隔
 *  @param desc_link         描述链接，多个逗号分隔
 *  @param structure_ids     知识点标签id串，多个逗号分隔
 *  @param to_user_ids       发布用户id串，多个逗号分隔
 *  @param is_anonymous      是否匿名提问
 *  @param domain            问题的类型, 0--普通, 1--课件, 2--微课, 3--试题, 4--课程集, 5--课时
 *  @param target_id         domain不为0时, 针对的类型id
 *  @param mark_at           domain为1时有效，表示添加试题时对应的微课播放时间，单位s
 *  @param desc_video        描述视频md串，多个逗号分隔
 *  @param desc_audio        描述音频md串，多个逗号分隔
 *  @param closely_answer_id 追问时, 设置追问的答案的id，当连续追问时，都填写第一个回答的id，表明后续都是由这个回答引起的追问。
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)createQuestion:(NSString *)content
                       stage_id:(int)stage_id
                       grade_id:(int)grade_id
                     subject_id:(int)subject_id
                     desc_image:(NSString *)desc_image
                      desc_link:(NSString *)desc_link
                  structure_ids:(NSString *)structure_ids
                    to_user_ids:(NSString *)to_user_ids
                   is_anonymous:(BOOL)is_anonymous
                         domain:(int)domain
                      target_id:(int)target_id
                        mark_at:(int)mark_at
                     desc_video:(NSString *)desc_video
                     desc_audio:(NSString *)desc_audio
              closely_answer_id:(int)closely_answer_id
                        success:(BdRequestSuccess)successBlock
                           fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiCreateQuestion];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:content forKey:@"content"];
    [params setObject:@(stage_id) forKey:@"stage_id"];
    [params setObject:@(grade_id) forKey:@"grade_id"];
    [params setObject:@(subject_id) forKey:@"subject_id"];
    
    if (desc_image) {
        [params setObject:desc_image forKey:@"desc_image"];
    }
    if (desc_link) {
        [params setObject:desc_link forKey:@"desc_link"];
    }
    if (structure_ids) {
        [params setObject:structure_ids forKey:@"structure_ids"];
    }
    if (to_user_ids) {
        [params setObject:to_user_ids forKey:@"to_user_ids"];
    }
    [params setObject:@(is_anonymous) forKey:@"is_anonymous"];
    [params setObject:@(domain) forKey:@"domain"];
    [params setObject:@(target_id) forKey:@"target_id"];
    [params setObject:@(mark_at) forKey:@"mark_at"];
    [params setObject:@(closely_answer_id) forKey:@"closely_answer_id"];
    if (desc_video) {
        [params setObject:desc_video forKey:@"desc_video"];
    }
    if (desc_audio) {
        [params setObject:desc_audio forKey:@"desc_audio"];
    }
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"CreateQuestionModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

+ (NSOperation *)createAnswer:(NSString *)content
                  question_id:(int)question_id
                   desc_image:(NSString *)desc_image
                    desc_link:(NSString *)desc_link
                   desc_video:(NSString *)desc_video
                   desc_audio:(NSString *)desc_audio
                      success:(BdRequestSuccess)successBlock
                         fail:(BdRequestFail)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiCreateAnswer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:content forKey:@"content"];
   
    [params setObject:@(question_id) forKey:@"question_id"];

    if (desc_image) {
        [params setObject:desc_image forKey:@"desc_image"];
    }
    if (desc_link) {
        [params setObject:desc_link forKey:@"desc_link"];
    }
    if (desc_video) {
        [params setObject:desc_video forKey:@"desc_video"];
    }
    if (desc_audio) {
        [params setObject:desc_audio forKey:@"desc_audio"];
    }
    NSOperation *operation = [BaseHttpRequest POST:url parameters:params fileParameters:nil success:^(id responseObject) {
        successBlock([self praseClassData:@"CreateAnswerModel" responseObject:responseObject]);
    } failure:failBlock];
//    NSOperation *operation = [BaseHttpRequest GET:url
//                                       parameters:params
//                                          success:^(id responseObject) {
//                                              successBlock([self praseClassData:@"CreateQuestionModel"
//                                                                 responseObject:responseObject]);
//                                          }
//                                          failure:failBlock];
    return operation;
}
/**
 *  根据问题ID获取回答列表
 *
 *  @param questionId   问题Id
 *  @param page
 *  @param num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getQuestionAnswerByQuestionId:(int)questionId
                                          page:(int)page
                                           num:(int)num
                                       success:(BdRequestSuccess)successBlock
                                          fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetQuestionAnswer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(questionId) forKey:@"id"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(num) forKey:@"num"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"QuestionListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  根据问题ID获取问题详情
 *
 *  @param questionId   问题Id
 *  @param page
 *  @param num
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getQuestionDetailQuestionId:(int)questionId
                                     success:(BdRequestSuccess)successBlock
                                        fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetQuestionDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(questionId) forKey:@"id"];
  
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"QuestionDetailModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;

}
/**
 *  根据问题id和回答id，获取混排的问题和答案数据
 *
 *  @param questionId   问题Id
 *  @param answer_id    回答id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getContinueAskDetailByQuestionId:(int)questionId
                                        answer_id:(int)answer_id
                                          success:(BdRequestSuccess)successBlock
                                             fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiGetContinueAskDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(answer_id) forKey:@"answer_id"];
    [params setObject:@(questionId) forKey:@"question_id"];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"QuestionListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}

/**
 *  采纳档案
 *
 *  @param questionId   问题id
 *  @param answer_id    答案id
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)acceptQuestionAnswer:(int)questionId
                            answer_id:(int)answer_id
                              success:(BdRequestSuccess)successBlock
                                 fail:(BdRequestFail)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiAcceptQuestionAnswer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(answer_id) forKey:@"answer_id"];
    [params setObject:@(questionId) forKey:@"question_id"];
    
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
 *  获取筛选信息
 *
 *  @param type         0 推荐给我的课程，1 推荐给我的课程集，2 老师我的课程，3 老师我的课程集
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getFilterInfoType:(int)type
                           success:(BdRequestSuccess)successBlock
                              fail:(BdRequestFail)failBlock {
    NSString *api;
    switch (type) {
        case 0:
            api = kApiGetPublishToMeWeikeFilter;
            break;
        case 1:
            api = kApiGetPublishToMeAlbumFilter;
            break;
        case 2:
            api = kApiGetWeikeListFilter;
            break;
        case 3:
            api = kApiGetWeikeAlbumListFilter;
            break;
        default:
            break;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, api];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:params
                                          success:^(id responseObject) {
                                              successBlock([self praseClassData:@"FilterListModel"
                                                                 responseObject:responseObject]);
                                          }
                                          failure:failBlock];
    return operation;
}
@end
