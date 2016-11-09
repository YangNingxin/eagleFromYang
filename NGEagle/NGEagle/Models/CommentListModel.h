//
//  CommentListModel.h
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "UserModel.h"

@protocol Comment

@end

@protocol Tag

@end


@interface CommentListModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<Comment> *data;

@end


@interface Comment : JSONModel

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray<Tag> *tags;

@property (nonatomic) int cid;//5", //评价id
@property (nonatomic) int user_id;//17", //发表评价的用户id
@property (nonatomic) int class_id;//50", //发表评价的用户所在的行政班级id
@property (nonatomic) int school_id;//10", //发表评论的用户所在的行政学校id
@property (nonatomic) int type;//1", //评价对象类型，1表示开放课程
@property (nonatomic) int target_id;//1", //评价对象id
@property (nonatomic) int flag;//0", //标志,0正常,1好评,2差评
@property (nonatomic) float star;//4", //评价的星级
@property (nonatomic, strong) NSString *content;//第4条评价诞生了", //评价的内容
@property (nonatomic, strong) NSString *format_ctime;//53分钟前", //格式化显示的时间

@property (nonatomic, strong) NSNumber<Optional> *cellHeight;

@end


@interface Tag : JSONModel

@property (nonatomic) int tid;//"1",
@property (nonatomic, strong) NSString *name; // "内容丰富",
@property (nonatomic) int type;// "1",
@property (nonatomic) int appraise_nr;// "5"

@end