//
//  CommentListViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentListModel.h"

@interface CommentListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSOperation *_request;
    int _page;
    int _pageNum;
    
    
}
/**
 *  课程id
 */
@property (nonatomic) int cid;
@property (nonatomic, strong) CommentListModel *listModel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
