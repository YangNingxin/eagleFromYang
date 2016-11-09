//
//  ImageCell.h
//  rehab
//
//  Created by Liang on 15/8/20.
//  Copyright (c) 2015年 renxin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  图片点击事件
 */
@protocol ImageCellDelegate <NSObject>

- (void)clickImageCell:(NSIndexPath *)indexPath;

@end

/**
 *  图片Cell
 */
@interface ImageCell : UICollectionViewCell

@property (nonatomic, weak) id<ImageCellDelegate>delegate;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
