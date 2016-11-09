//
//  KaoqingCell.h
//  NGEagle
//
//  Created by Liang on 15/9/6.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistarUserListModel.h"

@interface KaoqingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *resultButton;

- (IBAction)handleAction:(UIButton *)sender;

@property (nonatomic, strong) User *user;

@end
