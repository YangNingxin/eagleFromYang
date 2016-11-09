//
//  AddressViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "AddressViewController.h"
#import "StringSizeUtil.h"
#import "ArrayUtil.h"
#import "GroupButton.h"
#import "GroupStaticModel.h"
#import "GroupListViewController.h"
#import "AddressDetailViewController.h"
#import "UserDao.h"
#import "DBManager.h"
#import "FollowOrganListController.h"
#import "NewFriendViewController.h"
#import "AddressBookTableViewCell.h"

@interface AddressViewController () {
    GroupStaticModel *groupStaticModel;
    
    // 群组view
    UIView *groupView;
    NSArray *itemArray;
}
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化
    muArrFriends = [NSMutableArray array];
    sortedArrForArrays = [NSMutableArray array];
    sectionHeadsKeys = [NSMutableArray array];
    searchMuarr = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    [self initHeadView];
    
    // 配置tableView
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = UIColorFromRGB(0x1788b3);
//    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    // 控制searchBar为颜色
//  [self.searchDisplayController.searchBar setBarTintColor:gTextColor];
    
    [self loadLocalData];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf requestAddressDataFromServer];
    }];
    [self.tableView.header beginRefreshing];
    
    
    // 添加删除好友的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriendListNote:) name:@"refreshFriendListNote" object:nil];
    
    // Do any additional setup after loading the view.
}

#pragma mark
#pragma mark refreshFriendListNote

- (void)refreshFriendListNote:(NSNotification *)aNote {
    [self.tableView.header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)initHeadView {
    self.tableView.tableHeaderView = [[UIView alloc]
                                      initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 126)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [self.tableView.tableHeaderView addSubview:self.searchDisplayController.searchBar];
    
    // 群组view
    groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 80)];
    [self.tableView.tableHeaderView addSubview:groupView];
    
    itemArray = @[@"新朋友", @"班级", @"群组", @"关注"];
    
    float marginSpace = 25.0;
    
    float x = (SCREEN_WIDTH - marginSpace * 2 - itemArray.count * 60)/(itemArray.count - 1);

    for (int i = 0; i < itemArray.count; i++) {
        
        GroupButton *button = [[GroupButton alloc] initWithFrame:CGRectMake(marginSpace + i*(x + 60), 10, 60, 60)];
        button.tag = 100 + i;
        button.lblTitle.text = itemArray[i];
        switch (i) {
            case 0:
                button.iconImageView.image = [UIImage imageNamed:@"new_friend"];
                break;
            case 1:
                button.iconImageView.image = [UIImage imageNamed:@"class_icon"];
                break;
            case 2:
                button.iconImageView.image = [UIImage imageNamed:@"group_icon"];
                break;
            case 3:
                button.iconImageView.image = [UIImage imageNamed:@"attention_icon"];
                break;
                
            default:
                break;
        }
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [groupView addSubview:button];
    }
}

- (void)buttonAction:(GroupButton *)button {
    
    GroupType type = (GroupType)button.tag - 100;
    
    if (type == NgClass) {
        if (groupStaticModel.data.class_count == 0) {
            return;
        }
    } else if (type == NgGroup) {
        if (groupStaticModel.data.group_count == 0) {
            return;
        }
    } else if (type == NgFriend) {
//        if (groupStaticModel.data.group_count == 0) {
//            return;
//        }
    } else {
        if (groupStaticModel.data.follow_organization_count == 0) {
            return;
        }
    }
    
    if (type == NgFollow) {
        
        FollowOrganListController *followListVc = [[FollowOrganListController alloc] initWithNibName:@"FollowOrganListController" bundle:nil];
        followListVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:followListVc animated:YES];
        
    } else if (type == NgFriend) {
        
        NewFriendViewController *newFriendVc = [[NewFriendViewController alloc] init];
        newFriendVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newFriendVc animated:YES];
        
    } else {
        
        GroupListViewController *memberVc = [[GroupListViewController alloc] init];
        memberVc.groupType = type;
        memberVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:memberVc animated:YES];
    }
   
}

/**
 *  加载本地数据
 */
- (void)loadLocalData {
    
    [[DBManager shareManager] openDataBase];
    [self reflushAddressDataFromServer:[UserDao selectFriend] isLocal:YES];
}

/**
 *  加载通讯录数据
 */
- (void)requestAddressDataFromServer {
    
    NSLog(@"=======requestAddressDataFromServer========");
    [ChatDataHelper getContactStatistic:nil success:^(id responseObject) {
        groupStaticModel = responseObject;
        if (groupStaticModel.error_code == 0) {
            
            [self reloadGroupViewUI];
            
            [ChatDataHelper getFriend:nil success:^(id responseObject) {
                FriendListModel *model = responseObject;
                if (model.error_code == 0) {
                    [self reflushAddressDataFromServer:model.data isLocal:NO];
                }
                [self.tableView.header endRefreshing];
            } fail:^(NSError *error) {
                [self.tableView.header endRefreshing];
            }];

            
        }
    } fail:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];

}

