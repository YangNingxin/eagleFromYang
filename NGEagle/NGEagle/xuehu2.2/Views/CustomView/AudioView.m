//
//  AudioView.m
//  NGEagle
//
//  Created by Liang on 16/4/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AudioView.h"
#import "EGPlayAudio.h"
#import "FCFileManager.h"

@implementation AudioView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backAudio = [UIImageView new];
        self.backAudio.image = [[UIImage imageNamed:@"back_voice"] stretchableImageWithLeftCapWidth:35 topCapHeight:0];
        [self addSubview:self.backAudio];
        WS(weakSelf);
        [self.backAudio mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-8);
        }];
        
        self.animationView = [UIImageView new];
        self.animationView.image = [UIImage imageNamed:@"chat_oth_audio3"];
        [self.backAudio addSubview:self.animationView];
        
        [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(weakSelf.backAudio);
        }];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.textColor = [UIColor whiteColor];
//        self.timeLabel.text = @"18\"";
        self.timeLabel.font = [UIFont systemFontOfSize:15.0];
        [self.backAudio addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.backAudio);
            make.right.mas_equalTo(-15);
        }];
        
        self.closeButton = [UIButton new];
        [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.closeButton setImage:[UIImage imageNamed:@"red_close"] forState:UIControlStateNormal];
        [self addSubview:self.closeButton];
        
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
        }];
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.loadingView stopAnimating];
        [self addSubview:self.loadingView];
        
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_offset(0);
        }];
        
        [self addAnimationView];
    }
    return self;
}

- (void)addAnimationView {
    
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"chat_oth_audio1"], [UIImage imageNamed:@"chat_oth_audio2"], [UIImage imageNamed:@"chat_oth_audio3"], nil];
    self.animationView.animationImages = images;
    self.animationView.animationDuration = 0.5;
}

/**
 *  控制语音的播放
 *
 *  @param status 0正常，1加载中，2正在播放
 */
- (void)handleView:(int)status {
    if (status == 2) {
        [self.loadingView stopAnimating];
        [self.animationView startAnimating];
    } else {
        [self.animationView stopAnimating];
        if (status == 1) {
            [self.loadingView startAnimating];
        } else {
            [self.loadingView stopAnimating];
        }
    }
}

- (void)closeButtonAction {
    
    if (self.delegate) {
        [self.delegate deleteMediaResource:2];
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
