//
//  TypeCell.m
//  Hug
//
//  Created by Liang on 16/1/26.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "TypeCell.h"

@implementation TypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label = [UILabel new];
        self.label.font = [UIFont systemFontOfSize:14.0];
        self.label.textColor = UIColorFromRGB(0x333333);
        [self.contentView addSubview:self.label];
        
        self.iconImageView = [UIImageView new];
        self.iconImageView.image = [UIImage imageNamed:@"selected_icon"];
        [self.contentView addSubview:self.iconImageView];
        
        UIImageView *lineImageView = [UIImageView new];
        lineImageView.backgroundColor = RGB(204, 204, 204);
        lineImageView.isAutoLayout = NO;
        [self.contentView addSubview:lineImageView];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
        }];
        
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        [self.contentView updateContentConstraints];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

@end
