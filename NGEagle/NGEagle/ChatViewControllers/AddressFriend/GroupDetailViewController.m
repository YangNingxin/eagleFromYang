//
//  ViewController.m
//  TableViewController
//
//  Created by ZhangXiaoZhuo on 15/8/21.
//  Copyright (c) 2015年 zhangguohui. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "StringSizeUtil.h"
#import "ChatViewController.h"
#import "ClassMemberViewController.h"

@interface GroupDetailViewController ()

@end



@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myTable = [[UITableView alloc]initWithFrame:
               CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)
                                          style:UITableViewStyleGrouped];
    myTable.delegate = self;
    myTable.dataSource = self;
    [self.view addSubview:myTable];
    
    __weak typeof(self) weakSelf = self;
    [myTable addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
    }];
    [myTable.header beginRefreshing];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)getDataFromServer {
    
    [ChatDataHelper getGroupInfoById:self.groupInfo.gid success:^(id responseObject) {
        
        GroupInfoModel *infoModel = responseObject;
        if (infoModel.error_code == 0 && infoModel.data) {
            
            for (int i = 99; i < 3; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:i];
                [button removeFromSuperview];
                button = nil;
            }
            
            self.groupInfo = infoModel.data;
           
            if (self.groupInfo.is_member) {
                [self showFriendView];
            } else {
                [self showAddFriendView];
            }
            [myTable reloadData];
        }
        [myTable.header endRefreshing];
    } fail:^(NSError *error) {
        [myTable.header endRefreshing];
    }];
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = self.groupInfo.name;
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

/**
 *  显示加入群组的button
 */
