//
//  TaskStatusViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "TaskStatueModel.h"

@interface TaskStatusViewController : BaseViewController
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic) int taskId;
@property (nonatomic) int openclassId;

@end
