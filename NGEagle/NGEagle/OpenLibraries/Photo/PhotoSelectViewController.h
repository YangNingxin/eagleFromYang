//
//  PhotoSelectViewController.h
//  Eagle
//
//  Created by 张伊辉 on 14-2-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoSelectViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    ALAssetsLibrary *assetLibrary;
    NSMutableDictionary *selectPhotoDict;
    NSMutableArray *selectPhotoArray;

}

@property(nonatomic,strong) NSMutableDictionary *fileDict;
@property(nonatomic,strong) NSMutableDictionary *photoDict;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)finishAction:(id)sender;

@end
