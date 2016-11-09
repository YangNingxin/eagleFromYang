//
//  CreateQuestionViewController.h
//  NGEagle
//
//  Created by Liang on 16/5/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCPublishViewController.h"
#import "CreateQuestionModel.h"

typedef void(^CreateQuestionSuccess)(CreateQuestionModel *object);

@interface CreateQuestionViewController : CCPublishViewController

/**
 *  问题的类型, 0--普通, 1--课件, 2--微课, 3--试题, 4--课程集, 5--课时
 */
@property (nonatomic) int domain;
/**
 *  domain为1时有效，表示添加试题时对应的微课播放时间，单位s
 */
@property (nonatomic) int mark_at;

/**
 *  domain不为0时, 针对的类型id
 */
@property (nonatomic) int target_id;
/**
 *  追问时, 设置追问的答案的id，当连续追问时，都填写第一个回答的id，表明后续都是由这个回答引起的追问。
 */
@property (nonatomic) int closely_answer_id;

- (void)setCreateQuestionSuccess:(CreateQuestionSuccess)block;

@end
