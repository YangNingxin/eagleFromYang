//
//  SubscribeViewController.h
//  NGEagle
//
//  Created by Liang on 16/4/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "RecommendCell.h"


/**
 *  订阅课程列表
 */
@interface SubscribeViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
@end
