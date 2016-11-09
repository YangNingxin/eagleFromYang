//
//  SifterCell.m
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SifterCell.h"

@implementation SifterCell

- (void)awakeFromNib {

    self.contentView.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;

    self.contentView.layer.borderWidth = 0.5;
    self.contentLabel.adjustsFontSizeToFitWidth = YES;

    self.contentLabel.textColor = UIColorFromRGB(0x333333);
    // Initialization code
}

@end
