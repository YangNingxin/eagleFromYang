//
//  CCProgressView.m
//  NGEagle
//
//  Created by Liang on 16/4/5.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCProgressView.h"

@implementation CCProgressView
{
    UIView *frontView;
    UIView *backView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backView = [UIView new];
        backView.backgroundColor = UIColorFromRGB(0xffe5b7);
        backView.layer.cornerRadius = kProgressHeigth / 2.0;
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        
        frontView = [UIView new];
        frontView.backgroundColor = UIColorFromRGB(0xffb635);
        frontView.layer.cornerRadius = kProgressHeigth / 2.0;
        frontView.layer.masksToBounds = YES;
        [self addSubview:frontView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        WS(weakSelf);
        [frontView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.height.mas_equalTo(weakSelf);
        }];
    }
    return self;
}

- (void)setProgress:(float)progress {
    
    [frontView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(progress * kProgressWidth);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
