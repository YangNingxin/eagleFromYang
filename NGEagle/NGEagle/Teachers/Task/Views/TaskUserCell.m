//
//  TaskUserCell.m
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "TaskUserCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TaskUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTaskUser:(TaskUser *)taskUser {
    _taskUser = taskUser;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:_taskUser.logo]
                       placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    self.nameLabel.text = _taskUser.nick;
    
    if (_taskUser.is_submit_task) {
        self.statusLabel.text = @"已提交";
        self.statusLabel.textColor = UIColorFromRGB(0x50c0bb);
        
    } else {
        self.statusLabel.text = @"未提交";
        self.statusLabel.textColor = [UIColor redColor];
    }
}

@end
