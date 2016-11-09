//
//  VideoView.m
//  NGEagle
//
//  Created by Liang on 16/4/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "VideoView.h"

@implementation VideoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backVideo = [UIImageView new];
        self.backVideo.contentMode = UIViewContentModeScaleAspectFill;
        self.backVideo.clipsToBounds = YES;
        self.backVideo.image = [UIImage imageNamed:@"default_video"];
        [self addSubview:self.backVideo];
        
        WS(weakSelf);
        [self.backVideo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-8);
        }];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.textColor = [UIColor whiteColor];
//        self.timeLabel.text = @"18\"";
        self.timeLabel.hidden = YES;
        self.timeLabel.font = [UIFont systemFontOfSize:15.0];
        [self.backVideo addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.backVideo);
            make.right.mas_equalTo(-15);
        }];
        
        self.closeButton = [UIButton new];
        [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.closeButton setImage:[UIImage imageNamed:@"red_close"] forState:UIControlStateNormal];
        [self addSubview:self.closeButton];
        
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
        }];        
    }
    return self;
}

- (void)closeButtonAction {
    if (self.delegate) {
        [self.delegate deleteMediaResource:1];
    }
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
