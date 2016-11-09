//
//  NearCourseCell.m
//  NGEagle
//
//  Created by Liang on 15/8/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NearCourseCell.h"
#import "UIImageView+AFNetworking.h"


@implementation NearCourseCell

- (void)awakeFromNib {
    // Initialization code
    self.lineImageView.backgroundColor = RGB(220, 220, 220);
    self.scoreLabel.textColor = [UIColor orangeColor];
    self.priceLabel.textColor = [UIColor redColor];
}

- (void)setCourse:(Course *)course {
    
    _course = course;
    
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_course.face]];
    self.nameLabel.text = _course.name;
    
    if ([_course.price floatValue] == 0) {
        self.priceLabel.text = @"免费";
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", _course.price];
    }
    
    self.hourLabel.text = [NSString stringWithFormat:@"%@课时", _course.openlesson_nr];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", _course.distance];
    self.stateLabel.text = [NSString stringWithFormat:@"已开设班次%d个，可预约%d个", _course.openclass_count, _course.openclass_appointment_count];
    self.locationLabel.text = _course.address;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分", _course.score];
    self.descLabel.text = [NSString stringWithFormat:@"%d人评价，%d人赞过", [_course.comment_count intValue], [_course.agree_nr intValue]]; //[25人评价，105人赞过];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
