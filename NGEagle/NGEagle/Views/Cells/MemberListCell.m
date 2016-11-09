//
//  MemberListCell.m
//  NGEagle
//
//  Created by Liang on 15/8/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "MemberListCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MemberListCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setMember:(User *)member {
    _member = member;
    [self.headImageView setImageWithURL:[NSURL URLWithString:_member.logo]];
    self.nameLabel.text = _member.nick;
    self.schoolLabel.text = _member.schoolToString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
