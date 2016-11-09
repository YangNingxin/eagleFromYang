//
//  TransactionViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface TransactionViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
