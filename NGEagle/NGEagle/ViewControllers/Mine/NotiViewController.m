//
//  NotiViewController.m
//  NGEagle
//
//  Created by ZhangXiaoZhuo on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NotiViewController.h"
#import "NotiTableViewCell.h"
#import "Account.h"
#import "NotifationModel.h"

@interface NotiViewController ()
{
    UITableView *_tableView;
    UIImageView *_staueImageView;
    
    /**
     *  数据源
     */
    NotifationModel *dataModel;
}
@end

@implementation NotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([Account shareManager].userModel.user.type == 1) {
        [self initTeacherView];
    } else {
        [self initStudentView];
    }
    
    // Do any additional setup after loading the view.
}

/**
 *  获取通知列表
 *
 *  @param type=0 我收到的通知，type=1 我的通知
 */
- (void)getNoteListFromServerWithType:(int)type {
    
}

- (void)initTeacherView {
    
    [self addTopView];
    [self addTableView];
}

- (void)initStudentView {
    [self addTableView];
}


- (void)addTopView {
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(SCREEN_WIDTH/2*i, 64, SCREEN_WIDTH/2, 44);
        button.tag = 10 + i;
        switch (i) {
            case 0:
                [button setTitleColor:RGB(99, 192, 186) forState:UIControlStateNormal];
                [button setTitle:@"收到的通知" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitle:@"我的通知" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    _staueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 106, SCREEN_WIDTH / 2, 2)];
    _staueImageView.backgroundColor = RGB(99, 192, 186);
    [self.view addSubview:_staueImageView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 107, SCREEN_WIDTH, 1.0)];
    lineImageView.backgroundColor = RGB(220, 220, 220);
    [self.view addSubview:lineImageView];
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                             style:UITableViewStyleGrouped];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if ([Account shareManager].userModel.user.type == 1) {
        _tableView.frame = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    }
}

- (void)buttonAction:(UIButton *)button {
    
    int index = (int)button.tag - 10;
    
    _staueImageView.left = index * SCREEN_WIDTH/2;
    
    
    [button setTitleColor:RGB(99, 192, 186) forState:UIControlStateNormal];
    
    UIButton *otherBtn;
    if (index == 0) {
        otherBtn = (UIButton *)[self.view viewWithTag:11];
    } else {
        otherBtn = (UIButton *)[self.view viewWithTag:10];
    }
    [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)configBaseUI {
    [super configBaseUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleLabel.text = @"通知";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *idfa = @"cell";
    NotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfa];// Config your cell
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotiTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        
    } else {

    }
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
