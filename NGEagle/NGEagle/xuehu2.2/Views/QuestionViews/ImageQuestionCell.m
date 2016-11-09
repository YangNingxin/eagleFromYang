//
//  ImageQuestionCell.m
//  NGEagle
//
//  Created by Liang on 16/4/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ImageQuestionCell.h"
#import "ImageCell.h"

#define kSpaceSize 5
#define kContentWidth (SCREEN_WIDTH - 10)
#define kImageSize (kContentWidth - 2 * kSpaceSize) / 3.0

#define kContentWidth2 (SCREEN_WIDTH - 145)
#define kImageSize2 (kContentWidth2 - 2 * kSpaceSize) / 3.0

@implementation ImageQuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kImageSize, kImageSize);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        // 创建UICollectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                 collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
        [_resourceView addSubview:self.collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_resourceView);
        }];
    }
    return self;
}

- (id)initWithChatStyle:(NSString *)reuseIdentifier {
    self = [super initWithChatStyle:reuseIdentifier];
    if (self) {
        
        _type = 1;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kImageSize2, kImageSize2);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        // 创建UICollectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                 collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
        [_resourceView addSubview:self.collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(-8);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    [_collectionView reloadData];
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self getCollectionViewHeightWithImageArray:_imageArray]);
    }];
}

/**
 *  根据图片获取collection的高度
 *
 *  @return 高度
 */
- (float)getCollectionViewHeightWithImageArray:(NSArray *)array {
    
    float imageSize = 0;
    if (_type == 0) {
        imageSize = kImageSize;
    } else if (_type == 1) {
        imageSize = kImageSize2;
    }
    if (array.count == 0) {
        return 0;
    } else if (array.count <= 3) {
        
        return imageSize;
        
    } else if (array.count % 3 == 0) {
        
        return array.count/3 * imageSize + (array.count/3 - 1) * kSpaceSize;
        
    } else {
        
        return (array.count/3 + 1) * imageSize + (array.count/3) * kSpaceSize;
    }
}


#pragma mark
#pragma mark UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    NSDictionary *dict = self.imageArray[indexPath.row];
//    cell.url = dict[@"thumb"];
    cell.url = self.imageArray[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
    
}

// 不再通过didSelectItemAtIndexPath进行页面跳转，因为捕获到不到空白区域事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark
#pragma mark ImageCellDelegate

- (void)clickImageCell:(NSIndexPath *)indexPath {
    
//    NSMutableArray *originImageArray = [NSMutableArray array];
//    for (NSDictionary *dict in self.imageArray) {
//        [originImageArray addObject:dict[@"origin"]];
//    }
    [self.delegate clickAdvisoryCellImage:indexPath imagesArray:self.imageArray];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
