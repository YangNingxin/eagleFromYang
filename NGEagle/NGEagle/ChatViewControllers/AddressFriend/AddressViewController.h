//
//  AddressViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendListModel.h"

@interface AddressViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate> {
    
    // 所有的好友列表
    NSMutableArray *muArrFriends;
    
    // 存储所有的排序后的数组
    
    /*
        例如A下面的所有数组,A1,A2
        B下面的所有数组，B1,B2,以此类推
     */
    NSMutableArray *sortedArrForArrays;
    
    // 存储首字母
    NSMutableArray *sectionHeadsKeys;
    
    // 筛选之后的数组
    NSMutableArray *searchMuarr;
    
    UISearchBar *searchBar;
}

/**
 *  tableView
 */
//@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITableView *tableView;

/**
 *  初始化表头
 */
- (void)initHeadView;

/**
 *  服务器请求数据
 */
- (void)requestAddressDataFromServer;

@end
