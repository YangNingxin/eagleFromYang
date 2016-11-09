//
//  FollowOrganListController.h
//  NGEagle
//
//  Created by Liang on 15/8/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "OrganListModel.h"

@interface FollowOrganListController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSOperation *_request;
    int _page;
    int _pageNum;
}
@property (nonatomic, strong) OrganListModel *organListModel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
