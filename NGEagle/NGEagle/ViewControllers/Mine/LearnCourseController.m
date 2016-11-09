//
//  LearnCourseController.m
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "LearnCourseController.h"
#import "CourseDetailViewController.h"
#import "CourseCell.h"

@interface LearnCourseController ()

@end

@implementation LearnCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNum = 20;
    _newPage = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getNewDataIsFlush:YES];
    }];

    [self.tableView.header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)configBaseUI {
    
    [super configBaseUI];

    if (self.type == 1) {
        _titleLabel.text = @"正在学的";
    } else {
        _titleLabel.text = @"已经学过";
    }
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
   
   _newRequest = [DataHelper getStudyCourseListWithType:self.type page:_newPage page_num:_pageNum success:^(id responseObject) {
        
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
    Course *course;
    course = _newModel.data[indexPath.row];
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