//
//  KaoqingListViewController.m
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "KaoqingListViewController.h"
#import "SelectKaoqingObjectController.h"
#import "KaoqingListCell.h"
#import "RegistrationListModel.h"
#import "RegistrationDataHelper.h"
#import "KaoqinViewController.h"

@interface KaoqingListViewController ()
{
    RegistrationListModel *_registrationList;
}
@end

@implementation KaoqingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"KaoqingListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadDataFromServer];
    }];
    [self.tableView.header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshKaoqingList) name:@"refreshKaoqingList" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)refreshKaoqingList {
    [self.tableView.header beginRefreshing];
}

- (void)loadDataFromServer {
    
    [RegistrationDataHelper getRegistrationList:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        
        _registrationList = responseObject;
        if (_registrationList.error_code == 0) {
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)configBaseUI {
    _titleLabel.text = @"考勤列表";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setTitle:@"点到" forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    SelectKaoqingObjectController *selectVc = [[SelectKaoqingObjectController alloc] initWithNibName:@"SelectKaoqingObjectController" bundle:nil];
    [self.navigationController pushViewController:selectVc animated:YES];
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
    return _registrationList.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KaoqingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    RegistrationList *registration = _registrationList.data[indexPath.row];
    cell.registrationList = registration;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    RegistrationList *registration = _registrationList.data[indexPath.row];
    KaoqinViewController *kaoqinVc = [[KaoqinViewController alloc] initWithNibName:@"KaoqinViewController" bundle:nil];
    kaoqinVc.listModel = registration;
    [self.navigationController pushViewController:kaoqinVc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
