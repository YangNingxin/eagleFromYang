//
//  NotiTableViewCell.m
//  NGEagle
//
//  Created by ZhangXiaoZhuo on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NotiTableViewCell.h"

@implementation NotiTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.lineImageView1.backgroundColor = RGB(234, 234, 234);
    self.lineImageView1.height = 0.5;
    
    self.view.layer.cornerRadius = 5.0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headImageView.layer.cornerRadius = 20.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    
}

@end
