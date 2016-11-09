//
//  SetViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface SetViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

{
    NSArray *_itemArray;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;

@end
