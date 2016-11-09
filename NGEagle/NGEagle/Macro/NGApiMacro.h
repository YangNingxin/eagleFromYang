//
//  NGApiMacro.h
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//
#import "RegisterApiMacro.h"
#import "NoteApiMacro.h"
#import "ChatApiMacro.h"

#define kMainPageURL @"/index.php?app=webapp&mod=Index&act=index"

#define KFindURL @"/index.php?app=webapp&mod=Find&act=index"

// 开机接口
#define kApiBoot @"/index.php?app=interface&mod=System&act=boot"

// 获取所有学校节点
#define kApiGetAllLoginNode @"/index.php?app=interface&mod=User&act=getAllLoginNode"

// 获取热门学校节点
#define kApiGetHotLoginNode @"/index.php?app=interface&mod=User&act=getHotLoginNode"

// 登录
#define kApiLoginById @"/index.php?app=interface&mod=User&act=smartLoginByNode"

// 第三方token登录
#define kApiLoginByOtherToken @"/index.php?app=interface&mod=User&act=loginByOtherToken"

// 手机或者其他登录方式
#define kApiLoginByPhone @"/index.php?app=interface&mod=User&act=loginByTypeAndId"

// 获取验证码
#define kApiGetVerifyCode @"/index.php?app=interface&mod=User&act=getVerifyCode"

// 手机号注册
#define kApiRegisterWithVerifyCode @"/index.php?app=interface&mod=User&act=registerWithVerifyCode"

//绑定手机号
#define kApiBindTelephoneWithVerifyCode @"/index.php?app=interface&mod=User&act=bindTelephoneWithVerifyCode"

// 忘记密码，重置密码
#define kApiResetPwdWithVerifyCode @"/index.php?app=interface&mod=User&act=resetPwdWithVerifyCode"

// 完善用户信息

#define kApiChangeUserInfo @"/index.php?app=interface&mod=User&act=changeUserInfo"

// 取消预约的课程
#define kApiCancelCourseClass @"/index.php?app=interface&mod=Opencourse&act=cancelCourseClass"

// 预约课程
#define kApiAppointCourseClass @"/index.php?app=interface&mod=Opencourse&act=appointCourseClass"

// 获取课程开班详情
#define kApiGetCourseClassDetail @"/index.php?app=interface&mod=Opencourse&act=getCourseClassDetail"

// 获取课程班级列表
#define kApiGetCourseClassList @"/index.php?app=interface&mod=Opencourse&act=getCourseClassList"

// 根据任务ID获取班级列表
#define kApiGetClassByTaskId @"/index.php?app=interface&mod=Opencourse&act=getClassByTaskId"

// 根据任务ID，获取答案列表
#define kApiGetTaskAnswersByTaskId @"/index.php?app=interface&mod=Opencourse&act=getTaskAnswersByTaskId"

// 获取学生任务单的提交情况
#define kApiGetStudentsStatusByTaskAndClass @"/index.php?app=interface&mod=Opencourse&act=getStudentsStatusByTaskAndClass"

// 修改任务答案状态
#define kApiModifyTaskAnswerStatus @"/index.php?app=interface&mod=Opencourse&act=modifyTaskAnswerStatus"

// 机构关注取消接口
#define kApiDeleteFollow @"/index.php?app=interface&mod=Action&act=deleteFollow"

// 机构关注接口
#define kApiAddFollow @"/index.php?app=interface&mod=Action&act=addFollow"

// 课程/任务单取消赞接口
#define kApiDeleteSupport @"/index.php?app=interface&mod=Action&act=deleteSupport"

// 课程/任务单赞接口
#define kApiAddSupport @"/index.php?app=interface&mod=Action&act=addSupport"


// 获取机构类型列表
#define kApiGetOrganizationTypes @"/index.php?app=interface&mod=Opencourse&act=getOrganizationTypes"

// 获取课程分类
#define kApiGetCourseTypes @"/index.php?app=interface&mod=Opencourse&act=getOpencourseFilter"

// 获取热搜词
#define kApiGetHotSearchWords @"/index.php?app=interface&mod=Opencourse&act=getHotSearchWords"


// 获取机构详情
#define kApiGetOrganizationInfo @"/index.php?app=interface&mod=Opencourse&act=getOrganizationInfo"

