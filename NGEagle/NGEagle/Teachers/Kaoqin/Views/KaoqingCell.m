//
//  KaoqingCell.m
//  NGEagle
//
//  Created by Liang on 15/9/6.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "KaoqingCell.h"

@implementation KaoqingCell

- (void)awakeFromNib {
    
    self.resultButton.layer.cornerRadius = 20.0;//矩形按钮的圆角设计
    self.resultButton.layer.masksToBounds = YES;//设置为yes，就可以使用圆角
    
    // Initialization code
    for (int i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        button.frame = CGRectMake(SCREEN_WIDTH-150+i*50, 0, 50, 50);
        button.tag = 100 + i;
        button.hidden = YES;
        switch (i) {
            case 0:
                button.backgroundColor = UIColorFromRGB(0xffb200);
                [button setTitle:@"迟到" forState:UIControlStateNormal];//forState: 这个参数的作用是定义按钮的文字或图片在何种状态下才会显现 而UIControlStateNormal是常规显示的意思
                break;
            case 1:
                button.backgroundColor = UIColorFromRGB(0xee6267);
                [button setTitle:@"缺勤" forState:UIControlStateNormal];
                break;
            case 2:
                button.backgroundColor = UIColorFromRGB(0x50c0bb);
                [button setTitle:@"已到" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];//UIControlEventTouchUpInSide点击触发
        [self.contentView addSubview:button];
    }
    
}

- (void)setUser:(User *)user {
    
    _user = user;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:_user.logo]
                       placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.nameLabel.text = _user.nick;
    [self handleMoreButtonsHidden:YES];
    
    [self updateUI];
}

- (void)updateUI {
    
    switch (_user.sign_status) {
        case 0:
            self.resultButton.backgroundColor = UIColorFromRGB(0x50c0bb);
            [self.resultButton setTitle:@"到" forState:UIControlStateNormal];
            break;
        case 1:
            self.resultButton.backgroundColor = UIColorFromRGB(0xffb200);
            [self.resultButton setTitle:@"迟" forState:UIControlStateNormal];
            
            break;
        case 2:
            self.resultButton.backgroundColor = UIColorFromRGB(0xee6267);
            [self.resultButton setTitle:@"退" forState:UIControlStateNormal];
            
            break;
        case 4:
            self.resultButton.backgroundColor = UIColorFromRGB(0xee6267);
            [self.resultButton setTitle:@"缺" forState:UIControlStateNormal];
            
            break;
        default:
            break;
    }
}

- (void)buttonAction:(UIButton *)button {
    switch (button.tag) {
        case 100:
            _user.sign_status = 1;
            break;
        case 101:
            _user.sign_status = 4;
            break;
        case 102:
            _user.sign_status = 0;
            break;
        default:
            break;
    }
    [self handleMoreButtonsHidden:YES];
    [self updateUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)handleMoreButtonsHidden:(BOOL)isHidden {
    for (int i = 0; i < 3; i++) {
        UIButton *button = (UIButton *)[self.contentView viewWithTag:100+i];
        button.hidden = isHidden;
    }
}

- (IBAction)handleAction:(UIButton *)sender {
    [self handleMoreButtonsHidden:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleMoreButtonsHidden:YES];
}

@end