- (void)showAddFriendView {
    
    return;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:
                           CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    addButton.backgroundColor = UIColorFromRGB(0x50c0bb);
    addButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [addButton setTitle:@"加入群组" forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"icon_add_friend"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"icon_add_friend"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = 99;
    [self.view addSubview:addButton];
}

- (void)showFriendView {
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, SCREEN_HEIGHT-44, SCREEN_WIDTH/2, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        switch (i) {
            case 0:
                button.backgroundColor = UIColorFromRGB(0xee6267);
                [button setTitle:@"退出群组" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_delete_friend"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_delete_friend"] forState:UIControlStateHighlighted];
                
                // 暂时隐藏掉
                // button.hidden = YES;
                
                break;
            case 1:
                button.backgroundColor = UIColorFromRGB(0x50c0bb);
                [button setImage:[UIImage imageNamed:@"icon_send_msg"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_send_msg"] forState:UIControlStateHighlighted];
    
                [button setTitle:@"发送消息" forState:UIControlStateNormal];
                
                // 暂时
                button.left = 0;
                button.width = SCREEN_WIDTH;
                
                break;
            default:
                break;
        }
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
}

// 添加按钮
- (void)addButtonAction {
    
}

// 事件
- (void)buttonAction:(UIButton *)button {
    
    if (button.tag == 100) {
        
    } else  {
        
        // 
        if ([self.groupInfo.huanxin_id length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该群没有环信ID，暂时不能聊天" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSMutableDictionary *extDict = [NSMutableDictionary dictionary];
        [extDict setObject:self.groupInfo.logo forKeyedSubscript:@"logo"];
        [extDict setObject:self.groupInfo.name forKeyedSubscript:@"nick"];
        [extDict setObject:self.groupInfo.gid forKey:@"gid"];
    
        ChatViewController *chatController = [[ChatViewController alloc]
                                              initWithChatter:self.groupInfo.huanxin_id isGroup:YES];
        chatController.userInfoDict = extDict;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark
#pragma mark table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==1) {
        return 3;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 90.0f;
    } else if (indexPath.section == 3) {
        
        CGFloat height = [StringSizeUtil
                          getContentSizeHeight:self.groupInfo.desc
                          font:[UIFont systemFontOfSize:15.0]
                          width:SCREEN_WIDTH-140];
        if (height <= 45) {
            return 45;
        }
        return height + 30;
        
    } else {
        return 45.0f;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CellIdentifier];
        
        
        if (indexPath.section == 0) {
            
            UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(11, 5, 80, 80)];
            iconImg.layer.cornerRadius = 40.0;
            iconImg.layer.masksToBounds = YES;
            [iconImg setImageWithURL:[NSURL URLWithString:self.groupInfo.logo]
                    placeholderImage:[UIImage imageNamed:@"default_head"]];
            [cell.contentView addSubview:iconImg];
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+12, 31, 150, 18)];
            titleLab.textColor = [UIColor grayColor];
            titleLab.font = [UIFont systemFontOfSize:15];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.text = self.groupInfo.name;
            [cell.contentView addSubview:titleLab];
            
        } else if (indexPath.section == 3) {
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 80, 18)];
            titleLab.textColor = [UIColor grayColor];
            titleLab.font = [UIFont systemFontOfSize:15];
            titleLab.textAlignment = NSTextAlignmentRight;
            titleLab.text = @"群简介";
            [cell.contentView addSubview:titleLab];
            
            UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.right+20, 15, SCREEN_WIDTH-titleLab.right-20-15, 18)];
            detailLab.textColor = [UIColor grayColor];
            detailLab.font = [UIFont systemFontOfSize:15];
            detailLab.textAlignment = NSTextAlignmentLeft;
            detailLab.numberOfLines = 0;
            detailLab.tag = 999;
            [cell.contentView addSubview:detailLab];
            
        } else {
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 80, 15)];
            titleLab.textColor = [UIColor grayColor];
            titleLab.font = [UIFont systemFontOfSize:15];
            titleLab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:titleLab];
            
            UILabel *detailLab = [[UILabel alloc]init];
            detailLab.textColor = [UIColor grayColor];
            detailLab.font = [UIFont systemFontOfSize:14];
            detailLab.textAlignment = NSTextAlignmentLeft;
            detailLab.tag = 999;
            [cell.contentView addSubview:detailLab];
            
            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    
                    titleLab.text = @"群组号";
                    detailLab.frame = CGRectMake(titleLab.right+20, 15, 150, 15);
                    
                } else if (indexPath.row == 1) {
                  
                    NSInteger tempCount = self.groupInfo.memberCount;//临时记录成员数量
                    
                    titleLab.text = @"群组成员";

                    detailLab.frame = CGRectMake(titleLab.right+20, 15, 150, 15);
                    detailLab.text = [NSString stringWithFormat:@"%ld人",tempCount];
                    
                } else if (indexPath.row == 2) {
                    
                    titleLab.text = @"群主";
                    
                    UIImageView *memberHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(titleLab.right+20, 9, 27, 27)];
                    memberHeadImgView.layer.cornerRadius = 13.0;
                    memberHeadImgView.layer.masksToBounds = YES;
                    [cell.contentView addSubview:memberHeadImgView];
                    
                    [memberHeadImgView setImageWithURL:[NSURL URLWithString:self.groupInfo.owner.logo]
                                      placeholderImage:[UIImage imageNamed:@"icon_group_chat"]];
                    
                    detailLab.frame = CGRectMake(titleLab.right+20+31, 15, 150, 15);
                }
            } else if (indexPath.section == 2) {
                if (indexPath.row == 0) {
                    titleLab.text = @"群组开课";
                }
            }
        }
        
    }
    
    UILabel *tempLab = (UILabel *)[cell.contentView viewWithTag:999];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            tempLab.text = self.groupInfo.gid;
        } else if (indexPath.row == 1) {
            
            
        } else if (indexPath.row == 2) {
            tempLab.text = self.groupInfo.owner.name;
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            tempLab.text = self.groupInfo.opencourse.name;
        }
    } else if (indexPath.section == 3) {
        
        tempLab.width = SCREEN_WIDTH - 140;
        tempLab.text = self.groupInfo.desc;
        [tempLab sizeToFit];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellStyleValue1;
        }
    }
    
    // Config your cell
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            ClassMemberViewController *classVc = [[ClassMemberViewController alloc] initWithNibName:@"ClassMemberViewController" bundle:nil];
            
            classVc.class_id = self.groupInfo.class_id;
            classVc.group_id = [self.groupInfo.gid intValue];
            classVc.group_type = self.groupInfo.type;
            
            [self.navigationController pushViewController:classVc animated:YES];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
