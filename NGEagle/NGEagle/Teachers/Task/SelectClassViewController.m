//
//  SelectClassViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SelectClassViewController.h"
#import "TaskListViewController.h"

@interface SelectClassViewController ()

@end

@implementation SelectClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _page = 1;
    _pageNum = 20;
    
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
    
    _request = [DataHelper getClassListByTaskId:self.taskId page:currentPage pageNum:_pageNum success:^(id responseObject) {
        
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
    [super configBaseUI];
    
    _titleLabel.text = @"选择班次";
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *idfa = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfa];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idfa];
    }
    ClassList *listModel = self.listModel.data[indexPath.row];

    cell.textLabel.text = listModel.name;    
    if (listModel.teacher_user_id == [[Account shareManager].userModel.user.uid intValue]) {
        cell.detailTextLabel.text = @"教授班次";
    } else {
        cell.detailTextLabel.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellStyleValue1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassList *listModel = self.listModel.data[indexPath.row];

    TaskListViewController *viewController = [[TaskListViewController alloc]
                                                initWithNibName:@"TaskListViewController" bundle:nil];
    viewController.openclassId = listModel.cid;
    viewController.taskId = self.taskId;
    [self.navigationController pushViewController:viewController animated:YES];
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
