//
//  ShareView.m
//  NGEagle
//
//  Created by Liang on 16/4/10.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView
{
    ItemClick _block;
}
- (void)initContentView {
    
    NSArray *items = @[@"share_wxp", @"share_wx",
                       @"share_weibo", @"share_qq", @"share_qqzone",
                       @"share_copy", @"share_report"];
    UILabel *label = [UILabel new];
    label.text = @"分享";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.centerX.mas_offset(0);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = RGB(204, 204, 204);
    [self.contentView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.equalTo(label);
        make.height.mas_equalTo(0.5);
        make.right.equalTo(label.mas_left).offset(-5);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = RGB(204, 204, 204);
    [self.contentView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.equalTo(label);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(label.mas_right).offset(5);
    }];

    float space = (SCREEN_WIDTH - 20 - 5 * 50) / 4.0;
    
    for (int i = 0; i < 7; i++) {
        UIButton *button = [UIButton new];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:items[i]] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10 + i%5 * (50 + space));
                make.top.mas_equalTo(45 + i/5 * (68 + 10));
        }];
    }
    
    UIButton *cancelButton = [UIButton new];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 5.0;
    cancelButton.layer.borderWidth = 1.0;
    cancelButton.userInteractionEnabled = NO;
    cancelButton.layer.borderColor = RGB(204, 204, 204).CGColor;
    [cancelButton setTitleColor:UIColorFromRGB(0xd13d3d) forState:UIControlStateNormal];
    [self.contentView addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(36);
    }];
}

- (void)setClickEventBlock:(ItemClick)block {
    _block = block;
}
- (void)buttonClick:(UIButton *)button {
    [self dismiss];
    if (_block) {
        _block((int)button.tag - 10);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
