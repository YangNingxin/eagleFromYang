//
//  SubjectCell.m
//  NGEagle
//
//  Created by Liang on 16/4/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SubjectCell.h"

@implementation SubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _label = [UILabel new];
        _label.text = @"数学";
        _label.textColor = UIColorFromRGB(0x888888);
        _label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_label];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.left.mas_offset(10);
        }];
        
        _rightView = [LeftLabelRightImage new];
        _rightView.label.textColor = kThemeColor;
        _rightView.label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_rightView];
        [_rightView initWithData:@"23" image:[UIImage imageNamed:@"check"]];
        [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.mas_offset(0);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
