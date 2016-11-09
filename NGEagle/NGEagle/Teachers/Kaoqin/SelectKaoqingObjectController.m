//
//  SelectKaoqingObjectController.m
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SelectKaoqingObjectController.h"
#import "MemberListCell.h"
#import "GroupListModel.h"
#import "KaoqinViewController.h"

@interface SelectKaoqingObjectController ()
{
    GroupListModel *_groupListModel;
}
@end

@implementation SelectKaoqingObjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
    }];
    [self.tableView.header beginRefreshing];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)getDataFromServer {
    [ChatDataHelper getGroupByType:0 success:^(id responseObject) {
        _groupListModel = responseObject;
        if (_groupListModel.error_code == 0) {
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
    
    _titleLabel.text = @"选择点到对象";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            if (_groupListModel.classes.count > 0) {
                return 30;
            }
            break;
        case 1:
            if (_groupListModel.defined.count > 0) {
                return 30;
            }
            break;
        case 2:
            if (_groupListModel.school.count > 0) {
                return 30;
            }
            break;
        default:
            break;
    }
    return 0.00001;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (_groupListModel.classes.count > 0) {
                return @"班级";
            }
            break;
        case 1:
            if (_groupListModel.defined.count > 0) {
                return @"群组";
            }
            break;
        case 2:
            if (_groupListModel.school.count > 0) {
                return @"学校";
            }
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return _groupListModel.classes.count;
            break;
        case 1:
            return _groupListModel.defined.count;
            break;
        case 2:
            return _groupListModel.school.count;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuse = @"cell";
    MemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    
    GroupInfo *groupInfo = nil;
    
    switch (indexPath.section) {
        case 0:
            groupInfo = _groupListModel.classes[indexPath.row];
            break;
        case 1:
            groupInfo = _groupListModel.defined[indexPath.row];

            break;
        case 2:
            groupInfo = _groupListModel.school[indexPath.row];

            break;
        default:
            break;
    }
    
    [cell.headImageView setImageWithURL:[NSURL URLWithString:groupInfo.logo]
                       placeholderImage:[UIImage imageNamed:@"default_head"]];
    cell.nameLabel.text = groupInfo.name;
    cell.schoolLabel.text = [NSString stringWithFormat:@"%d人", groupInfo.memberCount];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellStyleValue1;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupInfo *groupInfo = nil;
    
    switch (indexPath.section) {
        case 0:
            groupInfo = _groupListModel.classes[indexPath.row];
            break;
        case 1:
            groupInfo = _groupListModel.defined[indexPath.row];
            
            break;
        case 2:
            groupInfo = _groupListModel.school[indexPath.row];
            
            break;
        default:
            break;
    }
    
    KaoqinViewController *kaoqinVc = [[KaoqinViewController alloc]
                                      initWithNibName:@"KaoqinViewController" bundle:nil];
    kaoqinVc.groupInfo = groupInfo;
    [self.navigationController pushViewController:kaoqinVc animated:YES];
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
