//
//  FindViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "FindViewController.h"
#import "FindDetailViewController.h"

@interface FindViewController ()
{
    NSString *findURL;
}
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)configBaseUI {
    [super configBaseUI];
     _titleLabel.text = @"发现";
    [_leftButton setImage:[UIImage imageNamed:@"left_menu"] forState:UIControlStateNormal];
    self.webview.height -= 49;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)praseDict:(NSDictionary *)dict type:(int)type {
    [super praseDict:dict type:type];
    if (type == 0) {
        FindDetailViewController *findVc = [[FindDetailViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        findVc.url = dict[@"url"];
        findVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:findVc animated:YES];
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
