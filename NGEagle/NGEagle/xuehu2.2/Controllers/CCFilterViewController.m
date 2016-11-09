//
//  CCFilterViewController.m
//  NGEagle
//
//  Created by Liang on 16/5/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCFilterViewController.h"
#import "FilterListModel.h"
#import "CourseHelper.h"
@interface CCFilterViewController ()
{
    FilterListModel *_model;
    BOOL _isAll;
    int _subjectId;
    int _gradeId;
    FilterComplete _block;
}
@end

@implementation CCFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isAll = YES;
    _subjectId = 0;
    _gradeId = 0;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-45);
    }];
    
    WS(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
    }];
    [_tableView.header beginRefreshing];
    
    UIButton *_answerButton = [UIButton new];
    [_answerButton setTitle:@"完成" forState:UIControlStateNormal];
    [_answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _answerButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_answerButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    _answerButton.layer.cornerRadius = 4.0;
    _answerButton.layer.masksToBounds = YES;
    _answerButton.backgroundColor = kThemeColor;
    [self.view addSubview:_answerButton];
    
    [_answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.bottom.mas_offset(-5);
        make.height.mas_offset(40);
    }];
    // Do any additional setup after loading the view.
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"筛选";
}

- (void)setFilterCompleteBlock:(FilterComplete)block {
    _block = block;
}

- (void)finishAction {
    if (_block) {
        _block(_isAll, _subjectId, _gradeId);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)getDataFromServer {
    [CourseHelper getFilterInfoType:self.type success:^(id responseObject) {
        _model = responseObject;
        if (_model.error_code == 0) {
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

#pragma mark
#pragma mark UITableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return _model.data.subjects.count;
            break;
        case 2:
            return _model.data.grades.count;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"全部";
            break;
        case 1:
            return @"学科";
            break;
        case 2:
            return @"年级";
            break;
 
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idfa = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfa];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idfa];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 60, 40)];
        detailLabel.font = [UIFont systemFontOfSize:15.0];
        detailLabel.textColor = kThemeColor;
        detailLabel.tag = 10;
        detailLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:detailLabel];
    }
    UILabel *detailLabel = [cell.contentView viewWithTag:10];
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"全部";
            break;
        case 1:
        {
            Filter *filter = _model.data.subjects[indexPath.row];
            cell.textLabel.text = filter.name;
            detailLabel.text = [NSString stringWithFormat:@"%d", filter.weike_count];
        }
            break;
        case 2:
        {
            Filter *filter = _model.data.grades[indexPath.row];
            cell.textLabel.text = filter.name;
            detailLabel.text = [NSString stringWithFormat:@"%d", filter.weike_count];
        }
            break;
        default:
            break;
    }
    if (_isAll) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        if (indexPath.section == 1) {
            
            Filter *filter = _model.data.subjects[indexPath.row];
            if (filter.fid == _subjectId) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else if (indexPath.section == 2) {
            
            Filter *filter = _model.data.grades[indexPath.row];
            if (filter.fid == _gradeId) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _isAll = YES;
    } else {
        _isAll = NO;
        if (indexPath.section == 1) {
            Filter *filter = _model.data.subjects[indexPath.row];
            _subjectId = filter.fid;
        } else {
            Filter *filter = _model.data.grades[indexPath.row];
            _gradeId = filter.fid;
        }
    }
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
