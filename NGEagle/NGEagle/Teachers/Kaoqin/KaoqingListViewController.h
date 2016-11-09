//
//  KaoqingListViewController.h
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface KaoqingListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
