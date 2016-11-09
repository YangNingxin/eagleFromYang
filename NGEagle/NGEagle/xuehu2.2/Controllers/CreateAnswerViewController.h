//
//  CreateAnswerViewController.h
//  NGEagle
//
//  Created by Liang on 16/5/15.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCPublishViewController.h"
#import "CreateAnswerModel.h"

typedef void(^CreateAnswerSuccess)(CreateAnswerModel *object);


@interface CreateAnswerViewController : CCPublishViewController

// 需要回答的问题列表
@property (nonatomic) int question_id;

- (void)setCreateAnswerSuccess:(CreateAnswerSuccess)block;

@end
