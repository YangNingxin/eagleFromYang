//
//  SubscribeListViewController.m
//  NGEagle
//
//  Created by Liang on 16/4/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SubscribeListViewController.h"
#import "KnowledgePointCell.h"
#import "SubSelSubjectController.h"
#import "CourseHelper.h"
#import "UserTagSubscribeModel.h"

@interface SubscribeListViewController () <UIAlertViewDelegate>
{
    UILabel *_label;
    LeftImageRightLabel *_left1;
    LeftImageRightLabel *_left2;
    
    int stage_id;
    int subject_id;
    int page;
    int num;
    NSMutableArray *_dataArray;
    UserTagSubscribe *_userTagSubscribe;
}
@end

@implementation SubscribeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    num = 20;
    _dataArray = [NSMutableArray new];
    
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView {
    
    UIView *topView = [UIView new];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_offset(0);
        make.top.mas_offset(64);
        make.height.mas_offset(45);
    }];
    
    _label = [UILabel new];
//    _label.text = @"初中数学";
    _label.textColor = UIColorFromRGB(0x666666);
    _label.font = [UIFont systemFontOfSize:13.0];
    [topView addSubview:_label];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.mas_offset(0);
    }];
    
    _left1 = [LeftImageRightLabel new];
    _left1.label.textColor = UIColorFromRGB(0x666666);
    _left1.label.font = [UIFont systemFontOfSize:13.0];
    [topView addSubview:_left1];
    
    [_left1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label.mas_right).offset(20);
        make.centerY.mas_offset(0);
    }];
    [_left1.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    _left1.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_left1 initWithData:@"已订阅" image:[UIImage imageNamed:@"blue_gray"]];
    
    _left2 = [LeftImageRightLabel new];
    _left2.label.textColor = UIColorFromRGB(0x666666);
    _left2.label.font = [UIFont systemFontOfSize:13.0];
    [topView addSubview:_left2];
    
    [_left2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_left1.mas_right).offset(20);
        make.centerY.mas_offset(0);
    }];
    [_left2.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    _left2.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_left2 initWithData:@"未订阅" image:[UIImage imageNamed:@"gray_fire"]];

    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    [_tableView registerClass:[KnowledgePointCell class] forCellReuseIdentifier:@"cell"];
    
    WS(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer:YES];
    }];
    [_tableView.header beginRefreshing];
}

- (void)getDataFromServer:(BOOL)isRefresh {
    
    int tempPage;
    WS(weakSelf);
    
    if (isRefresh) {
        tempPage = 1;
    } else {
        tempPage = page;
    }
    
    [CourseHelper getUserTagSubscribeInfo:2 stage_id:stage_id subject_id:subject_id weike_stat:1 album_stat:-1 page:tempPage num:num success:^(id responseObject) {
        
        UserTagSubscribeModel *model = responseObject;
        
        if (model.error_code == 0) {
            if (isRefresh) {
                [_dataArray removeAllObjects];
                page = 1;
            }
            if (model.data.count == num) {
                page ++;
                if (!_tableView.footer) {
                    [_tableView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getDataFromServer:NO];
                    }];
                }
            } else {
                [_tableView removeFooter];
            }
            
            [_dataArray addObjectsFromArray:model.data];
            if (_dataArray.count == 0) {
                [self.view makeToast:@"数据为空" duration:1.0 position:@"bottom"];
            }
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
    } fail:^(NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];;
}

- (void)configBaseUI {
    _rightButotn.hidden = NO;
    _titleLabel.text = @"订阅知识点管理";
    [_rightButotn setImage:[UIImage imageNamed:@"right_menu"] forState:UIControlStateNormal];
}

- (void)rightButtonAction {

    SubSelSubjectController *vc = [[SubSelSubjectController alloc] init];
    [vc setCompelte:^(NSMutableDictionary *dict) {
        stage_id = [dict[@"stage_id"] intValue];
        subject_id = [dict[@"subject_id"] intValue];
        _label.text = dict[@"desc"];
        [_tableView.header beginRefreshing];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 课程的东西
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KnowledgePointCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.userTagSubscribe = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTagSubscribe *userTagSubscribe = _dataArray[indexPath.row];
    
    _userTagSubscribe = userTagSubscribe;
    
    if (!userTagSubscribe.subscribe_flag) { // 订阅
        [CourseHelper setUserTag:2 ids:userTagSubscribe.sid action:1 success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                userTagSubscribe.subscribe_flag = YES;
                [_tableView reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSubscribeData" object:nil];
            } else {
                [self.view makeToast:model.error_msg duration:1.0 position:@"bottom"];
            }
        } fail:^(NSError *error) {
            
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要取消订阅吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [CourseHelper delUserTag:2 ids:_userTagSubscribe.sid success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                _userTagSubscribe.subscribe_flag = NO;
                [_tableView reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSubscribeData" object:nil];
            } else {
                [self.view makeToast:model.error_msg duration:1.0 position:@"bottom"];

            }
        } fail:^(NSError *error) {
            
        }];
    }
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
