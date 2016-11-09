//
//  SearchCourseViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "HotSearchModel.h"
#import "CourseModel.h"

@interface SearchCourseViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    /**
     *  type=0，热门搜索，type=1，搜索课程内容
     */
    int _type;
    
    NSOperation *_searchRequest;
    HotSearchModel *_hotSearchModel;
    
    NSOperation *_courseRequest;
    CourseModel *_courseModel;
    
    NSString *_keyWords;
    
    int _page;
    int _pageNum;
}

// 是否显示热门搜索
@property (nonatomic) BOOL isShowHot;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
- (IBAction)cancelAction:(UIButton *)sender;

@end
