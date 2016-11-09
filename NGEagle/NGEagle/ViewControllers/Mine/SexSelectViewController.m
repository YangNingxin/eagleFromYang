//
//  SexSelectViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SexSelectViewController.h"

@interface SexSelectViewController ()

@end

@implementation SexSelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.itemArray addObject:@"保密"];
    [self.itemArray addObject:@"男"];
    [self.itemArray addObject:@"女"];
    
    // Do any additional setup after loading the view.
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"修改性别";
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
