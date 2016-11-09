//
//  TaskAnserCell.h
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseGroupCell.h"
#import "TaskAnswerModel.h"

@interface TaskAnserCell : BaseGroupCell

@property (nonatomic, strong) TaskAnswer *taskAnswer;

/**
 *  赞
 */
@property (nonatomic, strong) UIButton *supportButton;

/**
 *  评论
 */
@property (nonatomic, strong) UIButton *commentButton;

@end
