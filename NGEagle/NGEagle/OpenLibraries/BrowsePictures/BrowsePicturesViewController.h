//
//  BrowsePicturesViewController.h
//  skyeye
//
//  Created by Liang on 15/5/6.
//  Copyright (c) 2015年 Baidu inc. All rights reserved.
//

#import "BaseViewController.h"
#import "ScreenImageViewCell.h"

@interface BrowsePicturesViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, ScreenImageViewCellDelegate, UIScrollViewDelegate> {
    BOOL isFullScreen;
}

/**
 *  默认进来是哪一张
 */
@property(nonatomic, assign) int index;

/**
 *  图片数组
 */
@property(nonatomic, strong) NSMutableArray *imagesArray;

/**
 *  原图
 */
@property(nonatomic, strong) UICollectionView *collectionView;

@end
