//
//  MyAccountViewController.m
//  NGEagle
//
//  Created by ZhangXiaoZhuo on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "MyAccountViewController.h"
#import "TransactionViewController.h"

@interface MyAccountViewController ()
{
    UITableView *myTable;
}
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    myTable.delegate = self;
    myTable.dataSource = self;
    [self.view addSubview:myTable];
    
    [DataHelper getWealth:^(id responseObject) {
        @try {
            self.wealth =(Wealth *)((WealthModel *)responseObject).data[0];
            [myTable reloadData];
        }
        @catch (NSException *exception) {
            
        }
       
    } fail:^(NSError *error) {
        
    }];
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"我的账户";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CellIdentifier];

        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(11*AutoSizeScale, 11, 22, 22)];
        iconImg.tag = 200;
        iconImg.contentMode = UIViewContentModeCenter;
        [cell.contentView addSubview:iconImg];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+14*AutoSizeScale, 16, 70, 12)];
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = [UIFont systemFontOfSize:12];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.tag = 201;
        [cell.contentView addSubview:titleLab];
        
        if (indexPath.row==0) {
            iconImg.image = [UIImage imageNamed:@"icon_doudou"];
            titleLab.text = @"知豆余额";
            
            UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 16, 70, 12)];
            detailLabel.textColor = [UIColor lightGrayColor];
            detailLabel.font = [UIFont systemFontOfSize:12];
            detailLabel.textAlignment = NSTextAlignmentRight;
            detailLabel.tag = 202;
            [cell.contentView addSubview:detailLabel];
            
        } else {
            iconImg.image = [UIImage imageNamed:@"icon_order"];
            titleLab.text = @"交易记录";
        }
    }
    
    UILabel *label =  (UILabel *)[cell.contentView viewWithTag:202];
    label.text = self.wealth.wealth;
    
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellStyleValue1;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Config your cell
    
    return cell;    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        TransactionViewController *viewcontroller = [[TransactionViewController alloc] initWithNibName:@"TransactionViewController" bundle:nil];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
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
