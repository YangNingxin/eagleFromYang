//
//  SifterCourseView.h
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseFilterModel.h"

@protocol SifterCourseViewDelegate <NSObject>

- (void)didSelectItemAtIndexPathWithParams:(NSMutableDictionary *)params;

@end

@interface SifterCourseView : UIView <UICollectionViewDelegate, UICollectionViewDataSource> {
    
    NSOperation *_courseRequest;
}

@property (nonatomic, weak) id<SifterCourseViewDelegate>delegate;

@property (nonatomic, strong) CourseFilterModel *courseFilterModel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic) int type;
@end
