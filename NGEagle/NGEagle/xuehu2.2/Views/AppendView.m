//
//  AppendView.m
//  NGEagle
//
//  Created by Liang on 16/4/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AppendView.h"

@implementation AppendView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        WS(weakSelf);
        self.layer.cornerRadius = 2.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0;
        
        self.numberLabel = [UILabel new];
        self.numberLabel.text = @"30";
        self.numberLabel.font = [UIFont systemFontOfSize:8.0];
        self.numberLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.numberLabel];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"追问";
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [self addSubview:self.titleLabel];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.mas_equalTo(3);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-2);
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(_numberLabel.mas_bottom).offset(0);
        }];
        
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
