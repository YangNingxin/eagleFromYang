//
//  CCFilterViewController.h
//  NGEagle
//
//  Created by Liang on 16/5/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^FilterComplete)(BOOL isAll, int subjectId, int gradeId);
/**
 *  筛选控制器
 */
@interface CCFilterViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}

/**
 *  0 推荐给我的课程，1 推荐给我的课程集，2 老师我的课程，3 老师我的课程集
 */
@property (nonatomic) int type;

- (void)setFilterCompleteBlock:(FilterComplete)block;

@end
