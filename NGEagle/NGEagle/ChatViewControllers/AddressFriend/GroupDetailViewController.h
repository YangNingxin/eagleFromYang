//
//  ViewController.h
//  TableViewController
//
//  Created by ZhangXiaoZhuo on 15/8/21.
//  Copyright (c) 2015年 zhangguohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupInfoModel.h"
@interface GroupDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

{
    UIImageView * icon1;
    UILabel *classLbl;
    NSMutableArray * iconArr;
    UITableView *myTable;

}

@property (nonatomic, strong) GroupInfo *groupInfo;

@end

