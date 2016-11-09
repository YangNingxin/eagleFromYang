//
//  ToolMenuView.m
//  NGEagle
//
//  Created by Liang on 16/4/24.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ToolMenuView.h"

@implementation ToolMenuView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"back+"];
        [self addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(0);
        }];
        
        _wordImageView = [UIImageView new];
        _wordImageView.image = [UIImage imageNamed:@"word"];
        [self addSubview:_wordImageView];
        
        [_wordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.top.mas_offset(100);
        }];
        
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton new];
            button.tag = 20 + i;
            [button addTarget:self action:@selector(clickType:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_offset(0);
            }];
            
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:14.0];
            label.textColor = UIColorFromRGB(0x333333);
            [self addSubview:label];
            
            
            switch (i) {
                case 0:
                {
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.mas_equalTo(-SCREEN_WIDTH / 3.0);
                    }];
                    [button setImage:[UIImage imageNamed:@"paiyipai"] forState:UIControlStateNormal];
                    label.text = @"拍一拍";
                }
                    break;
                case 1:
                {
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.mas_equalTo(0);
                    }];
                    [button setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
                    label.text = @"扫一扫";
                }
                    break;
                case 2:
                {
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.mas_equalTo(SCREEN_WIDTH / 3.0);
                    }];
                    [button setImage:[UIImage imageNamed:@"qutiwen"] forState:UIControlStateNormal];
                    label.text = @"去提问";
                }
                    break;
                default:
                    break;
            }
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button);
                make.top.equalTo(button.mas_bottom).offset(5);
            }];
        }
        
        UIButton *closeButton = [UIButton new];
        [closeButton setImage:[UIImage imageNamed:@"dark_close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.bottom.mas_offset(-10);
        }];
    }
    return self;
}

- (void)clickType:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMenu:)]) {
        [self.delegate clickMenu:(int)button.tag - 20];
    }
}

- (void)closeButtonAction {
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
