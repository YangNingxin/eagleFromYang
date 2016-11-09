//
//  AdvisoryView.m
//  rehab
//
//  Created by Liang on 15/8/20.
//  Copyright (c) 2015年 renxin. All rights reserved.
//

#import "BaseGroupCell.h"
#import "UIView+Util.h"
#import "MyPhotoBrowserController.h"
#import "PlayViewController.h"

@implementation BaseGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        [self addSubview:self.headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 15.0)];
        self.nameLabel.font = [UIFont systemFontOfSize:15.0];
        self.nameLabel.text = @"学乎用户";
        [self addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 5, 100, 15.0)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:13.0];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.timeLabel];
        
        self.schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 150, 15.0)];
        self.schoolLabel.backgroundColor = [UIColor clearColor];
        self.schoolLabel.font = [UIFont systemFontOfSize:13.0];
        self.schoolLabel.textColor = [UIColor lightGrayColor];
        self.schoolLabel.text = @"北京学校";
        [self addSubview:self.schoolLabel];
        
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50.0, SCREEN_WIDTH-50, 0.5)];
        self.lineImageView.backgroundColor = RGB(220, 220, 220);
        [self addSubview:self.lineImageView];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 60, kContentWidth, 30)];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:14.0];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = UIColorFromRGB(0x545454);
        [self addSubview:self.contentLabel];
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kImageSize, kImageSize);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        // 创建UICollectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(50, 0, kContentWidth, 100)
                                                 collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.collectionView];
        
        // 给UICollectionView添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCollectionViewAction)];
        [self.collectionView addGestureRecognizer:tap];
    }
    return self;
}

/**
 *  根据图片获取collection的高度
 *
 *  @return 高度
 */
- (float)getCollectionViewHeightWithImageArray:(NSArray *)array {
    
    if (array.count == 1) {
        return kOneImageHeight;
    }
    if (array.count == 0) {
        return 0;
    } else if (array.count <= 3) {
        
        return kImageSize;
        
    } else if (array.count % 3 == 0) {
        
        return array.count/3 * kImageSize + (array.count/3 - 1) * kSpaceSize;
        
    } else {
        
        return (array.count/3 + 1) * kImageSize + (array.count/3) * kSpaceSize;
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
    Resource *resouce = self.imageArray[indexPath.row];
    if (resouce.type == 1) {
        cell.url = resouce.url;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"default_video"];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;

    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.imageArray.count == 1) {
        return CGSizeMake(kOneImageWidth, kOneImageHeight);
    }
    return CGSizeMake(kImageSize, kImageSize);
}

#pragma mark
#pragma mark ImageCellDelegate

- (void)clickImageCell:(NSIndexPath *)indexPath {
    if (self.viewController && self.imageArray.count > 0) {
        Resource *resouce = self.imageArray[0];
        int type = resouce.type;
        
        if (type == 1) { // 图片
            
            NSMutableArray *originImageArray = [NSMutableArray array];
            for (Resource *resource in self.imageArray) {
                [originImageArray addObject:resource.url];
            }
            
            MyPhotoBrowserController *photoBrowser = [[MyPhotoBrowserController alloc] init];
            photoBrowser.imagesArray = originImageArray;
            photoBrowser.index = indexPath.row;
            [self.viewController.navigationController pushViewController:photoBrowser animated:YES];
            
        } else if (type == 2) {  // 视频
            
            Resource *resouce = self.imageArray[0];
          
            PlayViewController *playVc = [[PlayViewController alloc] init];
            playVc.url = resouce.url;
            UINavigationController *tempNav = [[UINavigationController alloc] initWithRootViewController:playVc];
            [self.viewController presentViewController:tempNav animated:YES completion:nil];
            
        } else if (type == 3) {  // 音频
            
        }
    }
}

/**
 *  点击collectionView
 */
- (void)tapCollectionViewAction {
    // 跳转详情页面
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
