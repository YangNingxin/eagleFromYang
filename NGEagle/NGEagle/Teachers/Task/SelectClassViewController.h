//
//  SelectClassViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  老师查看任务，选择班次类
 */
@interface SelectClassViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    int _page;
    int _pageNum;
    NSOperation *_request;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/**
 *  班次列表数据
 */
@property (nonatomic, strong) ClassListModel *listModel;

/**
 *  任务列表
 */
@property (nonatomic) int taskId;

@end
