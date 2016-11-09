//
//  SelectPeopleController.m
//  NGEagle
//
//  Created by Liang on 16/4/14.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SelectPeopleController.h"
#import "SelectPeopleCell.h"
#import "LeftLabelRightImage.h"
#import "PullGroupView.h"
#import "MemberListModel.h"
#import "FriendListModel.h"
#import "StringSizeUtil.h"

@interface SelectPeopleController() <PullSelectGroupDelegate>
{
    UIButton *_sureButton;
    FinishSelectPeople _block;
}
@end

@implementation SelectPeopleController
{
    UISearchBar *_searchBar;
    PullGroupView *_pullView;
    LeftLabelRightImage *_centerLabel;

    int _groupId;
    NSMutableArray *_usersArray;
    NSMutableArray *_searchArray;
    NSMutableDictionary *_selectDict;
    BOOL _isSearch;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectDict = [NSMutableDictionary new];
    _groupId = -1;
    _usersArray = [NSMutableArray new];
    _searchArray = [NSMutableArray new];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_offset(-45);
        make.top.mas_equalTo(64);
    }];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headView;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 40)];
    _searchBar.layer.cornerRadius = 4.0;
    _searchBar.layer.borderColor = RGB(204, 204, 204).CGColor;
    _searchBar.layer.borderWidth = 1.0;
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor whiteColor];
    [headView addSubview:_searchBar];
    
    for (UIView *view in _searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }

    WS(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getPeopleListFromServer];
    }];
    [_tableView.header beginRefreshing];
    
    _sureButton = [UIButton new];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.layer.cornerRadius = 4.0;
    _sureButton.layer.masksToBounds = YES;
    _sureButton.backgroundColor = kThemeColor;
    [self.view addSubview:_sureButton];
    
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.bottom.mas_offset(-10);
        make.height.mas_offset(40);
    }];
}

- (void)sureAction {
    if (_selectDict) {
        if (_selectDict.allKeys.count > 0) {
            NSMutableString *result = [NSMutableString new];
            
            for (int i = 0; i < _selectDict.allKeys.count; i++) {
                NSString *tempId = [_selectDict.allKeys objectAtIndex:i];
                [result appendFormat:@"%@,", tempId];
            }
            _block(result, (int)_selectDict.allKeys.count);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)getPeopleListFromServer {
    
    [_usersArray removeAllObjects];
    [_tableView reloadData];
    
    if (_groupId == -1) { // 获取好友列表
        
        [ChatDataHelper getFriend:nil success:^(id responseObject) {
            FriendListModel *model = responseObject;
            if (model.error_code == 0) {
                [_usersArray addObjectsFromArray:model.data];
            }
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        } fail:^(NSError *error) {
            [_tableView.header endRefreshing];
        }];
        
    } else {
        
        // 获取群组成员
        [DataHelper getGroupUserByGroupId:_groupId success:^(id responseObject) {
            
            MemberListModel *memberListModel = responseObject;
            if (memberListModel.error_code == 0) {
                [_usersArray addObjectsFromArray:memberListModel.users];
            }
            [_tableView reloadData];
            [_tableView.header endRefreshing];
            
        } fail:^(NSError *error) {
            [_tableView.header endRefreshing];
        }];
    }
}


- (void)configBaseUI {
    [super configBaseUI];
    [_rightButotn setTitle:@"全选" forState:UIControlStateNormal];
    
    _centerLabel = [LeftLabelRightImage new];
    _centerLabel.label.text = @"好友";
    _centerLabel.imageView.image = [UIImage imageNamed:@"sanjiao"];
    [_barImageView addSubview:_centerLabel];
    
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(32);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPopView)];
    [_centerLabel addGestureRecognizer:tap];
}

- (void)showPopView {
    if (!_pullView) {
        _pullView = [PullGroupView new];
        _pullView.delegate= self;
        [self.view addSubview:_pullView];
        [_pullView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(64);
        }];
    } else {
        [_pullView setHidden:!_pullView.isHidden];
    }
}

- (void)setFinishSelectPeopleBlock:(FinishSelectPeople)block {
    _block = block;
}

- (void)rightButtonAction {
    for (int i = 0; i < _usersArray.count; i++) {
        User *user = _usersArray[i];
        [_selectDict setObject:@"1" forKey:user.uid];
    }
    [_tableView reloadData];
}

/**
 *  筛选通讯录
 */
- (void)filteredFriendArray {
    
    [_searchArray removeAllObjects];
    
    NSString *searchStirng = _searchBar.text;
    BOOL isContainChinese = [StringSizeUtil isStringContainChinese:searchStirng];
    
    NSPredicate *predicateGroup;
    NSPredicate *predicate;
    
    if (isContainChinese) {
        predicate = [NSPredicate predicateWithFormat:@"nick contains[cd] %@", searchStirng];
        predicateGroup = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchStirng];
    } else {
        searchStirng = [searchStirng stringByAppendingString:@"*"];
        
        predicate = [NSPredicate predicateWithFormat:@"nick_pinyin like[cd] %@", searchStirng];
        predicateGroup = [NSPredicate predicateWithFormat:@"nick_pinyin like[cd] %@", searchStirng];
    }
    [_searchArray addObjectsFromArray:[_usersArray filteredArrayUsingPredicate:predicate]];
}


#pragma mark
#pragma mark PullSelectGroupDelegate

- (void)selectType:(int)type name:(NSString *)name {
    
    if (name.length > 9) {
        name = [name substringToIndex:8];
    }
    name = [NSString stringWithFormat:@"%@...", name];
    
    _centerLabel.label.text = name;
    _pullView.hidden = YES;
    _groupId = type;
    
    // 刷新数据
    [_tableView.header beginRefreshing];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch) {
        return _searchArray.count;
    }
    return _usersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *idfa = @"cell";
    SelectPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[SelectPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfa];
    }
    
    User *user;
    if (_isSearch) {
        user = _searchArray[indexPath.row];
    } else {
        user = _usersArray[indexPath.row];
    }
    
    cell.user = user;
    if (_selectDict[user.uid]) {
        [cell.selectButton setSelected:YES];
    } else {
        [cell.selectButton setSelected:NO];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   

    User *user;
    
    if (_isSearch) {
        user = _searchArray[indexPath.row];
    } else {
        user = _usersArray[indexPath.row];
    }
    
    if (_selectDict[user.uid]) {
        [_selectDict removeObjectForKey:user.uid];
    } else {
        [_selectDict setObject:@"1" forKey:user.uid];
    }
    [_tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 0) {
        _isSearch = YES;
    } else {
        _isSearch = NO;
    }
    [self filteredFriendArray];
    [_tableView reloadData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

@end
