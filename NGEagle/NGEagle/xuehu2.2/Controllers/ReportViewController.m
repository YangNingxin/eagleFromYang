//
//  ReportViewController.m
//  NGEagle
//
//  Created by Liang on 16/5/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportModel.h"

@interface ReportViewController ()
{
    ReportModel *_reportModel;
    int _index;
    UIButton *_sureButton;
}
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = -1;
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headLabel.backgroundColor = RGB(247, 247, 247);
    headLabel.text = @" 请告诉我您举报的理由";
    headLabel.textColor = UIColorFromRGB(0x666666);
    headLabel.font = [UIFont systemFontOfSize:12.0];
    _tableView.tableHeaderView = headLabel;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(64);
        make.bottom.mas_offset(0);
    }];
    
    WS(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
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
    if (_index != -1) {
        
        Item *item = _reportModel.data[_index];
        
        [DataHelper reportByType:self.type target_id:self.target_id content:nil success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                [self.view makeToast:@"举报成功" duration:1.0 position:@"bottom"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self.view makeToast:@"举报失败" duration:1.0 position:@"bottom"];
            }
        } fail:^(NSError *error) {
            [self.view makeToast:@"举报失败" duration:1.0 position:@"bottom"];
        }];
    }
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"举报";
}

- (void)getDataFromServer {
    [DataHelper getReportList:^(id responseObject) {
        _reportModel = responseObject;
        if (_reportModel.error_code == 0) {
            [_tableView reloadData];
        }
        [_tableView.header endRefreshing];
    } fail:^(NSError *error) {
        [_tableView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _reportModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idfa = @"cell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:idfa];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfa];
    }
    Item *item = _reportModel.data[indexPath.row];
    cell.textLabel.text = item.name;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = UIColorFromRGB(0x333333);

    if (indexPath.row == _index) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _index = (int)indexPath.row;
    [tableView reloadData];
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
