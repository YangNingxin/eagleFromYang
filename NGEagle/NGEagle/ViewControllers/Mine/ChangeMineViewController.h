//
//  ChangeMineViewController.h
//  NGEagle
//
//  Created by ZhangXiaoZhuo on 15/8/13.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"
#import "DateView.h"

@interface ChangeMineViewController : BaseViewController
<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DateViewDelegate> {

    UITableView *myTable;
    User *tempUser;
    DateView *dateView;
}

@end
