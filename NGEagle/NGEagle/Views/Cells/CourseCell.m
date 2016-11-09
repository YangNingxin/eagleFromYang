//
//  CourseCell.m
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CourseCell.h"
#import "UIImageView+AFNetworking.h"


@implementation CourseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCourse:(Course *)course {
    _course = course;
    self.titleLabel.text = course.name;
    [self.zanButton setTitle:[NSString stringWithFormat:@"赞(%@)",
                              course.agree_nr]
                    forState:UIControlStateNormal];
    
    self.openClassLabel.text = [NSString stringWithFormat:@"开班%d个，可预约%d个",
                                course.openclass_count, course.openclass_appointment_count];
    self.objectLabel.text = @"";
    self.scoreLabel.text = [NSString stringWithFormat:@"学分:%@", course.credit];
    self.locationLabel.text = course.address;
    [self.cover setImageWithURL:[NSURL URLWithString:course.face]];
    self.objectLabel.text = course.objectStudent;
    if (_course.is_appointment) {
        [self.yuyueButton setTitle:@"可预约" forState:UIControlStateNormal];
    } else {
        [self.yuyueButton setTitle:@"不可预约" forState:UIControlStateNormal];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
