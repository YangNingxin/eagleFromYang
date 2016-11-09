//
//  FollowOrganListController.m
//  NGEagle
//
//  Created by Liang on 15/8/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "FollowOrganListController.h"
#import "OrganCell.h"
#import "OrganizationViewController.h"

@interface FollowOrganListController ()

@end

@implementation FollowOrganListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _pageNum = 20;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"OrganCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view from its nib.
    
    
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
    
    _request = [DataHelper getFollowOrganizationListWithToken:nil page:currentPage page_num:_pageNum  success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        OrganListModel *tempModel = responseObject;
        
        if (tempModel.error_code == 0 && tempModel.data.count > 0) {
            if (isFlush) {
                self.organListModel = nil;
                self.organListModel = tempModel;
                
                // 如果还有数据，添加footview
                if (self.organListModel.data.count == _pageNum && !self.tableView.footer) {
                    
                    __weak typeof(self) weakSelf = self;
                    
                    [self.tableView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getDataFromServer:NO];
                    }];
                }
                _page = currentPage;
                
            } else {
                [self.organListModel.data addObjectsFromArray:tempModel.data];
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleLabel.text = @"关注列表";
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
    return self.organListModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    OrganCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    
//    Organ *organ = self.organListModel.data[indexPath.row];
//    cell.isFollowList = YES;
//    cell.organ = organ;
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
    
    static NSString *idfa = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfa];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfa];
        
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        iconImg.layer.cornerRadius = 22.0;
        iconImg.layer.masksToBounds = YES;
        iconImg.tag = 200;
        [cell.contentView addSubview:iconImg];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, SCREEN_WIDTH-80, 20)];
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.tag = 201;
        [cell.contentView addSubview:titleLab];
        
    }
    
    Organ *organ = self.organListModel.data[indexPath.row];
    
    UIImageView *iconImage = (UIImageView *)[cell.contentView viewWithTag:200];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:201];
    
    [iconImage setImageWithURL:[NSURL URLWithString:organ.logo_url] placeholderImage:[UIImage imageNamed:@"icon_group_chat"]];
    label.text = organ.name;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Organ *organ = self.organListModel.data[indexPath.row];
    [self gotoOrganizationViewController:organ];
}

// 进入机构详情页
- (void)gotoOrganizationViewController:(Organ *)organ {
    
    OrganizationViewController *organizationVc = [[OrganizationViewController alloc] init];
    organizationVc.url = organ.url;
    organizationVc.name = organ.name;
    organizationVc.is_follow = organ.is_follow; //[dict[@"is_follow"] boolValue];
    organizationVc.organizationId = [organ.oid intValue];//[dict[@"school_id"] intValue];
    [self.navigationController pushViewController:organizationVc animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消关注";
}

@end
