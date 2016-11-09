//
//  CreateQuestionModel.h
//  NGEagle
//
//  Created by Liang on 16/5/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@class CreateQuestion;
@protocol CreateQuestion <NSObject>
@end

/**
 *  创建提问成功的列表
 */
@interface CreateQuestionModel : ErrorModel

@property (nonatomic, strong) CreateQuestion *data;

@end

@interface CreateQuestion : JSONModel

@property (nonatomic) int qid;
@property (nonatomic) int link_id; //link id，domain不为0时，表示试题和对象的绑定关系
@property (nonatomic, strong) NSString *content;

@property (nonatomic) int type;
/**
 *  资源数据
 */
@property (nonatomic, strong) NSArray *arrayData;

@end