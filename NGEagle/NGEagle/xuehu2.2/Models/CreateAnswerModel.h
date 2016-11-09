//
//  CreateAnswerModel.h
//  NGEagle
//
//  Created by Liang on 16/5/15.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@class CreateAnswer;
@interface CreateAnswerModel : ErrorModel

@property (nonatomic, strong) CreateAnswer *data;

@end


@interface CreateAnswer : JSONModel

@property (nonatomic) int qid; //问题id
@property (nonatomic) int link_id; //link id，domain不为0时，表示试题和对象的绑定关系
@property (nonatomic) int answer_id; //生成的答案id

@property (nonatomic, strong) NSString *content;

@property (nonatomic) int type;
/**
 *  资源数据
 */
@property (nonatomic, strong) NSArray *arrayData;

@end