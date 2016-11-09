//
//  MyCourseViewController.m
//  NGEagle
//
//  Created by Liang on 15/9/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "MyCourseViewController.h"
#import "CourseCell.h"
#import "MJRefresh.h"
#import "CourseDetailViewController.h"

@interface MyCourseViewController ()

@end

@implementation MyCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _pageNum = 20;
    _newPage = 1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getNewDataIsFlush:YES];
    }];
    [self.tableView.header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)configBaseUI {
    _titleLabel.text = @"我的课程";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

// 获取new数据
- (void)getNewDataIsFlush:(BOOL)isFlush {
    
    [_newRequest cancel];
    _newRequest = nil;
    int currentPage;
    
    if (isFlush) {
        currentPage = 1;
    } else {
        currentPage = _newPage;
    }
    
    
    _newRequest = [DataHelper getMyCourseList:currentPage page_num:_pageNum owner:YES success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        CourseModel *tempModel = responseObject;
        
        if (tempModel.error_code == 0 && tempModel.data.count > 0) {
            if (isFlush) {
                _newModel = nil;
                _newModel = tempModel;
                
                // 如果还有数据，添加footview
                if (_newModel.data.count == _pageNum && !self.tableView.footer) {
                    
                    __weak typeof(self) weakSelf = self;
                    
                    [self.tableView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getNewDataIsFlush:NO];
                    }];
                }
                _newPage = currentPage;
                
            } else {
                [_newModel.data addObjectsFromArray:tempModel.data];
                if (tempModel.data.count != _pageNum) {
                    [self.tableView removeFooter];
                }
            }
            _newPage ++;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 218;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.course = _newModel.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseDetailViewController *webVc = [[CourseDetailViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    Course *course = _newModel.data[indexPath.row];
    webVc.webTitle = @"课程详情";
    webVc.url = course.url;
    webVc.webType = COURSE_DETAIL;
    webVc.cid = [course.cid intValue];
    [self.navigationController pushViewController:webVc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
