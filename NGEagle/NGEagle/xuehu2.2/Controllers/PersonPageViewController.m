//
//  PersonPageViewController.m
//  NGEagle
//
//  Created by Liang on 16/5/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "PersonPageViewController.h"
#import "ShareView.h"
#import "ReportViewController.h"

@interface PersonPageViewController ()

@end

@implementation PersonPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"个人主页";
    [_rightButotn setImage:[UIImage imageNamed:@"icon_menu_more"] forState:UIControlStateNormal];
    _rightButotn.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)rightButtonAction {
    
    WS(weakSelf);
    ShareView *shareView = [[ShareView alloc] init];
    [shareView setClickEventBlock:^(int index) {
        if (index == 6) {
            ReportViewController *reportVc = [[ReportViewController alloc] init];
            [weakSelf.navigationController pushViewController:reportVc animated:YES];
        }
    }];
    [shareView show];
    
    //    UIImage *image = [UIImage imageNamed:@"icon_share"];
    //    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:@"内容--http://www.snslearn.com"
    //                                                         image:image location:nil urlResource:nil
    //                                           presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
    //        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
    //            NSLog(@"分享成功！");
    //        }
    //    }];
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