/**
 *  更改群组，班级个数
 */
- (void)reloadGroupViewUI {
    for (int i = 0; i < itemArray.count; i++) {
        GroupButton *gorupButton = (GroupButton *)[groupView viewWithTag:100 + i];
        switch (i) {
            case 0:
                gorupButton.lblNumber.text = [NSString stringWithFormat:@"%d", 0];
                break;
            case 1:
                gorupButton.lblNumber.text = [NSString stringWithFormat:@"%d", groupStaticModel.data.class_count];
                break;
            case 2:
                gorupButton.lblNumber.text = [NSString stringWithFormat:@"%d", groupStaticModel.data.group_count];
                break;
            case 3:
                gorupButton.lblNumber.text = [NSString stringWithFormat:@"%d", groupStaticModel.data.follow_organization_count];
                break;
            default:
                break;
        }
    }
}

/**
 *  按照拼音进行排序
 *
 *  @param arrToSort 排序之前的数组
 *
 *  @return 排序之后的数组
 */
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [arrToSort count]; index++)
    {
        User *chineseStr = [arrToSort objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.nick_pinyin];
        NSString *sr;
        if (strchar.length > 0) {
            sr= [strchar substringToIndex:1];
        } else {
            sr = @"#";
        }
        //sr containing here the first character of each string
        if(![sectionHeadsKeys containsObject:[sr uppercaseString]])
            //here I'm checking whether the character already in the selection header keys or not
        {
            [sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        
        if([sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[arrToSort objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

/**
 *  从服务器获取数据之后，更新UI
 *
 *  @param dictResult 服务器返回的数据dict
 */
-(void)reflushAddressDataFromServer:(NSMutableArray *)array isLocal:(BOOL)isLocal{
    
    [self clearAllArrayData];
    [muArrFriends addObjectsFromArray:array];
    if (!isLocal) {
        [self saveAddressDataToDB:array];
    }
    [self refrushTableView];
}

 /**
 *  保存数据到本地
 */
- (void)saveAddressDataToDB:(NSArray *)array {
    
    [[DBManager shareManager] openDataBase];
    [UserDao createUser];
    for (int i = 0; i < array.count; i++) {
        User *user = array[i];
        user.friend_flag = 1;
        [UserDao insertUser:user];
    }
}

/**
 *  排序并且刷新tableView
 */
-(void)refrushTableView {
    
    muArrFriends = [ArrayUtil sortArrayWithPinYin:muArrFriends];
    sortedArrForArrays = [self getChineseStringArr:muArrFriends];
    
    [self.tableView reloadData];
}

/**
 *  清空数据
 */
- (void)clearAllArrayData {
    
    // 清空数组
    [muArrFriends removeAllObjects] ;
    [sortedArrForArrays removeAllObjects];
    [sectionHeadsKeys removeAllObjects];
    [searchMuarr removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  筛选通讯录
 */
- (void)filteredFriendArray {
    
    [searchMuarr removeAllObjects];
    
    NSString *searchStirng = self.searchDisplayController.searchBar.text;
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
    [searchMuarr addObjectsFromArray:[muArrFriends filteredArrayUsingPredicate:predicate]];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self filteredFriendArray];
        return 1;
    } else {
        return [sortedArrForArrays count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchMuarr count];
    } else {
        return [[sortedArrForArrays objectAtIndex:section] count];
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (section == 0) {
            return 30;
        }
    }
    return 15;
}

// 返回头“A B C D E F G”
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [NSString stringWithFormat:@"  %@",[sectionHeadsKeys objectAtIndex:section]];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return sectionHeadsKeys;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    AddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[AddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    User *user;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {

        user = [searchMuarr objectAtIndex:indexPath.row];
        

    } else {

        NSArray *arr = [sortedArrForArrays objectAtIndex:indexPath.section];
        user = [arr objectAtIndex:indexPath.row];
        
    }
    
    [cell initWithData:user];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *user;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = [searchMuarr objectAtIndex:indexPath.row];
    } else {
        
        NSArray *arr = [sortedArrForArrays objectAtIndex:indexPath.section];
        user = [arr objectAtIndex:indexPath.row];
    }
    
    AddressDetailViewController *addressVc = [[AddressDetailViewController alloc] initWithNibName:@"AddressDetailViewController" bundle:nil];    
    addressVc.user = user;
    addressVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressVc animated:YES];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
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
