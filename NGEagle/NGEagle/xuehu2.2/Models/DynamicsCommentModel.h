//
//  DynamicsCommentModel.h
//  NGEagle
//
//  Created by Liang on 16/4/25.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol CommentReply <NSObject>
@end

@protocol CommentObject <NSObject>
@end

/**
 *  动态评论
 */
@interface DynamicsCommentModel : ErrorModel

@property (nonatomic, strong) NSArray<CommentObject> *comments;

@end


@interface CommentObject : JSONModel

@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *cid;
@property(nonatomic,strong) NSString *publish_time; //发送时间
@property(nonatomic,strong) User *user;
@property(nonatomic,strong) NSArray<CommentReply> *reply;
@property(nonatomic,strong) NSString *at_ids;

@end

@interface CommentReply : JSONModel

@property(nonatomic,strong) User *puser;
@property(nonatomic,strong) User *user;

@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *rid;
@property(nonatomic,strong) NSString *pid;
@property(nonatomic,strong) NSString *at_ids;
@property(nonatomic,strong) NSString *publish_time; //发送时间

@end