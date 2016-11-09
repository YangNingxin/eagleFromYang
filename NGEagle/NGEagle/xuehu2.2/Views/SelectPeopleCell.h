//
//  SelectPeopleCell.h
//  NGEagle
//
//  Created by Liang on 16/4/14.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface SelectPeopleCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) User *user;
@end
