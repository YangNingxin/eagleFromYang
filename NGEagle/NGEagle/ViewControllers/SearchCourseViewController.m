//
//  SearchCourseViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SearchCourseViewController.h"
#import "LineWordCell.h"
#import "CourseCell.h"
#import "CourseDetailViewController.h"
#import "Location.h"

@interface SearchCourseViewController ()

@end

@implementation SearchCourseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _page = 1;
    _pageNum = 20;
    if (!self.isShowHot) {
        _type = 1;
    } else {
        self.tableView.tableHeaderView = self.headView;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.tableView registerNib:[UINib nibWithNibName:@"LineWordCell" bundle:nil] forCellReuseIdentifier:@"LineWordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseCell" bundle:nil] forCellReuseIdentifier:@"CourseCell"];
    
    [_textField setPlaceholder:@"请输入课程名称"];
    [_textField setValue:UIColorFromRGB(0xb6b6b7) forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:[UIFont systemFontOfSize:12.0]
              forKeyPath:@"_placeholderLabel.font"];
    
    
    _searchRequest = [DataHelper getHotSearchWords:^(id responseObject) {
        _hotSearchModel = responseObject;
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)searchCourseisFlush:(BOOL)isFlush {
    [_courseRequest cancel];
    _courseRequest = nil;
    int currentPage;
    
    if (isFlush) {
        currentPage = 1;
    } else {
        currentPage = _page;
    }
    float lat = [Location shareManager].location.latitude;
    float lon = [Location shareManager].location.longitude;
    if (self.isShowHot) {
        lat = 0;
        lon = 0;
    }
    _courseRequest = [DataHelper getCourseList:currentPage page_num:_pageNum sort:0 lat:lat lon:lon kw:_keyWords params:nil  success:^(id responseObject) {
        
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
                        [weakSelf searchCourseisFlush:NO];
                    }];
                }
                _page = currentPage;
                
            } else {
                [_courseModel.data addObjectsFromArray:tempModel.data];
                if (tempModel.data.count != _pageNum) {
                    [self.tableView removeFooter];
                }
            }
            _page ++;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    _barImageView.hidden = YES;
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_type == 0) {
        return _hotSearchModel.data.count;
    }
    return _courseModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0) {
        return 40;
    }
    return 218;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0) {
        
        LineWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LineWordCell" forIndexPath:indexPath];
        cell.contentLabel.text = _hotSearchModel.data[indexPath.row];
        return cell;
        
    } else {
        
        CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];
        cell.course = _courseModel.data[indexPath.row];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        CourseDetailViewController *webVc = [[CourseDetailViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        Course *course = _courseModel.data[indexPath.row];
        webVc.webTitle = @"课程详情";
        webVc.url = course.url;
        webVc.webType = COURSE_DETAIL;
        webVc.cid = [course.cid intValue];
        [self.navigationController pushViewController:webVc animated:YES];
    } else {
        _keyWords = _hotSearchModel.data[indexPath.row];
        self.textField.text = _keyWords;
        _type = 1;
        [self.tableView reloadData];
        [self searchCourseisFlush:YES];
    }
}

#pragma mark
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //添加通知，当text发生改变的时候
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
}

- (void)textFieldDidChange:(NSNotification *)note {
    
    UITextField *textField = [note object];
    _keyWords = self.textField.text;

    if (textField.text.length >= 2) {
        _type = 1;
        [self searchCourseisFlush:YES];
    } else {
        if (!self.isShowHot) {
            _type = 1;
        } else {
            _type = 0;
        }
    }
    [self.tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] == 0) {
        return NO;
    }
    return YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textField resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
