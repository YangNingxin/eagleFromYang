//
//  TaskDetailViewController.h
//  NGEagle
//
//  Created by Liang on 15/9/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "TaskAnswerModel.h"

@interface TaskDetailViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TaskAnswer *taskAnswer;

@end
