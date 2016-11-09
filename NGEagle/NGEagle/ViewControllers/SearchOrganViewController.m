//
//  SearchOrganViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SearchOrganViewController.h"
#import "OrganizationViewController.h"
#import "Location.h"
#import "OrganCell.h"

@interface SearchOrganViewController ()

@end

@implementation SearchOrganViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.textField setPlaceholder:@"请输入机构名称"];

    [self.tableView registerNib:[UINib nibWithNibName:@"OrganCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchDataFromServer:(BOOL)isRefresh {
    [_searchRequest cancel];
    _searchRequest = nil;
    
    
    int currentPage;
    
    if (isRefresh) {
        currentPage = 1;
    } else {
        currentPage = _page;
    }

    
    float lat = [Location shareManager].location.latitude;
    float lon = [Location shareManager].location.longitude;
    
    _searchRequest = [DataHelper getOrganizationList:_keyWords lat:lat lon:lon page:currentPage page_num:_pageNum success:^(id responseObject) {
        
        OrganListModel *tempModel = responseObject;

        [self.tableView.footer endRefreshing];

        if (isRefresh) {
            self.organListModel = nil;
            self.organListModel = tempModel;
            
            // 如果还有数据，添加footview
            if (self.organListModel.data.count == _pageNum && !self.tableView.footer) {
                
                __weak typeof(self) weakSelf = self;

                [self.tableView addLegendFooterWithRefreshingBlock:^{
                    [weakSelf searchDataFromServer:NO];
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

    } fail:^(NSError *error) {
        [self.tableView.footer endRefreshing];

    }];
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
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrganCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Organ *organ = self.organListModel.data[indexPath.row];
    cell.organ = organ;
    
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
    organizationVc.is_follow = organ.is_follow;
    organizationVc.organizationId = [organ.oid intValue];
    [self.navigationController pushViewController:organizationVc animated:YES];
    
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
