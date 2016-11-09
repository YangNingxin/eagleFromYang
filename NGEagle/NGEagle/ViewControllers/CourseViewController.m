//
//  CourseViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CourseViewController.h"
#import "SearchCourseViewController.h"
#import "CourseCell.h"
#import "MJRefresh.h"
#import "CourseDetailViewController.h"

@interface CourseViewController ()
{
    SifterCourseView *_sifterCourseView;
}
@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    _pageNum = 20;
    _hotPage = _newPage = 1;
    
    for (int i = 0; i < 2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 88)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = 10 + i;
        [self.scrollView addSubview:tableView];
        
        [tableView registerNib:[UINib nibWithNibName:@"CourseCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        if (i == 0) {
            [tableView addLegendHeaderWithRefreshingBlock:^{
                [self getNewDataIsFlush:YES];
            }];
        } else {
            [tableView addLegendHeaderWithRefreshingBlock:^{
                [self getHotDataIsFlush:YES];
            }];
        }
    }
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 2, self.scrollView.height)];
    
    [[self getTableViewWithTag:10].header beginRefreshing];
    [[self getTableViewWithTag:11].header beginRefreshing];
    
    [self initSifterCourseView];
    // Do any additional setup after loading the view from its nib.
}

// 初始化筛选View
- (void)initSifterCourseView {
    _sifterCourseView = [[SifterCourseView alloc] initWithFrame:CGRectMake(0, 96, SCREEN_WIDTH, SCREEN_HEIGHT - 96)];
    _sifterCourseView.delegate = self;
    _sifterCourseView.backgroundColor = self.view.backgroundColor;
    _sifterCourseView.hidden = YES;
    [self.view addSubview:_sifterCourseView];
}

- (void)configBaseUI {
    _titleLabel.text = @"课程";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取new数据
- (void)getNewDataIsFlush:(BOOL)isFlush {
    
    [_newRequest cancel];
    _newRequest = nil;
    int currentPage;
    
    if (isFlush) {
        currentPage = 1;
    } else {
        currentPage = _newPage;
    }
    
    _newRequest = [DataHelper getCourseList:currentPage page_num:_pageNum sort:1 lat:0 lon:0 kw:@"" params:_params success:^(id responseObject) {
        
        [[self getTableViewWithTag:10].header endRefreshing];
        [[self getTableViewWithTag:10].footer endRefreshing];
        
        CourseModel *tempModel = responseObject;
        
        if (tempModel.error_code == 0 && tempModel.data.count > 0) {
            if (isFlush) {
                _newModel = nil;
                _newModel = tempModel;
                
                // 如果还有数据，添加footview
                if (_newModel.data.count == _pageNum && ![self getTableViewWithTag:10].footer) {
                    
                    __weak typeof(self) weakSelf = self;

                    [[self getTableViewWithTag:10] addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getNewDataIsFlush:NO];
                    }];
                }
                _newPage = currentPage;
                
            } else {
                [_newModel.data addObjectsFromArray:tempModel.data];
                if (tempModel.data.count != _pageNum) {
                    [[self getTableViewWithTag:10] removeFooter];
                }
            }
            _newPage ++;
            [[self getTableViewWithTag:10] reloadData];
        }
    } fail:^(NSError *error) {
        
        [[self getTableViewWithTag:10].header endRefreshing];
        [[self getTableViewWithTag:10].footer endRefreshing];
    }];
    
}


// 获取hot数据
- (void)getHotDataIsFlush:(BOOL)isFlush {
    
    [_hotRequest cancel];
    _hotRequest = nil;
    
    int currentPage;
    
    if (isFlush) {
        currentPage = 1;
    } else {
        currentPage = _hotPage;
    }
    
    _hotRequest = [DataHelper getCourseList:currentPage page_num:_pageNum sort:2 lat:0 lon:0 kw:@"" params:_params success:^(id responseObject) {
        
        [[self getTableViewWithTag:11].header endRefreshing];
        [[self getTableViewWithTag:11].footer endRefreshing];
        
        CourseModel *tempModel = responseObject;
        
        if (tempModel.error_code == 0 && tempModel.data.count > 0) {
            if (isFlush) {
                _hotModel = nil;
                _hotModel = tempModel;
                
                // 如果还有数据，添加footview
                if (_hotModel.data.count == _pageNum && ![self getTableViewWithTag:11].footer) {
                    
                    __weak typeof(self) weakSelf = self;

                    [[self getTableViewWithTag:11] addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getHotDataIsFlush:NO];
                    }];
                }
                _hotPage = currentPage;
                
            } else {
                [_hotModel.data addObjectsFromArray:tempModel.data];
                if (tempModel.data.count != _pageNum) {
                    [[self getTableViewWithTag:11] removeFooter];
                }
            }
            _hotPage ++;
            [[self getTableViewWithTag:11] reloadData];
        }
    } fail:^(NSError *error) {
        
        [[self getTableViewWithTag:11].header endRefreshing];
        [[self getTableViewWithTag:11].footer endRefreshing];
    }];
}

- (UITableView *)getTableViewWithTag:(int)tag {
    return (UITableView *)[self.scrollView viewWithTag:tag];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 10) {
        return _newModel.data.count;
    }
    return _hotModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 218;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView.tag == 10) {
        cell.course = _newModel.data[indexPath.row];
    } else {
        cell.course = _hotModel.data[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseDetailViewController *webVc = [[CourseDetailViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    Course *course;
    if (tableView.tag == 10) {
        course = _newModel.data[indexPath.row];
    } else {
        course = _hotModel.data[indexPath.row];
    }
    webVc.webTitle = @"课程详情";
    webVc.url = course.url;
    webVc.webType = COURSE_DETAIL;
    webVc.cid = [course.cid intValue];
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark
#pragma mark ScrollviewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return;
    }
    int page = scrollView.contentOffset.x / scrollView.width;
    if (page == 0) {
        [self changeStateImageViewPostion:self.cNewButton.centerX];

    } else {
        [self changeStateImageViewPostion:self.hotButton.centerX];
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

- (IBAction)newClickAction:(UIButton *)sender {
    [self changeStateImageViewPostion:sender.centerX];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)hotClickAction:(UIButton *)sender {
    [self changeStateImageViewPostion:sender.centerX];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}

- (void)changeStateImageViewPostion:(CGFloat)x {
    [UIView animateWithDuration:0.15 animations:^{
        self.stateImageView.centerX = x;
    }];
}

- (IBAction)selectClickAction:(UIButton *)sender {
    _sifterCourseView.hidden = !_sifterCourseView.hidden;
}

#pragma mark
#pragma mark SifterCourseViewDelegate

- (void)didSelectItemAtIndexPathWithParams:(NSDictionary *)params {
    
    _params = params;
    [self getHotDataIsFlush:YES];
    [self getNewDataIsFlush:YES];
}

- (void)rightButtonAction {
    SearchCourseViewController *searchVc = [[SearchCourseViewController alloc] initWithNibName:@"SearchCourseViewController" bundle:nil];
    searchVc.isShowHot = YES;
    [self.navigationController pushViewController:searchVc animated:YES];
}

@end
