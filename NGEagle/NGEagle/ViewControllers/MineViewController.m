//
//  MineViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "MineViewController.h"
#import "MyAccountViewController.h"
#import "NotiViewController.h"
#import "LearnCourseController.h"
#import "CourseMessageController.h"
#import "SetViewController.h"
#import "ContactViewController.h"
#import "ChangeMineViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DBManager.h"
#import "MyCourseViewController.h"
#import "MyOrganViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userType = [Account shareManager].userModel.user.type;
    
    _titleLabel.text = @"我的";
    
    
    headBackImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 190)];
    headBackImgView.userInteractionEnabled = YES;
    headBackImgView.image = [UIImage imageNamed:@"back_image"];
    
    headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-67/2, 16, 67, 67)];
    headImgView.backgroundColor = [UIColor grayColor];
    headImgView.userInteractionEnabled = YES;
    headImgView.contentMode = UIViewContentModeScaleAspectFill;
    headImgView.clipsToBounds = YES;
    headImgView.layer.cornerRadius = 33.5;
    [headBackImgView addSubview:headImgView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchHead)];
    [headImgView addGestureRecognizer:tapGesture];
    
//    UIImageView *identityImgView = [[UIImageView alloc]initWithFrame:CGRectMake(47, 47, 20, 20)];
//    identityImgView.image = [UIImage imageNamed:@""];
//    identityImgView.backgroundColor = [UIColor blueColor];
//    [headImgView addSubview:identityImgView];

    nameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-75, headImgView.bottom+5, 150, 16)];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:16];
    [headBackImgView addSubview:nameLab];
    
    
    schoolLab = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLab.bottom+5, SCREEN_WIDTH, 12)];
    schoolLab.textColor = [UIColor whiteColor];
    schoolLab.textAlignment = NSTextAlignmentCenter;
    schoolLab.font = [UIFont systemFontOfSize:11];
    [headBackImgView addSubview:schoolLab];
    
    //我是分割线
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, schoolLab.bottom+10, SCREEN_WIDTH, 0.4)];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.alpha = 0.3;
    [headBackImgView addSubview:lineView];
    
    CGFloat oneWidth = SCREEN_WIDTH/3;
    CGFloat iconWidth = 12;
    CGFloat labWidth = 60;
    for (int i=0; i<3; i++) {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(oneWidth*i, schoolLab.bottom+17, oneWidth, 54);
        myButton.tag = 100+i;
        [myButton addTarget:self action:@selector(myEvent:) forControlEvents:UIControlEventTouchUpInside];
        [headBackImgView addSubview:myButton];
        
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(oneWidth/2-iconWidth/2, 5, iconWidth, iconWidth)];
        [myButton addSubview:iconImg];
        
        UILabel *myLab = [[UILabel alloc]initWithFrame:CGRectMake(oneWidth/2-labWidth/2, iconImg.bottom+10, labWidth, 13)];
        myLab.textColor = [UIColor whiteColor];
        myLab.font = [UIFont systemFontOfSize:13];
        myLab.textAlignment = NSTextAlignmentCenter;
        [myButton addSubview:myLab];
        
        if (i==0) {
            iconImg.image = [UIImage imageNamed:@"icon_myAccount"];
            myLab.text = @"我的账户";
        
        } else if (i==1) {
            iconImg.image = [UIImage imageNamed:@"icon_current_learn"];
            if (userType == 1) {
                myLab.text = @"我的课程";

            } else {
                myLab.text = @"正在学的";

            }
        } else {
            iconImg.image = [UIImage imageNamed:@"icon_history"];
            
            if (userType == 1) {
                myLab.text = @"我的机构";
            } else {
                myLab.text = @"已经学过";
            }
        }
    }
    
    myTable = [[UITableView alloc]initWithFrame:
               CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    myTable.delegate = self;
    myTable.dataSource = self;
    [self.view addSubview:myTable];
    
    myTable.tableHeaderView = headBackImgView;
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [headImgView setImageWithURL:[NSURL URLWithString:[Account shareManager].userModel.user.logo]];

    nameLab.text = [Account shareManager].userModel.user.nick;
    schoolLab.text = [[Account shareManager].userModel.user schoolToString];

    [myTable reloadData];
}

