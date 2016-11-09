//
//  AddressBookTableViewCell.m
//  NGEagle
//
//  Created by zhaoxiaolu on 16/5/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AddressBookTableViewCell.h"

@implementation AddressBookTableViewCell {
    UIImageView *_photoView;
    UILabel *_nameLabel;
    UILabel *_detailLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    _photoView = [[UIImageView alloc] init];
    _photoView.contentMode = UIViewContentModeScaleAspectFill;
    _photoView.clipsToBounds = YES;
    _photoView.layer.cornerRadius = 20.f;
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:16.f];
    _nameLabel.textColor = UIColorFromRGB(0x333333);
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:13.f];
    _detailLabel.textColor = UIColorFromRGB(0x888888);
    
    [self.contentView addSubview:_photoView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_detailLabel];
    
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_photoView.mas_right).offset(10);
        make.top.mas_equalTo(13);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(7);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xf0f3f5);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-0.5);
        make.left.mas_equalTo(_photoView.mas_right);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)initWithData:(User *)user {
    _nameLabel.text = user.nick;
    [_photoView setImageWithURL:[NSURL URLWithString:user.logo] placeholderImage:[UIImage imageNamed:@"default_head"]];
}

@end
