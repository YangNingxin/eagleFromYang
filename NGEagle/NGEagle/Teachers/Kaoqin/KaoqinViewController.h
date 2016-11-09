//
//  KaoqinViewController.h
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupInfoModel.h"
#import "DateView.h"
#import "RegistrationListModel.h"

/**
 *  创建考勤，考勤详情公用类
 */
@interface KaoqinViewController : BaseViewController
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DateViewDelegate, UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    DateView *dateView;
    BOOL isSetCover;
}

/**
 *  群组信息
 */
@property (nonatomic, strong) GroupInfo *groupInfo;

/**
 *  考勤数据
 */
@property (nonatomic, strong) RegistrationList *listModel;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *coverImageView;

- (IBAction)tapCoverImageViewAction:(UITapGestureRecognizer *)sender;

@end
