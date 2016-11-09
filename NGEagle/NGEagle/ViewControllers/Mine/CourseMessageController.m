//
//  CourseMessageController.m
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CourseMessageController.h"
#import "CourseMessageCell.h"
#import "StringSizeUtil.h"
#import "CourseDetailViewController.h"

@interface CourseMessageController ()

@end

@implementation CourseMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _pageNum = 20;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseMessageCell" bundle:nil] forCellReuseIdentifier:@"CourseMessageCell"];
    // Do any additional setup after loading the view from its nib.
    
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf getDataFromServer:YES];
    }];
    
    [self.tableView.header beginRefreshing];
}

- (void)getDataFromServer:(BOOL)isFlush {
    
    [_request cancel];
    _request = nil;
    int currentPage;
    
    if (isFlush) {
        currentPage = 1;
    } else {
        currentPage = _page;
    }
    
    _request = [DataHelper getOpencourseMessageWithStatus:-1 set_read:1 page:currentPage page_num:_pageNum success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        CourseMessageModel *tempModel = responseObject;
        
        if (tempModel.error_code == 0 && tempModel.data.count > 0) {
            if (isFlush) {
                self.courseMessageModel = nil;
                self.courseMessageModel = tempModel;
                
                // 如果还有数据，添加footview
                if (self.courseMessageModel.data.count == _pageNum && !self.tableView.footer) {
                    
                    __weak typeof(self) weakSelf = self;
                    
                    [self.tableView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getDataFromServer:NO];
                    }];
                }
                _page = currentPage;
                
            } else {
                [self.courseMessageModel.data addObjectsFromArray:tempModel.data];
                if (tempModel.data.count != _pageNum) {
                    [self.tableView removeFooter];
                }
            }
            _page ++;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}



- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"课程消息";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
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
    
    return self.courseMessageModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseMessage *message = self.courseMessageModel.data[indexPath.row];
    CGFloat height = [StringSizeUtil getContentSizeHeight:message.msg_content font:[UIFont systemFontOfSize:15.0] width:SCREEN_WIDTH-10];
    
    return height + 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseMessageCell" forIndexPath:indexPath];
    
    cell.coureseMessage = self.courseMessageModel.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseMessage *message = self.courseMessageModel.data[indexPath.row];
    Course *course = message.opencourse;
    
    CourseDetailViewController *webVc = [[CourseDetailViewController alloc] initWithNibName:@"WebViewController" bundle:nil];

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
