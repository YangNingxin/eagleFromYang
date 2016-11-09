//
//  ReportViewController.h
//  NGEagle
//
//  Created by Liang on 16/5/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  举报
 */
@interface ReportViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
/**
 *  举报对象类型，1用户 2资源 3微课 4课程集 5学校 6班级 7试题 8问题
 */
@property (nonatomic) int type;
@property (nonatomic) int target_id;

@end
