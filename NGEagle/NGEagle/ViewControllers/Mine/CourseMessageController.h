//
//  CourseMessageController.h
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseMessageModel.h"

@interface CourseMessageController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSOperation *_request;
    int _page;
    int _pageNum;
}

@property (nonatomic, strong) CourseMessageModel *courseMessageModel;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
