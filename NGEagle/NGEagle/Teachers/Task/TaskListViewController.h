//
//  TaskListViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface TaskListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) int taskId;
@property (nonatomic) int openclassId;

/**
 *  UI
 */

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
