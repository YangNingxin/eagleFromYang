//
//  LeftMenuViewController.h
//  NGEagle
//
//  Created by Liang on 16/4/5.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *viewControllers;
}
@property (nonatomic, assign) BOOL didSelectInitialViewController;
@property (nonatomic, strong) UITableView *tableView;
@end
