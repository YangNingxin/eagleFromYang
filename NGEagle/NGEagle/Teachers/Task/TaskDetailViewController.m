//
//  TaskDetailViewController.m
//  NGEagle
//
//  Created by Liang on 15/9/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TaskAnserCell.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[TaskAnserCell class] forCellReuseIdentifier:@"TaskAnserCell"];

    [self initBottomView];
    // Do any additional setup after loading the view from its nib.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    _titleLabel.text = @"任务单详情";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

- (void)initBottomView {
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, SCREEN_HEIGHT-44, SCREEN_WIDTH/2, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        switch (i) {
            case 0:
                button.backgroundColor = UIColorFromRGB(0xee6267);
                [button setTitle:@"重新帮他提交" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_resub"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_resub"] forState:UIControlStateHighlighted];
                break;
            case 1:
                button.backgroundColor = UIColorFromRGB(0x50c0bb);
                [button setImage:[UIImage imageNamed:@"icon_tuijian"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_tuijian"] forState:UIControlStateHighlighted];
                [button setTitle:@"推荐到成果墙" forState:UIControlStateNormal];
                
                break;
            default:
                break;
        }
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 100) {
        
    } else if (button.tag == 101) {
        
        [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
        
        [DataHelper modifyTaskAnswerStatusByAnswerId:self.taskAnswer.answerId status:3 success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                [SVProgressHUD showSuccessWithStatus:@"推荐成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:model.error_msg];
            }
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"推荐失败，请重试"];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.taskAnswer.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskAnserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskAnserCell" forIndexPath:indexPath];
    cell.taskAnswer = self.taskAnswer;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
