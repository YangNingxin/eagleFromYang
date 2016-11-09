//
//  OrganizationViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "OrganizationViewController.h"
#import "CourseDetailViewController.h"

@interface OrganizationViewController ()

@end

@implementation OrganizationViewController

- (void)viewDidLoad {
    
    _newPage = 1;
    _pageNum = 20;
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView {
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.tag = 10 + i;
        switch (i) {
            case 0:
                [button setTitleColor:RGB(99, 192, 186) forState:UIControlStateNormal];
                [button setTitle:@"机构简介" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitle:@"机构课程" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    self.staueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 106, SCREEN_WIDTH / 2, 2)];
    self.staueImageView.backgroundColor = RGB(99, 192, 186);
    [self.view addSubview:self.staueImageView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT-108)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 2, self.scrollView.height)];
    
    // 添加机构简介
    self.webView = [[NGWebView alloc] initWithFrame:self.scrollView.bounds];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.scrollView addSubview:self.webView];
    
    // 添加机构课程
    self.tableView = [[UITableView alloc] initWithFrame:self.scrollView.bounds];
    self.tableView.left = self.scrollView.width;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.scrollView addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    __weak typeof(self) weakSelf = self;

    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getNewDataIsFlush:YES];
    }];
    [self.tableView.header beginRefreshing];
}


- (void)configBaseUI {
    [super configBaseUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleLabel.frame = CGRectMake(SCREEN_WIDTH/2-75, 20, 150, 44);
    
    _titleLabel.text = self.name;
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    _rightButotn.width = 100;
    _rightButotn.right = SCREEN_WIDTH - 10;
    [_rightButotn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    
    if (self.is_follow) {
        [_rightButotn setTitle:@"取消关注" forState:UIControlStateNormal];
    } else {
        [_rightButotn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    // 老师
    if ([Account shareManager].userModel.user.type == 1) {
        _rightButotn.hidden = YES;
    }
}

- (void)rightButtonAction {
    
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
    
    if (!self.is_follow) {
        [DataHelper followActionWithAction:1 type:1 object_id:self.organizationId success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                self.is_follow = YES;
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                [_rightButotn setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [SVProgressHUD showErrorWithStatus:model.error_msg];
            }
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"关注失败"];
        }];
    } else {
        
        [DataHelper followActionWithAction:0 type:1 object_id:self.organizationId success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                [SVProgressHUD showSuccessWithStatus:@"操作成功"];
                [_rightButotn setTitle:@"关注" forState:UIControlStateNormal];
                self.is_follow = NO;
            } else {
                [SVProgressHUD showErrorWithStatus:model.error_msg];
            }
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    }

    
}

// button点击事件
- (void)buttonAction:(UIButton *)button {
    
    int index = (int)button.tag - 10;
    
    [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    self.staueImageView.left = index * SCREEN_WIDTH/2;
    
    
    [button setTitleColor:RGB(99, 192, 186) forState:UIControlStateNormal];
    
    UIButton *otherBtn;
    if (index == 0) {
         otherBtn = (UIButton *)[self.view viewWithTag:11];
    } else {
        otherBtn = (UIButton *)[self.view viewWithTag:10];
    }
    [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.organizationId) forKey:@"school_id"];
    
    _newRequest = [DataHelper getCourseList:currentPage page_num:_pageNum sort:1 lat:0 lon:0 kw:@"" params:params success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        CourseModel *tempModel = responseObject;
        
        if (tempModel.error_code == 0 && tempModel.data.count > 0) {
            if (isFlush) {
                _courseModel = nil;
                _courseModel = tempModel;
                
                // 如果还有数据，添加footview
                if (_courseModel.data.count == _pageNum && !self.tableView.footer) {
                    

                    __weak typeof(self) weakSelf = self;

                    [self.tableView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getNewDataIsFlush:NO];
                    }];
                }
                _newPage = currentPage;
                
            } else {
                [_courseModel.data addObjectsFromArray:tempModel.data];
                if (tempModel.data.count != _pageNum) {
                    [self.tableView removeFooter];
                }
            }
            _newPage ++;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 218;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.course = self.courseModel.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetailViewController *webVc = [[CourseDetailViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    Course *course = _courseModel.data[indexPath.row];
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
    self.staueImageView.left = page * SCREEN_WIDTH/2;

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
