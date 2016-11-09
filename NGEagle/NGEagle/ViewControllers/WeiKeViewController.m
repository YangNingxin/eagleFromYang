//
//  WeiKeViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "WeiKeViewController.h"

@interface WeiKeViewController ()

@end

@implementation WeiKeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)praseDict:(NSDictionary *)dict type:(int)type {
    
    [super praseDict:dict type:type];
    
    /*
     *  1--首页到课程列表
     *  2--首页到活动列表
     *  3--首页到微课列表
     *  4--获取附近的机构
     *  5--获取附近的课程
     */
    if (type == 0) {
        
        WeiKeViewController *weikeVc = [[WeiKeViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        weikeVc.url = dict[@"url"];
        weikeVc.webTitle = dict[@"title"];
        weikeVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:weikeVc animated:YES];
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

@end
