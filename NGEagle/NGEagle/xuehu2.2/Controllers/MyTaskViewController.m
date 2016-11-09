//
//  MyTaskViewController.m
//  NGEagle
//
//  Created by Liang on 16/4/20.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "MyTaskViewController.h"
#import "RecordCourseCell.h"
#import "CCCourseDetailController.h"
#import "CCFilterViewController.h"

@interface MyTaskViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIImageView *_statusImageView;
    UIView *topView;
    int _type;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    int page;
    int num;
    NSOperation *_operation;
    
    int _subjectId;
    int _gradeId;
}
@end

@implementation MyTaskViewController

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
    _titleLabel.text = @"我的任务";
    _rightButotn.hidden = NO;
    [_rightButotn setTitle:@"筛选" forState:UIControlStateNormal];

}

- (void)rightButtonAction {
    CCFilterViewController *filterVc = [[CCFilterViewController alloc] init];
    [filterVc setFilterCompleteBlock:^(BOOL isAll, int subjectId, int gradeId) {
        if (isAll) {
            _subjectId = 0;
            _gradeId = 0;
        } else {
            _subjectId = subjectId;
            _gradeId = gradeId;
        }
        [_tableView.header beginRefreshing];
    }];
    [self.navigationController pushViewController:filterVc animated:YES];
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
                [button setTitle:@"推荐的微课" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:@"推荐的专辑" forState:UIControlStateNormal];
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    [_tableView registerClass:[RecordCourseCell class] forCellReuseIdentifier:@"RecordCourseCell"];
    
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
        make.left.mas_equalTo( _type * SCREEN_WIDTH / 2);
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
        _operation = [DataHelper getPublishToMeWeikeByPage:tempPage num:num subject_id:_subjectId grade_id:_gradeId success:^(id responseObject) {
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
        
        _operation = [DataHelper getPublishToMeAlbumBySubject_id:_subjectId grade_id:_gradeId page:tempPage num:num success:^(id responseObject) {
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
    return _dataArray.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    CCCourse *course = _dataArray[section];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"day1"];
    [view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(6);
        make.centerY.mas_offset(0);
    }];
    
    UILabel *label = [UILabel new];
    label.text = course.format_ctime;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = UIColorFromRGB(0x666666);
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5);
        make.centerY.mas_offset(0);
    }];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCourseCell" forIndexPath:indexPath];
    cell.course = _dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCCourseDetailController *detailVc = [[CCCourseDetailController alloc] init];
    detailVc.course = _dataArray[indexPath.section];
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
