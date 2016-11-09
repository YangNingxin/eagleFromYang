//
//  ModifyPassViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/13.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyPassViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITextField *textField1;
    UITextField *textField2;
    UITextField *textField3;
    
    NSArray *_itemArray;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
