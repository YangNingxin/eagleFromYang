//
//  SelectSchoolViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolModel.h"

@interface SelectSchoolViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSOperation *_hotRequest;
    NSOperation *_schoolRequest;
    
    SchoolModel *_hotSchoolModel;
    SchoolModel *_schoolModel;
    
    NSString *_keyWords;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
