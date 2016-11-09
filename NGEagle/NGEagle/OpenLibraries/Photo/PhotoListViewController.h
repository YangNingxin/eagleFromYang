//
//  PhotoListViewController.h
//  Eagle
//
//  Created by 张伊辉 on 14-2-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoListViewController : UITableViewController
{
    ALAssetsLibrary *assetLibrary;
    NSMutableArray *muArrPhotoes;
}

@property(nonatomic,strong) NSMutableDictionary *fileDict;

@end
