//
//  ScreenImageViewCell.m
//  skyeye
//
//  Created by Liang on 15/5/6.
//  Copyright (c) 2015年 Baidu inc. All rights reserved.
//

#import "ScreenImageViewCell.h"

@implementation ScreenImageViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.zoomImageView = [[ZoomImageView alloc] initWithFrame:self.bounds];
        self.zoomImageView.imageView.userInteractionEnabled = YES;
        [self addSubview:self.zoomImageView];
        
        self.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
        self.defaultImageView.frame = self.bounds;
        self.defaultImageView.hidden = YES;
        self.defaultImageView.contentMode = UIViewContentModeCenter;
        [self.zoomImageView addSubview:self.defaultImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
        [self.zoomImageView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)clickImage:(UITapGestureRecognizer *)tap {
    [self.delegate didSelectItemAtCell];
}

- (void)setImageModel:(ImageModel *)imageModel {
    
    _imageModel = imageModel;
    
    self.zoomImageView.zoomScale = 1.0;
    self.zoomImageView.imageView.image = _imageModel.image;
    [self.zoomImageView setImageViewFrameWithImageWidth:_imageModel.width imageHeight:_imageModel.height];
}

@end
