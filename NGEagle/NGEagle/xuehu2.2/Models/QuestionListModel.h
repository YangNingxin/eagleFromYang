//
//  QuestionListModel.h
//  NGEagle
//
//  Created by Liang on 16/5/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ItemModel.h"
#import "ErrorModel.h"


@protocol CCQuestion <NSObject>
@end

@protocol QuestionResource <NSObject>
@end

@protocol MediaObject <NSObject>
@end

@class QuestionResource;

/**
 *  问题和回答复用
 */
@interface QuestionListModel : ErrorModel

@property (nonatomic, strong) NSArray<CCQuestion> *data;

@end

@interface CCQuestion : JSONModel

@property (nonatomic) int qid ;//99",
@property (nonatomic, strong) NSString *title;
@property (nonatomic) int type ;//0",
@property (nonatomic) float price ;//0",
@property (nonatomic) int parent_id ;//0",
@property (nonatomic) int closely_answer_id ;//0",
@property (nonatomic) int auth_id ;//6",
@property (nonatomic) int user_id ;//15",
@property (nonatomic) int class_id ;//50",
@property (nonatomic) int school_id ;//10",
@property (nonatomic) int subject_id ;//1",
@property (nonatomic) int grade_id ;//3",
@property (nonatomic) int stage_id ;//1",
@property (nonatomic) int version_id ;//0",
@property (nonatomic) int category_id ;//0",
@property (nonatomic) int accept_answer_id ;//0",
@property (nonatomic, strong) NSString *domain ;//0",
@property (nonatomic) int answer_nr ;//0", //回答的用户数
@property (nonatomic, strong) NSString *content ;//请输入您的问题描述……",
@property (nonatomic, strong) NSString *tag ;//",
@property (nonatomic) int flag ;//0",
@property (nonatomic) int agree_nr ;//0",
@property (nonatomic) int disagree_nr ;//0",
@property (nonatomic) int visitor_nr ;//0",
@property (nonatomic) int ctime ;//1449308304",
@property (nonatomic) int mtime ;//0",
@property (nonatomic) BOOL status ;//0", //状态，0表示未采纳正确答案，1表示已采纳正确答案
@property (nonatomic, strong) NSString *format_ctime ;//11分钟前",
@property (nonatomic, strong) NSString *subject_name ;//语文",
@property (nonatomic, strong) NSString *stage_name ;//小学",
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray<Item> *knowledge_info;
@property (nonatomic, strong) QuestionResource *resource;
@property (nonatomic, strong) NSString *webapp_url;

/**
 *  701为问题，702为答案
 */
@property (nonatomic) int obj_type_id;

// 针对答案添加的数据
@property (nonatomic) BOOL is_agree; //是否赞过
@property (nonatomic) BOOL is_disagree; //是否踩过
@property (nonatomic) BOOL is_recommend; //是否推荐过
@property (nonatomic) int closely_question_nr; // 追问的个数
@property (nonatomic) BOOL acception;

/**
 *  0表示没有资源，1表示图片，2表示视频，3表示音频
 */
@property (nonatomic) int resourceType;
@property (nonatomic, strong) NSMutableArray *imageArray;


/**
 *  0正常，1下载中&&转码中，2播放中
 */
@property (nonatomic) int playStatus;

/**
 *  是否是问题UI
 */
@property (nonatomic) BOOL isQustionUI;

@end


@interface QuestionResource : JSONModel

@property (nonatomic, strong) NSArray *image;
@property (nonatomic, strong) NSArray<MediaObject> *video;
@property (nonatomic, strong) NSArray<MediaObject> *audio;

@end

@interface MediaObject : JSONModel

@property (nonatomic) int type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *face;
@property (nonatomic) int time;

@end

@interface QuestionDetailModel : ErrorModel

@property (nonatomic, strong) CCQuestion *data;

@end




