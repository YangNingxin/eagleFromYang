//
//  GroupInfoViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "GroupListViewController.h"
#import "GroupListModel.h"
#import "UIImageView+AFNetworking.h"
#import "GroupDetailViewController.h"

@interface GroupListViewController ()
{
    NSMutableArray *dataArray;
    
    UISearchBar *_searchBar;
    
    // 筛选之后的数组
    NSMutableArray *searchMuarr;
    
    UISearchDisplayController *searchDisplayController;
}
@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [NSMutableArray array];
    searchMuarr = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak typeof(self) weakSelf = self;
    
    [self initHeadView];
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];

    }];
    [self.tableView.header beginRefreshing];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)initHeadView {
    // 搜索条
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.f)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    
    self.tableView.tableHeaderView = _searchBar;
    
    // 搜索控制器
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"群组列表";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}
- (void)getDataFromServer {
    
    int type;
    if (self.groupType == NgClass) {
        type = 2;
    } else if (self.groupType == NgGroup) {
        type = 3;
    }
    [ChatDataHelper getGroupByType:type success:^(id responseObject) {
        GroupListModel *model = responseObject;
        if (model.error_code == 0) {
            if (type == 2) {
                [dataArray addObjectsFromArray:model.classes];
                
            } else {
                [dataArray addObjectsFromArray:model.defined];
            }
            
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

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [dataArray count];
    } else {
        return [searchMuarr count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    GroupInfo *list;
    
    if (tableView == self.tableView) {
        list = dataArray[indexPath.row];
    } else {
        list = searchMuarr[indexPath.row];
    }
    
    UIImageView *iconImage = (UIImageView *)[cell.contentView viewWithTag:200];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:201];
    
    [iconImage setImageWithURL:[NSURL URLWithString:list.logo] placeholderImage:[UIImage imageNamed:@"icon_group_chat"]];
    label.text = list.name;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupInfo *list;
    
    if (tableView == self.tableView) {
        list = dataArray[indexPath.row];
    } else {
        list = searchMuarr[indexPath.row];
    }
    
    GroupDetailViewController *groupVc = [[GroupDetailViewController alloc] init];
    groupVc.groupInfo = list;
    [self.navigationController pushViewController:groupVc animated:YES];
}

#pragma mark UISearchBar and UISearchDisplayController Delegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [searchMuarr removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString];
    
    
    [searchMuarr addObjectsFromArray:[dataArray filteredArrayUsingPredicate:resultPredicate]];
    
    //去除 No Results 标签
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        for (UIView *subview in controller.searchResultsTableView.subviews) {
            
            if ([subview isKindOfClass:[UILabel class]] && [[(UILabel *)subview text] isEqualToString:@"No Results"]) {
                
                UILabel *label = (UILabel *)subview;
                
                label.text = @"无结果";
                
                break;
                
            }
            
        }
        
    });
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    tableView.frame = CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT);
    [tableView reloadData];
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0) {
    _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.f);
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0) {
    _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.f);
}


@end
