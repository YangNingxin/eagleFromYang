//
//  CommentListViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentListCell.h"

@interface CommentListViewController ()
{
    CommentListCell *_tempCell;
}
@end

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _pageNum = 20;
    
    _tempCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentListCell" owner:self options:nil] lastObject];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:
     [UINib nibWithNibName:@"CommentListCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];
    
    
    __weak typeof(self) weakSelf = self;

    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf getDataFromServer:YES];
    }];
    
    [self.tableView.header beginRefreshing];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)getDataFromServer:(BOOL)isFlush {
    
    [_request cancel];
    _request = nil;
    int currentPage;
    
    if (isFlush) {
        currentPage = 1;
    } else {
        currentPage = _page;
    }
    
    _request = [DataHelper getAppraisesWithTypeID:self.cid type:1 page:currentPage pageNum:_pageNum success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        CommentListModel *tempModel = responseObject;
        
        if (tempModel.error_code == 0 && tempModel.data.count > 0) {
            if (isFlush) {
                self.listModel = nil;
                self.listModel = tempModel;
                
                // 如果还有数据，添加footview
                if (self.listModel.data.count == _pageNum && !self.tableView.footer) {
                    
                    __weak typeof(self) weakSelf = self;

                    [self.tableView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getDataFromServer:NO];
                    }];
                }
                _page = currentPage;
                
            } else {
                [self.listModel.data addObjectsFromArray:tempModel.data];
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
    
    [super configBaseUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleLabel.text = @"课程评论";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _tempCell.comment = self.listModel.data[indexPath.row];;
    return _tempCell.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.comment = self.listModel.data[indexPath.row];
    return cell;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
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
