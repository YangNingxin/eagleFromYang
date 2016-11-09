//
//  RecommendHeadView.h
//  NGEagle
//
//  Created by Liang on 16/4/6.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCourseListModel.h"

@protocol RecommendHeadViewDelegate <NSObject>

/**
 *  点击事件
 *
 *  @param course
 */
- (void)clickCourse:(CCCourse *)course;

@end

@interface RecommendHeadView : UICollectionReusableView

@property (nonatomic, strong) CCCourseListModel *listModel;
@property (nonatomic, weak) id<RecommendHeadViewDelegate>delegate;

@end
