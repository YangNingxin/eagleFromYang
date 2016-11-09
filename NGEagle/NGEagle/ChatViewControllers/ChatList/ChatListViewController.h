/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface ChatListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

/**
 *  数据源
 */
@property (strong, nonatomic) NSMutableArray *dataSource;

/**
 *  tableView
 */
@property (strong, nonatomic) UITableView *tableView;

/**
 *  刷新数据
 */
- (void)refreshDataSource;

@end
