//
//  SubscribeViewController.m
//  NGEagle
//
//  Created by Liang on 16/4/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SubscribeListViewController.h"
#import "CourseHelper.h"
#import "SubscribeTagListModel.h"
#import "CCCourseDetailController.h"

@interface SubscribeViewController () <RecommendCellDelegate>
{
    int page;
    int num;
    NSMutableArray *_dataArray;
}
@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    num = 5;
    
    _dataArray = [NSMutableArray new];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(64);
    }];
    
    [_tableView registerClass:[RecommendCell class] forCellReuseIdentifier:@"cell"];
    
    WS(weakSelf);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getCourseListFromServer:YES];
    }];
    [_tableView.header beginRefreshing];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSubscribeData) name:@"changeSubscribeData" object:nil];
    // Do any additional setup after loading the view.
}

- (void)changeSubscribeData {
    [_tableView.header beginRefreshing];
}

- (void)getCourseListFromServer:(BOOL)isRefresh {
    
    int tempPage;
    WS(weakSelf);
    
    if (isRefresh) {
        tempPage = 1;
    } else {
        tempPage = page;
    }
    
    [CourseHelper getUserSubscribeTagDetail:2 page:tempPage num:num success:^(id responseObject) {
        
        
        
        SubscribeTagListModel *model = responseObject;
        if (model.error_code == 0) {
            
            if (isRefresh) {
                [_dataArray removeAllObjects];
                page = 1;
            }
            if (model.data.count == num) {
                page ++;
                if (!_tableView.footer) {
                    [_tableView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getCourseListFromServer:NO];
                    }];
                }
            } else {
                [_tableView removeFooter];
            }
            [_dataArray addObjectsFromArray:model.data];
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
    [_rightButotn setImage:[UIImage imageNamed:@"add_book"] forState:UIControlStateNormal];
    _titleLabel.text = @"订阅";
}

- (void)rightButtonAction {
    SubscribeListViewController *vc = [[SubscribeListViewController alloc] init];
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 课程的东西
    return 262;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.subscribeTag = _dataArray[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickCourse:(CCCourse *)course {
    CCCourseDetailController *detailVc = [[CCCourseDetailController alloc] init];
    detailVc.course = course;
    [self.navigationController pushViewController:detailVc animated:YES];
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
