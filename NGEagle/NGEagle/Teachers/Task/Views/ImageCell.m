//
//  ImageCell.m
//  rehab
//
//  Created by Liang on 15/8/20.
//  Copyright (c) 2015年 renxin. All rights reserved.
//

#import "ImageCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        // 给图片添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction)];
        [self.imageView addGestureRecognizer:tap];
    }
    return self;
}

/**
 *  图片点击事件
 */
- (void)tapImageAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickImageCell:)]) {
        [self.delegate clickImageCell:self.indexPath];
    }
}

/**
 *  设置url
 *
 *  @param url 
 */
- (void)setUrl:(NSString *)url {
    _url = url;
    [self.imageView setImageWithURL:[NSURL URLWithString:_url]];
}

@end
