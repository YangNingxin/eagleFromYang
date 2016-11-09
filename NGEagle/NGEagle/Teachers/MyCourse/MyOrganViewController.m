//
//  MyOrganViewController.m
//  NGEagle
//
//  Created by Liang on 15/9/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "MyOrganViewController.h"

@interface MyOrganViewController ()

@end

@implementation MyOrganViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)getDataFromServer:(BOOL)isFlush {
    
    [_request cancel];
    _request = nil;
 
    _request = [DataHelper getMyOrganization:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        
        OrganListModel *tempModel = responseObject;
        
        if (tempModel.error_code == 0 && tempModel.data.count > 0) {
            if (isFlush) {
                self.organListModel = nil;
                self.organListModel = tempModel;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"我的机构";
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
