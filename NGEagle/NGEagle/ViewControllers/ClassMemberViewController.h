//
//  ClassMemberViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/30.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberListModel.h"

@interface ClassMemberViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

/**
 *  判断是否可以聊天
 */
@property (nonatomic) BOOL isCanChat;

@property (nonatomic, strong) MemberListModel *memberListModel;

/**
 *  班级id
 */
@property (nonatomic) int class_id;

/**
 *  群组id
 */
@property (nonatomic) int group_id;

/**
 *  群组类型
 */
@property (nonatomic) int group_type;

@property (nonatomic, strong) NSString *huanxin_id;

/**
 *  群组姓名
 */
@property (nonatomic, strong) NSString *name;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UIButton *chatButton;
- (IBAction)chatButtonAction:(UIButton *)sender;

@end