// 获取开放课程优秀的学生任务单
#define kApiGetTaskAnswersByCourseId @"/index.php?app=interface&mod=Opencourse&act=getTaskAnswersByCourseId"

// 提交完成的任务单
#define kApiSubmitTaskAnswer @"/index.php?app=interface&mod=Opencourse&act=submitTaskAnswer"

// 获取课程任务单
#define kApiGetCourseTasks @"/index.php?app=interface&mod=Opencourse&act=getCourseTasks"

// 老师端修改班次状态
#define kApiModifyOpenclasssStatus @"/index.php?app=interface&mod=Opencourse&act=modifyOpenclasssStatus"

// 获取课程指导
#define kApiGetCourseLessons @"/index.php?app=interface&mod=Opencourse&act=getCourseLessons"

// 获取课程基本信息
#define kApiGetCourseBasicInfo @"/index.php?app=interface&mod=Opencourse&act=getCourseBasicInfo"

// 获取课程列表
#define kApiGetCourseList @"/index.php?app=interface&mod=Opencourse&act=getCourseList"

// 获取特殊群组用户 获取如学校、班级、体育等群组用户
#define kApiGetGroupUser @"/index.php?app=interface&mod=Group&act=getGroupUser"

// 上传logo
#define kApiUploadLogo @"/index.php?app=interface&mod=Resource&act=uploadLogo"

// 获取课程的预约状态
#define kApiGetCourseAppointmentInfo @"/index.php?app=interface&mod=Opencourse&act=getCourseAppointmentInfo"

// 获取班级的预约状态信息
#define kApiGetClassAppointmentInfo @"/index.php?app=interface&mod=Opencourse&act=getClassAppointmentInfo"

// 评价系统--获取特定对象的评价列表
#define kApiGetAppraises @"/index.php?app=interface&mod=Action&act=getAppraises"

// 添加评论
#define kApiAddAppraise @"/index.php?app=interface&mod=Action&act=addAppraise"

// 评价系统--获取评价的标签列表
#define kApiGetAppraiseTags @"/index.php?app=interface&mod=Action&act=getAppraiseTags"

// 获取机构列表
#define kApiGetOrganizationList @"/index.php?app=interface&mod=Opencourse&act=getOrganizationList"

// 获取我所在的机构
#define kApiGetMyOrganization @"/index.php?app=interface&mod=Opencourse&act=getMyOrganization"

// 获取附近课程列表
#define kApiGetNearbyCourseList @"/index.php?app=interface&mod=Opencourse&act=getNearbyCourseList"

// 获取个人财富
#define kApiGetWealth @"/index.php?app=interface&mod=User&act=getWealth"

// 获取交易记录
#define kApiGetTradingRecordsForOpencourse @"/index.php?app=interface&mod=Pay&act=getTradingRecordsForOpencourse"

// 删除一条交易记录
#define kApiDeleteTradingRecord @"/index.php?app=interface&mod=Pay&act=deleteTradingRecord"

// 获取正在学习的课程
#define kApiGetStudyCourseList @"/index.php?app=interface&mod=Opencourse&act=getStudyCourseList"

// 修改密码
#define kApiModifyPassword @"/index.php?app=interface&mod=User&act=resetPwd"

// 验证用户密码
#define kApiCheckPassword @"/index.php?app=interface&mod=User&act=checkPassword"

// 检查是否有新的消息
#define kApiCheckMessage @"/index.php?app=interface&mod=User&act=checkMessage"

// 获取课程消息列表
#define kApiGetOpencourseMessage @"/index.php?app=interface&mod=Opencourse&act=getOpencourseMessage"

// 获取自己关注的机构列表数
#define kApiGetFollowOrganizationList @"/index.php?app=interface&mod=Opencourse&act=getFollowOrganizationList"

// 获取所有学科列表
#define kApiGetAllSubjectInfoForXuehu @"/index.php?app=interface&mod=Knowledge&act=getAllSubjectInfoForXuehu"


// 获取推荐课程
#define kApiGetRecommendCourses @"/index.php?app=interface&mod=Weike&act=getRecommendCourses"
// 获取微课列表
#define kApiGetWeikeList @"/index.php?app=interface&mod=Weike&act=getList"
#define kApiGetWeikeAlbumList @"/index.php?app=interface&mod=WeikeAlbum&act=getList"
// 课程筛选
#define kApiGetTypeFilters @"/index.php?app=interface&mod=Xuehu&act=getTypeFilters"
// 获取订阅
#define kApiGetUserSubscribeTagDetail @"/index.php?app=interface&mod=User&act=getUserSubscribeTagDetail"

