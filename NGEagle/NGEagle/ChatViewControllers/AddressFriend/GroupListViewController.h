//
//  GroupListViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    
    NgClass = 1, // 班级
    NgGroup = 2, // 群组
    NgFollow = 3, // 关注
    NgFriend = 0 // 新朋友
    
}GroupType;

@interface GroupListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>

/**
 *  群组类型
 */
@property (nonatomic) GroupType groupType;

/**
 *  tableView
 */
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
