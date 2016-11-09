//
//  MainPageViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "MainPageViewController.h"
#import "CourseViewController.h"
#import "NearCourseViewController.h"
#import "NearOrganController.h"
#import "WeiKeViewController.h"
#import "KaoqingListViewController.h"
#import "CCCourseListController.h"
#import "CCPublishViewController.h"
#import "QuestionDetailController.h"
#import "MoreQuestionDetailController.h"
#import "SubscribeViewController.h"
#import "MyTaskViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"首页";
    [_leftButton setImage:[UIImage imageNamed:@"left_menu"] forState:UIControlStateNormal];
    self.webview.height -= 49;
}

#pragma mark
#pragma mark UIWebViewDelegate
- (void)praseDict:(NSDictionary *)dict type:(int)type {
    
    [super praseDict:dict type:type];
    
    if (type == 1) {
        CCCourseListController *courseVc = [[CCCourseListController alloc] init];
        courseVc.hidesBottomBarWhenPushed = YES;
        courseVc.courseType = 1;
        [self.navigationController pushViewController:courseVc animated:YES];
    } else if (type == 2) {
        
        // 改变下server地址
        [Account shareManager].server = dict[@"domain"];
        CCCourseListController *courseVc = [[CCCourseListController alloc] init];
        courseVc.courseType = 0;
        courseVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:courseVc animated:YES];
        
    } else if (type == 3) {
        
        SubscribeViewController *viewController = [[SubscribeViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if (type == 4) {
        
        MyTaskViewController *myTaskVc = [[MyTaskViewController alloc] init];
        myTaskVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myTaskVc animated:YES];
        
    } else if (type == 5) {
        // 我的全部作业
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
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
