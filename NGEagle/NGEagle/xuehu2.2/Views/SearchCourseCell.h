//
//  SearchCourseCell.h
//  NGEagle
//
//  Created by Liang on 16/4/19.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImageRightLabel.h"

@interface SearchCourseCell : UITableViewCell
{
    UIImageView *_coverImageView;
    UIImageView *_flagImageView;
    UILabel *_timeLabel;
    UILabel *_titleLabel;
    UILabel *_descLabel;
    LeftImageRightLabel *_likeNum;
    LeftImageRightLabel *_peopleNum;
}
@end
