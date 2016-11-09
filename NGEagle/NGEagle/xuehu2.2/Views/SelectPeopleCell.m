//
//  SelectPeopleCell.m
//  NGEagle
//
//  Created by Liang on 16/4/14.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SelectPeopleCell.h"

@implementation SelectPeopleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [UIImageView new];
        self.headImageView.layer.cornerRadius = 25.0;
        self.headImageView.layer.masksToBounds = YES;

        [self.contentView addSubview:self.headImageView];
        
        WS(weaskself);
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.centerY.equalTo(weaskself);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        self.nameLabel = [UILabel new];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_right).offset(10);
            make.top.equalTo(_headImageView.mas_top).offset(5);
        }];
        
        self.schoolLabel = [UILabel new];
        self.schoolLabel.textColor = UIColorFromRGB(0x888888);
        self.schoolLabel.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:self.schoolLabel];
        
        [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_right).offset(10);
            make.bottom.equalTo(_headImageView.mas_bottom).offset(-5);
        }];
        
        UIImageView *lineImageView = [UIImageView new];
        lineImageView.backgroundColor = RGB(204, 204, 204);
        [self.contentView addSubview:lineImageView];
        
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.selectButton = [UIButton new];
        self.selectButton.userInteractionEnabled = NO;
        [self.selectButton setImage:[UIImage imageNamed:@"un_sel_people"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"sel_people"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectButton];
        
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(weaskself);
        }];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    _nameLabel.text = _user.name;
    _schoolLabel.text = _user.schoolToString;
    [_headImageView setImageWithURL:[NSURL URLWithString:_user.logo] placeholderImage:[UIImage imageNamed:@"default_head"]];
}

@end
