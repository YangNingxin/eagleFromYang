//
//  TransactionCell.m
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "TransactionCell.h"

@implementation TransactionCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.logoImageView.backgroundColor = [UIColor redColor];
    self.tagImageView.backgroundColor = UIColorFromRGB(0x50c0bb);
    
    self.lineImageView1.backgroundColor = RGB(234, 234, 234);
    self.lineImageView1.height = 0.5;
    
    self.lineImageView2.backgroundColor = RGB(234, 234, 234);
    self.lineImageView2.height = 0.5;
    
    // Initialization code
}
// action: "2", //交易类型，0表示已付款，2表示已退款

- (void)setOrder:(Order *)order {
    _order = order;
    
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_order.goods.face]];
    if (_order.action == 0) {
        self.label.text = @"已付款";
    } else if (_order.action == 2) {
        self.label.text = @"已退款";
    }
    self.nameLabel.text = _order.goods.name;
    self.scoreLabel.text = [NSString stringWithFormat:@"学分:%d", _order.goods.credit];
    self.gradeLabel.text = [_order.goods objectStudent];

    self.timeLabel.text = _order.format_ctime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
