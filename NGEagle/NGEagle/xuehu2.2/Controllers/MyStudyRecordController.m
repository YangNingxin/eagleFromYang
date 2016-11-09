//
//  MyStudyRecordController.m
//  NGEagle
//
//  Created by Liang on 16/4/20.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "MyStudyRecordController.h"
#import "RecordCourseCell.h"
#import "StudyRecordModel.h"
#import "CCCourseDetailController.h"

@interface MyStudyRecordController () <UITableViewDelegate, UITableViewDataSource>
{
    UIImageView *_headImageView;
    UILabel *_titleLbl;
    UILabel *_timeLbl;
    
    UIButton *_numberBtn1;
    UIButton *_numberBtn2;
    UITableView *_tableView;
    
    int page;
    int num;
    NSMutableArray *_dataArray;
    StudyRecordModel *_studyModel;
}
@end

@implementation MyStudyRecordController

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
    _shadowView.hidden = YES;
    _barImageView.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"学习记录";
}

- (void)initUI {
    UIImageView *topView = [UIImageView new];
    topView.image = [UIImage imageNamed:@"back_record"];
    topView.contentMode = UIViewContentModeScaleAspectFill;
    topView.clipsToBounds = YES;
    [self.view insertSubview:topView atIndex:0];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    UIImageView *sanjiaoView = [UIImageView new];
    sanjiaoView.image = [UIImage imageNamed:@"dasanjiao"];
    [topView addSubview:sanjiaoView];
    
    [sanjiaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.centerX.mas_equalTo(0);
    }];
    
    _headImageView = [UIImageView new];
    _headImageView.backgroundColor = [UIColor redColor];
    _headImageView.layer.cornerRadius = 25.0;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.borderWidth = 2.0;
    _headImageView.layer.masksToBounds = YES;
    [topView addSubview:_headImageView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(60);
    }];
    
    [_headImageView setImageWithURL:[NSURL URLWithString:[Account shareManager].userModel.user.logo]
                   placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    _titleLbl = [UILabel new];
    _titleLbl.text  = @"学习小达人";
    _titleLbl.textColor = [UIColor whiteColor];
    _titleLbl.font = [UIFont systemFontOfSize:11.0];
    [topView addSubview:_titleLbl];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(_headImageView.mas_bottom).offset(5);
    }];
    
    _timeLbl = [UILabel new];
    _timeLbl.textColor = [UIColor whiteColor];
    _timeLbl.font = [UIFont systemFontOfSize:11.0];
    [topView addSubview:_timeLbl];
    
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(_titleLbl.mas_bottom).offset(10);
    }];
    
    _numberBtn1 = [UIButton new];
    [_numberBtn1 setBackgroundImage:[UIImage imageNamed:@"yuan"] forState:UIControlStateNormal];
    [_numberBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topView addSubview:_numberBtn1];
    
    [_numberBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sanjiaoView.mas_left).offset(0);
        make.bottom.equalTo(sanjiaoView.mas_bottom).offset(20);
    }];
    
    UILabel *lbl1 = [UILabel new];
    lbl1.text  = @"单个课程";
    lbl1.textColor = [UIColor whiteColor];
    lbl1.font = [UIFont systemFontOfSize:14.0];
    [topView addSubview:lbl1];
    
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberBtn1.mas_bottom).offset(5);
        make.centerX.equalTo(_numberBtn1);
    }];
    
    _numberBtn2 = [UIButton new];
    [_numberBtn2 setBackgroundImage:[UIImage imageNamed:@"yuan"] forState:UIControlStateNormal];
    [_numberBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topView addSubview:_numberBtn2];
    
    [_numberBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sanjiaoView.mas_right).offset(0);
        make.bottom.equalTo(sanjiaoView.mas_bottom).offset(20);
    }];
    
    UILabel *lbl2 = [UILabel new];
    lbl2.text  = @"课程专辑";
    lbl2.textColor = [UIColor whiteColor];
    lbl2.font = [UIFont systemFontOfSize:14.0];
    [topView addSubview:lbl2];
    
    [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberBtn2.mas_bottom).offset(5);
        make.centerX.equalTo(_numberBtn2);
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

- (void)updateHeadUI {
    _titleLbl.text  = @"学习小达人";
    _timeLbl.text  = [NSString stringWithFormat:@"累积在线学习%@", _studyModel.format_study_time]; //@"累积在线学习1086小时";
    [_numberBtn1 setTitle:[NSString stringWithFormat:@"%d", _studyModel.weike_count] forState:UIControlStateNormal];
    [_numberBtn2 setTitle:[NSString stringWithFormat:@"%d", _studyModel.album_count] forState:UIControlStateNormal];
}

- (void)getDataFromServer:(BOOL)isRefresh {
    
    int tempPage;
    WS(weakSelf);
    
    if (isRefresh) {
        tempPage = 1;
    } else {
        tempPage = page;
    }
    
    [DataHelper getUserStudyRecordByPage:tempPage num:num success:^(id responseObject) {
        
        StudyRecordModel *model = responseObject;
        _studyModel = model;
        
        if (model.error_code == 0) {
            
            if (isRefresh) {
                [_dataArray removeAllObjects];
                page = 1;
            }
            
            [self updateHeadUI];
            
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

#pragma mark
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
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
    label.text = course.format_study_ctime;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCCourseDetailController *detailVc = [[CCCourseDetailController alloc] init];
    detailVc.course = _dataArray[indexPath.section];
    [self.navigationController pushViewController:detailVc animated:YES];
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
