//
//  QrResultViewController.m
//  NGEagle
//
//  Created by Liang on 16/5/3.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "QrResultViewController.h"

@interface QrResultViewController ()

@end

@implementation QrResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = @"扫描结果";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftButtonAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
