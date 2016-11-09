//
//  OrganCell.m
//  NGEagle
//
//  Created by Liang on 15/8/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "OrganCell.h"
#import "UIImageView+AFNetworking.h"
#import "DistanceUtil.h"

@implementation OrganCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOrgan:(Organ *)organ {
    _organ = organ;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_organ.logo_url]];
    self.nameLabel.text = _organ.name;
    self.courseNumLabel.text = [NSString stringWithFormat:@"开设课程%d个", [_organ.course_count intValue]];
    self.followNumLabel.text = [NSString stringWithFormat:@"%@人关注", _organ.follow_nr];
    self.locationLabel.text = _organ.address;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", _organ.distance];
    
    if (self.isFollowList) {
        self.iconLocation1.hidden = YES;
        self.distanceLabel.hidden = YES;
        self.iconLocation2.hidden = YES;
        self.locationLabel.hidden = YES;
        
        self.nameLabel.width = SCREEN_WIDTH - 80;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
