//
//  TEMyCourseListViewController.m
//  NGEagle
//
//  Created by Liang on 16/5/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "TEMyCourseListViewController.h"
#import "MarkCourseCell.h"
#import "CCCourseDetailController.h"
#import "CourseHelper.h"

@interface TEMyCourseListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIImageView *_statusImageView;
    UIView *topView;
    int _type;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    int page;
    int num;
    NSOperation *_operation;
}
@end

@implementation TEMyCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    num = 20;
    _dataArray = [NSMutableArray new];
    
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"我的课程";
}

- (void)initUI {
    
    topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(64);
        make.height.mas_offset(36);
    }];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton new];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [topView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(i * SCREEN_WIDTH /2);
            make.top.mas_offset(0);
            make.width.mas_offset(SCREEN_WIDTH / 2);
            make.height.equalTo(topView);
        }];
        
        switch (i) {
            case 0:
                [button setTitle:@"我的微课" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:@"我的专辑" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    _statusImageView = [UIImageView new];
    _statusImageView.backgroundColor = kThemeColor;
    [topView addSubview:_statusImageView];
    
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(0);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(topView.mas_bottom).offset(5);
    }];
    
    [_tableView registerClass:[MarkCourseCell class] forCellReuseIdentifier:@"cell"];
    
    WS(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer:YES];
    }];
    [_tableView.header beginRefreshing];
}

- (void)selectType:(UIButton *)btn {
    
    if (_type == btn.tag - 10) {
        return;
    }
    _type = (int)btn.tag - 10;
    
    [_statusImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_type * SCREEN_WIDTH / 2);
    }];
    
    // 刷新数据
    [_tableView.header beginRefreshing];
}

- (void)getDataFromServer:(BOOL)isRefresh {
    
    int tempPage;
    WS(weakSelf);
    
    if (isRefresh) {
        tempPage = 1;
        [_dataArray removeAllObjects];
        [_tableView reloadData];
    } else {
        tempPage = page;
    }
    if (_operation) {
        [_operation cancel];
        _operation = nil;
    }
    if (_type == 0) {
        
        [CourseHelper getWeikeList:tempPage num:num type:1 school_id:0 params:nil kw:nil self_flag:1 success:^(id responseObject) {
            CCCourseListModel *model = responseObject;
        
            if (model.error_code == 0) {
                
                if (isRefresh) {
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
        }];
    } else {
        
        _operation = [CourseHelper getWeikeAlbum:tempPage num:num type:1 school_id:0 kw:nil self_flag:1  success:^(id responseObject) {
            CCCourseListModel *model = responseObject;
           
            if (model.error_code == 0) {
                if (isRefresh) {
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
        }];
    }
    
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
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MarkCourseCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.course = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCCourseDetailController *detailVc = [[CCCourseDetailController alloc] init];
    detailVc.course = _dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
