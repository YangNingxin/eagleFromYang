//
//  MyCourseViewController.h
//  NGEagle
//
//  Created by Liang on 15/9/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCourseViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSOperation *_newRequest;
    int _newPage;
    int _pageNum;
    CourseModel *_newModel;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
