//
//  LearnCourseController.h
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseModel.h"

@interface LearnCourseController : BaseViewController
{
    NSOperation *_newRequest;
    int _newPage;
    int _pageNum;
    CourseModel *_newModel;

}

/**
 *  类型 1表示正在学，2表示已学完
 */
@property (nonatomic) int type;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
