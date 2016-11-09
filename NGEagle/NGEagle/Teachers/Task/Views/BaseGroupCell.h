//
//  AdvisoryView.h
//  rehab
//
//  Created by Liang on 15/8/20.
//  Copyright (c) 2015年 renxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceModel.h"
#import "ImageCell.h"
#import "ImageGroupCellDelegate.h"

#define kSpaceSize 5
#define kContentWidth (SCREEN_WIDTH - 60)
#define kImageSize (kContentWidth - 2 * kSpaceSize) / 3.0

#define kOneImageWidth 200
#define kOneImageHeight 150

@interface BaseGroupCell : UITableViewCell
    <UICollectionViewDelegate, UICollectionViewDataSource,
ImageCellDelegate, UICollectionViewDelegateFlowLayout>
{
    
}

/**
 *  图片代理事件
 */
@property (nonatomic, weak) id<ImageGroupCellDelegate>delegate;

/**
 *  上一层级控制器
 */
@property (nonatomic, weak) UIViewController *viewController;

/**
 *  IndexPath
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 *  名字
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  学校
 */
@property (nonatomic, strong) UILabel *schoolLabel;

/**
 *  分割线
 */
@property (nonatomic, strong) UIImageView *lineImageView;

/**
 *  内容
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 *  时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 *  图片collectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray *imageArray;

/**
 *  根据数据得到资源的高度
 *
 *  @param array 附件数组
 *
 *  @return 高度
 */
- (float)getCollectionViewHeightWithImageArray:(NSArray *)array;

/**
 *  点击CollectionView 空白区域
 */
- (void)tapCollectionViewAction;

@end
