//
//  CategoryViewController.m
//  NGEagle
//
//  Created by Liang on 16/4/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CategoryViewController.h"
#import "CourseHelper.h"
#import "CourseFilterListModel.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTopView];
    
    _sifterCourseView = [[SifterCourseView alloc] initWithFrame:
                         CGRectMake(0, 96 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - (96+64))];
    _sifterCourseView.type = self.type;
    _sifterCourseView.delegate = self;
    _sifterCourseView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_sifterCourseView];
    
    if ([CourseFilterListModel shareManager].resultData) {
        [self addTopContentView];
    } else {
        [self getFilterFromServer];
    }
    // Do any additional setup after loading the view.
}

- (void)initTopView {
    
    _topView = [UIView new];
    [self.view addSubview:_topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(96);
    }];
    
    UIView *lineImageView = [UIView new];
    lineImageView.backgroundColor = RGB(204, 204, 204);
    [_topView addSubview:lineImageView];
    
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)addTopContentView {
    
    NSArray<KnowledgeType> *knowledges = [CourseFilterListModel shareManager].resultData.knowledges;
    
    float space = (SCREEN_WIDTH - 40 - 4 * 45) / 3;
    for (int i = 0; i < knowledges.count; i++) {
        
        KnowledgeType *type = knowledges[i];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20 + i* (space + 45), 13, 45, 70)];
        [_topView addSubview:view];
        UIButton *btn = [UIButton new];
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.mas_equalTo(0);
        }];
        
        UILabel *label = [UILabel new];
        
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:12.0];
        [view addSubview:label];
        
        label.text = type.name;
        switch (i) {
            case 0:
                [btn setImage:[UIImage imageNamed:@"icon_all"] forState:UIControlStateNormal];
                break;
            case 1:
                [btn setImage:[UIImage imageNamed:@"icon_xiaoxue"] forState:UIControlStateNormal];
                break;
            case 2:
                [btn setImage:[UIImage imageNamed:@"icon_chuzhong"] forState:UIControlStateNormal];
                break;
            case 3:
                [btn setImage:[UIImage imageNamed:@"icon_gaozhong"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (void)btnAction:(UIButton *)button {
    _sifterCourseView.type = (int)button.tag - 200;
    [_sifterCourseView.collectionView reloadData];
}

- (void)getFilterFromServer {
    [CourseHelper getCourseTypeFilters:^(id responseObject) {
        CourseFilterListModel *listModel = responseObject;
        if (listModel.error_code == 0) {
            [CourseFilterListModel shareManager].resultData = listModel.data;
            [self addTopContentView];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)configBaseUI {
    [super configBaseUI];
    _leftButton.hidden = YES;
    _titleLabel.text = @"全部分类";
    [_rightButotn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectItemAtIndexPathWithParams:(NSMutableDictionary *)params {
    NSLog(@"params is %@", params);
    [self rightButtonAction];
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
