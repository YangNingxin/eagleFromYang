//
//  CourseMessageCell.m
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CourseMessageCell.h"
#import "NSDateUtil.h"

@implementation CourseMessageCell

- (void)awakeFromNib {
    // Initialization code
    self.lineImageView1.backgroundColor = RGB(234, 234, 234);
    self.lineImageView1.height = 0.5;
    
    [self.button setTitleColor:UIColorFromRGB(0x50c0bb) forState:UIControlStateNormal];
    self.button.enabled = NO;
}

- (void)setCoureseMessage:(CourseMessage *)coureseMessage {
    _coureseMessage = coureseMessage;
    
    self.contentLabel.text = _coureseMessage.msg_content;
    [self.contentLabel sizeToFit];
    
    self.timeLabel.text = [NSDateUtil getDateWithTimeInterval:_coureseMessage.msg_time.intValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonAction:(UIButton *)sender {
    
}
@end
