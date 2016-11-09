//
//  SubscribeListViewController.h
//  NGEagle
//
//  Created by Liang on 16/4/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  订阅知识点列表
 */
@interface SubscribeListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
@end