// 获取订阅知识点
#define kApiGetUserTagSubscribeInfo @"/index.php?app=interface&mod=User&act=getUserTagSubscribeInfo"
// 订阅标签
#define kApiSetUserTag @"/index.php?app=interface&mod=User&act=setUserTag"
// 删除订阅标签
#define kApiDelUserTag @"/index.php?app=interface&mod=User&act=delUserTag"
// 获取订阅的时候，筛选的年级和学科
#define kApiGetStageAndSubjects @"/index.php?app=interface&mod=Knowledge&act=getStageAndSubjects"
// 订阅--根据订阅的知识点id更换匹配的微课
#define kApiChangeSubscribeTagCourses @"/index.php?app=interface&mod=User&act=changeSubscribeTagCourses"
// 添加课程评论
#define kApiAddCourseComment @"/index.php?app=interface&mod=Comment&act=addComment"
// 添加课程笔记
#define kApiAddCourseNote @"/index.php?app=interface&mod=Note&act=addNote"
// 创建提问
#define kApiCreateQuestion @"/index.php?app=interface&mod=Question&act=create"
// 上传资源
#define kApiUploadResource @"/index.php?app=interface&mod=Resource&act=upload"
// 获取举报内容
#define kApiGetReportList @"/index.php?app=interface&mod=User&act=getReportReasons"
// 举报getUserStudyRecord
#define kApiReport @"/index.php?app=interface&mod=User&act=report"

// 获取推荐给我的微课
#define kApiGetPublishToMeWeike @"/index.php?app=interface&mod=Weike&act=getPublishToMeWeike"
// 获取推荐给我的课程集
#define kApiGetPublishToMeAlbum @"/index.php?app=interface&mod=WeikeAlbum&act=getPublishToMeAlbum"
// 获取自己的学习记录
#define kApiGetUserStudyRecord  @"/index.php?app=interface&mod=Weike&act=getUserStudyRecord"

// 获取我收藏的微课列表
#define kApiGetCollection @"/index.php?app=interface&mod=Weike&act=getCollection"
// 获取收藏的微课集
#define kApiGetCollectionAlbum @"/index.php?app=interface&mod=WeikeAlbum&act=getCollectionList"

// 获取我推荐的微课
#define kApiGetMyPublishWeike @"/index.php?app=interface&mod=Weike&act=getMyPublishWeike"
// 获取我推荐的课程集                   /index.php?app=interface&mod=WeikeAlbum&act=getMyPublishAlbum
#define kApiGetMyPublishWeikeAlbum @"/index.php?app=interface&mod=WeikeAlbum&act=getMyPublishAlbum"

// 获取问答列表
#define kApiGetQuestionList @"/index.php?app=interface&mod=Question&act=getQuestionList"
// 获取问题详情
#define kApiGetQuestionDetail @"/index.php?app=interface&mod=Question&act=getQuestionDetail"
// 获取问题的答案
#define kApiGetQuestionAnswer @"/index.php?app=interface&mod=Question&act=getQuestionAnswer"
// 获取问题和答案的混排
#define kApiGetContinueAskDetail @"/index.php?app=interface&mod=Question&act=getContinueAskDetail"
// 回答问题
#define kApiCreateAnswer @"/index.php?app=interface&mod=Question&act=answerQuestion"
// 采纳答案
#define kApiAcceptQuestionAnswer @"/index.php?app=interface&mod=Question&act=acceptQuestionAnswer"

/**
 *  课程的筛选
 */
// 学生端
#define kApiGetPublishToMeWeikeFilter @"/index.php?app=interface&mod=Weike&act=getPublishToMeWeikeFilter"
#define kApiGetPublishToMeAlbumFilter @"/index.php?app=interface&mod=WeikeAlbum&act=getPublishToMeAlbumFilter"
// 老师端
#define kApiGetWeikeAlbumListFilter @"/index.php?app=interface&mod=WeikeAlbum&act=getListFilter"
#define kApiGetWeikeListFilter @"/index.php?app=interface&mod=Weike&act=getListFilter"

/****h5****/
#define kApiShouYeH5 @"/index.php?app=webapp&mod=Index&act=appIndex"




