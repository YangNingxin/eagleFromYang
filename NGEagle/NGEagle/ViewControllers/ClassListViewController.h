//
//  ClassListViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/26.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassCell.h"
#import "ClassListModel.h"

@interface ClassListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, ClassCellDelegate>
{
    int _page;
    int _pageNum;
    NSOperation *_request;
}

@property (nonatomic) int course_id;
@property (nonatomic, strong) ClassListModel *listModel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
    