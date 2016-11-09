//
//  ImageQuestionCell.h
//  NGEagle
//
//  Created by Liang on 16/4/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseQuestionCell.h"
#import "ImageCell.h"

@protocol ImageQuestionCellDelegate <NSObject>

/**
 *  点击图片
 */
@required
- (void)clickAdvisoryCellImage:(NSIndexPath *)indexPath imagesArray:(NSArray *)imagesArray;

@end


@interface ImageQuestionCell : BaseQuestionCell <UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, ImageCellDelegate>
{
    int _type;
}

@property (nonatomic, weak) id<ImageQuestionCellDelegate>delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *imageArray;

@end
