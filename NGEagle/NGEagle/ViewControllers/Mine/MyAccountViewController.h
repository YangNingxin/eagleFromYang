//
//  MyAccountViewController.h
//  NGEagle
//
//  Created by ZhangXiaoZhuo on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "WealthModel.h"

@interface MyAccountViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) Wealth *wealth;

@end
