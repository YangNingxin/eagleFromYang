//
//  ClassListViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/26.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ClassListViewController.h"
#import "ClassDetailViewController.h"
#import "ErrorModel.h"

@interface ClassListViewController ()

@end

@implementation ClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _pageNum = 20;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    __weak typeof(self) weakSelf = self;

    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer:YES];
    }];
    
    [self.tableView.header beginRefreshing];
   
    // Do any additional setup after loading the view from its nib.
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
    
    _request = [DataHelper getCourseClassListWithCourseId:self.course_id page:currentPage pageNum:_pageNum success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        ClassListModel *tempModel = responseObject;

        if (tempModel.error_code == 0 && tempModel.data.count > 0) {
            if (isFlush) {
                self.listModel = nil;
                self.listModel = tempModel;
                
                // 如果还有数据，添加footview
                if (self.listModel.data.count == _pageNum && !self.tableView.footer) {
                    
                    __weak typeof(self) weakSelf = self;

                    [self.tableView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getDataFromServer:NO];
                    }];
                }
                _page = currentPage;

            } else {
                [self.listModel.data addObjectsFromArray:tempModel.data];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleLabel.text = @"课程全部班次";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.classList = self.listModel.data[indexPath.row];
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassList *listModel = self.listModel.data[indexPath.row];
    ClassDetailViewController *webVc = [[ClassDetailViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webVc.webTitle = @"班次详情";
    webVc.url = listModel.url;
    webVc.webType = CLASS_DETAIL;
    webVc.cid = listModel.cid;
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark
#pragma mark ClassCellDelegate

- (void)bookCourse:(NSIndexPath *)indexPath {
    
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
