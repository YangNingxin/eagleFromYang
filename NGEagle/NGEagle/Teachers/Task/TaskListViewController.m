//
//  TaskListViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskAnswerModel.h"
#import "TaskStatusViewController.h"
#import "TaskAnserCell.h"
#import "TaskDetailViewController.h"

@interface TaskListViewController ()
{
    TaskAnswerModel *taskAnswerModel;
    TaskAnserCell *myCell;
}
@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
    }];
    [self.tableView.header beginRefreshing];
    
    [self.tableView registerClass:[TaskAnserCell class] forCellReuseIdentifier:@"TaskAnserCell"];
    
    myCell = [[TaskAnserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TaskAnserCell"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)getDataFromServer {
       
    [DataHelper getTaskAnswersByTaskId:self.taskId openclass_id:self.openclassId author_uid:0 success:^(id responseObject) {
        taskAnswerModel = responseObject;
        if (taskAnswerModel.error_code == 0) {
            [self.tableView reloadData];
        }
        [self.tableView.header endRefreshing];
    } fail:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    _titleLabel.text = @"任务";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setImage:[UIImage imageNamed:@"icon_user_btn"] forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    TaskStatusViewController *viewController = [[TaskStatusViewController alloc]
                                              initWithNibName:@"TaskStatusViewController" bundle:nil];
    viewController.taskId = self.taskId;
    viewController.openclassId = self.openclassId;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return taskAnswerModel.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskAnswer *taskAnswer = taskAnswerModel.data[indexPath.section];
    if (taskAnswer.height != 0) {
        return taskAnswer.height;
    }
    myCell.taskAnswer = taskAnswer;
    return taskAnswer.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskAnswer *taskAnswer = taskAnswerModel.data[indexPath.section];
    
    TaskAnserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskAnserCell" forIndexPath:indexPath];
    cell.taskAnswer = taskAnswer;
    cell.viewController = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskAnswer *taskAnswer = taskAnswerModel.data[indexPath.section];

    TaskDetailViewController *taskDetailVc = [[TaskDetailViewController alloc] initWithNibName:@"TaskDetailViewController" bundle:nil];
    taskDetailVc.taskAnswer = taskAnswer;
    [self.navigationController pushViewController:taskDetailVc animated:YES];
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
