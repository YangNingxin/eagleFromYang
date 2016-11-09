//
//  CCSearchViewController.m
//  NGEagle
//
//  Created by Liang on 16/4/19.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCSearchViewController.h"
#import "CCSearchDetailController.h"

@interface CCSearchViewController ()
{
    UIImageView *_statusImageView;
    UIView *topView;
    int _type;
}
@end

@implementation CCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Do any additional setup after loading the view.
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"搜索";
}
- (void)initUI {
    
    topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(64);
        make.height.mas_offset(36);
    }];
    
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton new];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [topView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(i * SCREEN_WIDTH /2);
            make.top.mas_offset(0);
            make.width.mas_offset(SCREEN_WIDTH / 2);
            make.height.equalTo(topView);
        }];
        
        switch (i) {
            case 0:
                [button setTitle:@"校内" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:@"云课堂" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    _statusImageView = [UIImageView new];
    _statusImageView.backgroundColor = kThemeColor;
    [topView addSubview:_statusImageView];
    
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(0);
    }];
    
    UIView *searchView = [UIView new];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *searchImageView = [UIImageView new];
    searchImageView.image = [UIImage imageNamed:@"click_search"];
    [searchView addSubview:searchImageView];
    
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(searchView);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [searchView addGestureRecognizer:tap];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton new];
        button.tag = 20 + i;
        [button addTarget:self action:@selector(clickType:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(searchView.mas_bottom).offset(30);
        }];
        switch (i) {
            case 0:
            {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(-SCREEN_WIDTH / 3.0);
                }];
                [button setImage:[UIImage imageNamed:@"search_kecheng"] forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                }];
                [button setImage:[UIImage imageNamed:@"search_zhuji"] forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(SCREEN_WIDTH / 3.0);
                }];
                [button setImage:[UIImage imageNamed:@"search_wenda"] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
}

- (void)selectType:(UIButton *)btn {
    _type = (int)btn.tag - 10;
    
    [_statusImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo( _type * SCREEN_WIDTH / 2);
    }];
}

- (void)tapAction {
    CCSearchDetailController *detailVc = [[CCSearchDetailController alloc] init];
    detailVc.subType = -1;
    detailVc.type = _type;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)clickType:(UIButton *)btn {
    CCSearchDetailController *detailVc = [[CCSearchDetailController alloc] init];
    detailVc.type = _type;
    detailVc.subType = (int)btn.tag - 20;
    [self.navigationController pushViewController:detailVc animated:YES];
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
