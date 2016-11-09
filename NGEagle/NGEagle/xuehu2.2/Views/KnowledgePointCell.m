//
//  KnowledgePointCell.m
//  NGEagle
//
//  Created by Liang on 16/4/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "KnowledgePointCell.h"

@implementation KnowledgePointCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backView = [UIImageView new];
        _backView.image = [UIImage imageNamed:@"back_cell"];
        [self.contentView addSubview:_backView];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.centerY.mas_offset(0);
        }];
        
        _iconView = [UIImageView new];
        
        [_backView addSubview:_iconView];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.centerY.mas_offset(-1.5);
        }];
        
        _titleLabel = [UILabel new];
        
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_backView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconView.mas_right).offset(10);
            make.centerY.mas_offset(0);
        }];
        
        _numberLbl = [LeftImageRightLabel new];
        _numberLbl.label.font = [UIFont systemFontOfSize:12.0];
        _numberLbl.label.textColor = kThemeColor;
        [_backView addSubview:_numberLbl];
        
        [_numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.mas_offset(0);
        }];
        
        
    }
    return self;
}

- (void)setUserTagSubscribe:(UserTagSubscribe *)userTagSubscribe {
    _userTagSubscribe = userTagSubscribe;
    if (userTagSubscribe.subscribe_flag) {
        _iconView.image = [UIImage imageNamed:@"blue_gray"];
        _numberLbl.label.textColor = kThemeColor;
        _numberLbl.imageView.image = [UIImage imageNamed:@"blue_xing"];
    } else {
        _iconView.image = [UIImage imageNamed:@"gray_fire"];
        _numberLbl.label.textColor = UIColorFromRGB(0x808080);
        _numberLbl.imageView.image = [UIImage imageNamed:@"gray_xing"];
    }
    _titleLabel.text = userTagSubscribe.name;
    _numberLbl.label.text = userTagSubscribe.weike_count;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
