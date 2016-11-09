//
//  TransactionViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "TransactionViewController.h"
#import "TransactionCell.h"

@interface TransactionViewController ()

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"TransactionCell"];
    
    
    __weak typeof(self) welkSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [welkSelf getDataFromServer];
    }];
    
    [self.tableView.header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)getDataFromServer {
    
    [DataHelper getTradingRecordsForOpencoursePage:1 page_num:-1 success:^(id responseObject) {
       
        [self.tableView.header endRefreshing];
        self.orderModel = responseObject;
        if (self.orderModel.error_code == 0) {
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.tableView.header endRefreshing];

    }];
}

- (void)deleteRecordWithIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"正在删除" maskType:SVProgressHUDMaskTypeClear];
    
    Order *order = self.orderModel.data[indexPath.row];
    [DataHelper deleteTradingRecordBillID:order.bill_id success:^(id responseObject) {
        
        ErrorModel *model = responseObject;
        if (model.error_code == 0) {
            
            [self.orderModel.data removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [SVProgressHUD dismiss];
            
        } else {
            [SVProgressHUD showErrorWithStatus:model.error_msg];
        }
        
    } fail:^(NSError *error) {
       
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];

}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"交易记录";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 165;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteRecordWithIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    cell.order = self.orderModel.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
