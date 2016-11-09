//
//  ScreenImageViewCell.h
//  skyeye
//
//  Created by Liang on 15/5/6.
//  Copyright (c) 2015年 Baidu inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomImageView.h"
#import "ImageModel.h"

@protocol ScreenImageViewCellDelegate <NSObject>

- (void)didSelectItemAtCell;

@end

@interface ScreenImageViewCell : UICollectionViewCell

@property(nonatomic, weak) id<ScreenImageViewCellDelegate>delegate;

@property(nonatomic, strong) ZoomImageView *zoomImageView;
@property(nonatomic, strong) UIImageView *defaultImageView;
@property(nonatomic, strong) ImageModel *imageModel;

@end
