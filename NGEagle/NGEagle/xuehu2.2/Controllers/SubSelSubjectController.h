//
//  SubSelSubjectController.h
//  NGEagle
//
//  Created by Liang on 16/4/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CompelteSubject)(NSMutableDictionary *dict);

/**
 *  订阅里面选择学科
 */
@interface SubSelSubjectController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
- (void)setCompelte:(CompelteSubject)block;

@end
