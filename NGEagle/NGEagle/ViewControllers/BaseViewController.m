 //
//  BaseViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "WTAZoomNavigationController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(239, 239, 244);
    
    _barImageView = [[SlurImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    _barImageView.userInteractionEnabled = YES;
    [self.view addSubview:_barImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, SCREEN_WIDTH - 80, 44)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_barImageView addSubview:_titleLabel];
    
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 50, 34)];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    _leftButton.backgroundColor = [UIColor clearColor];
    [_barImageView addSubview:_leftButton];
    
    
    _rightButotn = [[UIButton alloc] initWithFrame:
                    CGRectMake(SCREEN_WIDTH - 50, 25, 50, 34)];
    _rightButotn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_rightButotn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButotn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _rightButotn.backgroundColor = [UIColor clearColor];
    [_barImageView addSubview:_rightButotn];
    
    _shadowView = [[UIImageView alloc]initWithFrame:CGRectMake(0,  NavigationBar_HEIGHT-0.5, SCREEN_WIDTH, 0.5)];
    _shadowView.backgroundColor = RGB(200, 200, 200);
    [_barImageView addSubview:_shadowView];
    
    
    [self configBaseUI];
    // Do any additional setup after loading the view.
}

- (void)configBaseUI {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.navigationController viewControllers].count == 1) {
        _leftButton.left = 0;
    } else {
        _leftButton.left = 10;
    }
}
- (void)leftButtonAction {
    
    if ([self.navigationController viewControllers].count == 1) {
        [[self wta_zoomNavigationController] revealLeftViewController:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightButtonAction {
    
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