- (void)touchHead {
    ChangeMineViewController *changeMineVc = [[ChangeMineViewController alloc]init];
    changeMineVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeMineVc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CellIdentifier];
        if (indexPath.section == 2) {
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 14, 200, 17)];
            titleLab.textColor = [UIColor redColor];
            titleLab.font = [UIFont systemFontOfSize:17];
            titleLab.textAlignment = NSTextAlignmentCenter;
            titleLab.tag = 201;
            titleLab.text = @"退出登录";
            [cell.contentView addSubview:titleLab];
        } else {
            UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(11*AutoSizeScale, 11, 22, 22)];
            iconImg.tag = 200;
            [cell.contentView addSubview:iconImg];
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+14*AutoSizeScale, 15, 70, 15)];
            titleLab.textColor = [UIColor blackColor];
            titleLab.font = [UIFont systemFontOfSize:15];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.tag = 201;
            [cell.contentView addSubview:titleLab];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 12, 20, 20)];
            numberLabel.backgroundColor = [UIColor redColor];
            numberLabel.layer.cornerRadius = 10.0;
            numberLabel.font = [UIFont systemFontOfSize:12.0];
            numberLabel.adjustsFontSizeToFitWidth = YES;
            numberLabel.layer.masksToBounds = YES;
            numberLabel.tag = 202;
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:numberLabel];
            
            if (indexPath.section == 0) {
               
                if (indexPath.row == 0) {
                    iconImg.image = [UIImage imageNamed:@"icon_tongzhi"];
                    titleLab.text = @"我的通知";
                } else {
                    iconImg.image = [UIImage imageNamed:@"icon_kecheng"];
                    titleLab.text = @"课程消息";
                }
               
                
            } else if (indexPath.section == 1) {
                iconImg.image = [UIImage imageNamed:@"icon_set"];
                titleLab.text = @"系统设置";
                
            }
        }
    }
    
    UILabel *numberLabel = (UILabel *)[cell.contentView viewWithTag:202];
    numberLabel.hidden = YES;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            int number = [Account shareManager].messageNumber.announcement.countNumber;
            if (number != 0) {
                numberLabel.text = [NSString stringWithFormat:@"%d", number];
                numberLabel.hidden = NO;
            }
            
        } else {
            
            int number = [Account shareManager].messageNumber.course.countNumber;
            if (number != 0) {
                numberLabel.text = [NSString stringWithFormat:@"%d", number];
                numberLabel.hidden = NO;
            }
        }
        
    }
    // Config your cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            NotiViewController *notiVc = [[NotiViewController alloc] init];
            notiVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:notiVc animated:YES];

        } else if (indexPath.row == 1) {
        
            CourseMessageController *courseVc = [[CourseMessageController alloc] initWithNibName:@"CourseMessageController" bundle:nil];
            courseVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:courseVc animated:YES];
        }
    } else if (indexPath.section == 1) {
        
//        if (indexPath.row == 0) {
            SetViewController *setVc = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
            setVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVc animated:YES];
            
//        } else if (indexPath.row == 1) {
//            ContactViewController *contactVc = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
//            contactVc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:contactVc animated:YES];
//        }
        
    } else {
        
        [SVProgressHUD showWithStatus:@"正在退出..." maskType:SVProgressHUDMaskTypeClear];
        
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            
            if (!error) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(1)];
                [SVProgressHUD showSuccessWithStatus:@"成功退出"];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"退出失败，请重试"];
            }
            
        } onQueue:nil];

    }
}

- (void)myEvent:(UIButton *)sender {

    if (sender.tag == 100) {
        MyAccountViewController *myAccountVc = [[MyAccountViewController alloc]init];
        myAccountVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController  pushViewController:myAccountVc animated:YES];

    } else  {
        
        if (userType == 1) {
            
            if (sender.tag == 101) {
                MyCourseViewController *myCourseVc = [[MyCourseViewController alloc] initWithNibName:@"MyCourseViewController" bundle:nil];
                myCourseVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myCourseVc animated:YES];
            } else {
                MyOrganViewController *myOrganVc = [[MyOrganViewController alloc] initWithNibName:@"FollowOrganListController" bundle:nil];
                myOrganVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myOrganVc animated:YES];
            }
            
        } else {
            LearnCourseController *learnVc = [[LearnCourseController alloc] initWithNibName:@"LearnCourseController" bundle:nil];
            learnVc.hidesBottomBarWhenPushed = YES;
            learnVc.type = (int)sender.tag - 100;
            [self.navigationController pushViewController:learnVc animated:YES];
        }        
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
