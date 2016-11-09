//
//  RecommendCell.h
//  NGEagle
//
//  Created by Liang on 16/4/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImageRightLabel.h"
#import "CoverImageView.h"
#import "SubscribeTagListModel.h"

@protocol RecommendCellDelegate <NSObject>
- (void)clickCourse:(CCCourse *)course;
@end

/**
 *  推荐的课程cell
 */
@interface RecommendCell : UITableViewCell
{
    LeftImageRightLabel *_titleLabel;
    UIButton *_button;
    UIScrollView *_scrollView;
}
@property (nonatomic, weak) id<RecommendCellDelegate>delegate;
@property (nonatomic, strong) SubscribeTag *subscribeTag;
@end
