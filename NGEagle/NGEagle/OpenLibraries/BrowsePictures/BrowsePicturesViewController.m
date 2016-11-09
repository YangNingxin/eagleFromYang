//
//  BrowsePicturesViewController.m
//  skyeye
//
//  Created by Liang on 15/5/6.
//  Copyright (c) 2015年 Baidu inc. All rights reserved.
//

#import "BrowsePicturesViewController.h"


static NSString *const ID = @"ScreenImageViewCell";

@interface BrowsePicturesViewController ()

@end

@implementation BrowsePicturesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    // 创建UICollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[ScreenImageViewCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:self.collectionView];
    [self.view sendSubviewToBack:self.collectionView];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
   
    _titleLabel.text = [NSString stringWithFormat:@"(%d/%ld)", self.index + 1, self.imagesArray.count];
}

- (void)rightButtonAction {
    if (self.imagesArray.count > 0) {
        [self.imagesArray removeObjectAtIndex:self.index];
        [self.collectionView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteResourceAction" object:@(self.index)];
        
        if (self.imagesArray.count == 0) {
            _titleLabel.text = @"(0/0)";
        } else {
            _titleLabel.text = [NSString stringWithFormat:@"(%d/%ld)", self.index + 1, self.imagesArray.count];
        }
    }
}

- (void)configBaseUI {
    [super configBaseUI];
    
    [_rightButotn setTitle:@"删除" forState:UIControlStateNormal];
}

#pragma mark
#pragma mark UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ScreenImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.imageModel = self.imagesArray[indexPath.row];
    cell.delegate = self;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

//    int currentPage = collectionView.contentOffset.x / SCREEN_WIDTH;
//    self.index = currentPage;
//    NSLog(@"currentPage is %d", currentPage);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.index = currentPage;
    _titleLabel.text = [NSString stringWithFormat:@"(%d/%ld)", currentPage + 1, self.imagesArray.count];
    NSLog(@"currentPage is %d", currentPage);
}


#pragma mark ScreenImageViewCellDelegate

/**
 *  点击屏幕图片的事件
 */
- (void)didSelectItemAtCell {
    if (!isFullScreen) {
        [UIView animateWithDuration:0.25 animations:^{
            _barImageView.top = -64;
        }];
        
    } else {
        
        [UIView animateWithDuration:0.25 animations:^{
            _barImageView.top = 0;
        }];
    }
    isFullScreen = !isFullScreen;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
