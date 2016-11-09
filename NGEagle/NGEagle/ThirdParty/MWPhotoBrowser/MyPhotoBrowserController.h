//
//  BrowsePicturesViewController.h
//  skyeye
//
//  Created by Liang on 15/5/6.
//  Copyright (c) 2015年 Baidu inc. All rights reserved.
//

#import "MWPhotoBrowser.h"

@interface MyPhotoBrowserController : MWPhotoBrowser <MWPhotoBrowserDelegate>

/**
 *  默认进来是哪一张
 */
@property(nonatomic, assign) NSUInteger index;

/**
 *  图片数组
 */
@property(nonatomic, strong) NSArray *imagesArray;



@end
