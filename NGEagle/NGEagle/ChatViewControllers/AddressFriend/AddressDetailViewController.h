//
//  AddressDetailViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfoModel.h"

@interface AddressDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

/**
 *  用户
 */
@property (nonatomic, strong) User *user;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
