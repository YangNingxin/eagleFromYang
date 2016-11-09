//
//  RecordCourseCell.h
//  NGEagle
//
//  Created by Liang on 16/4/20.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImageRightLabel.h"
#import "CCCourseListModel.h"

@interface RecordCourseCell : UITableViewCell
{
    UIView *_lineView;
    UIView *_whiteView;
    
    UIImageView *_coverImageView;
    UIImageView *_flagImageView;
    UILabel *_timeLabel;
    UILabel *_titleLabel;
    UILabel *_descLabel;
    LeftImageRightLabel *_likeNum;
    LeftImageRightLabel *_peopleNum;
}
@property (nonatomic, strong) CCCourse *course;
@end
