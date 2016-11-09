//
//  SifterHeadView.m
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SifterHeadView.h"

@implementation SifterHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//        lineImageView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:lineImageView];
//        
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 4, 20)];
//        _imageView.backgroundColor = RGB(99, 192, 186);
//        [self addSubview:_imageView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.text = @"课程类型";
        _contentLabel.font = [UIFont systemFontOfSize:15.0];
        _contentLabel.textColor = UIColorFromRGB(0x999999);
        [self addSubview:_contentLabel];
    }
    return self;
}

@end
