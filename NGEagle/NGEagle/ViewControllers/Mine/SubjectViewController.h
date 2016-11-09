//
//  SubjectViewController.h
//  NGEagle
//
//  Created by Liang on 15/9/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "IntSubjectModel.h"
typedef void(^CompletionBlock)(NSString *subjectIds, NSString *subjectNames);
@interface SubjectViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CompletionBlock _block;
}

/**
 *  学科
 */
@property (nonatomic, strong) IntSubjectModel *subjectModel;
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)setCompletion:(CompletionBlock)block;

@end
