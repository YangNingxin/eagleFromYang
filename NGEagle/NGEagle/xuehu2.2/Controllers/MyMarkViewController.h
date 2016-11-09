//
//  MyMarkViewController.h
//  NGEagle
//
//  Created by Liang on 16/5/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
/**
 *  我的收藏
 */
@interface MyMarkViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;

}
@end
