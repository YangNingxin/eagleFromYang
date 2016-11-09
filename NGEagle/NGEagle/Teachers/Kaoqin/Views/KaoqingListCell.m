//
//  KaoqingListCell.m
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "KaoqingListCell.h"
#import "UIImageView+AFNetworking.h"

@implementation KaoqingListCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.view.layer.cornerRadius = 5.0;
    self.view.layer.masksToBounds = YES;
    self.view.clipsToBounds = YES;
    // Initialization code
    
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    self.totalLabel.textColor = UIColorFromRGB(0x888888);
    self.arriveLabel.textColor = UIColorFromRGB(0x01af8c);
    self.lateLabel.textColor = UIColorFromRGB(0xd39a00);
    self.unarriveLabel.textColor = UIColorFromRGB(0xf50000);
}

- (void)setRegistrationList:(RegistrationList *)registrationList {
    
    _registrationList = registrationList;
    self.nameLabel.text = _registrationList.name;
    NSLog(@"face is %@", _registrationList.face);
    
    [self.cover setImageWithURL:[NSURL URLWithString:_registrationList.face] placeholderImage:[UIImage imageNamed:@"kaoqing_cover"]];
    
    int arrive_nr = _registrationList.total_nr - _registrationList.later_nr - _registrationList.disappear_nr;
    
    self.totalLabel.text = [NSString stringWithFormat:@"共%d人", _registrationList.total_nr];
    self.arriveLabel.text = [NSString stringWithFormat:@"到%d人", arrive_nr];
    self.lateLabel.text = [NSString stringWithFormat:@"迟到%d人", _registrationList.later_nr];
    self.unarriveLabel.text = [NSString stringWithFormat:@"未到%d人", _registrationList.disappear_nr];
    
    self.timeLabel.text = _registrationList.sign_time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
