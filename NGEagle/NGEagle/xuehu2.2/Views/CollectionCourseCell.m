//
//  CollectionCourseCell.m
//  NGEagle
//
//  Created by Liang on 16/4/6.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CollectionCourseCell.h"
#import "LeftImageRightLabel.h"

@implementation CollectionCourseCell
{
    UIImageView *_coverImageView;
    UIImageView *_flagImageView;
    UILabel *_timeLabel;
    UILabel *_titleLabel;
    UILabel *_descLabel;
    LeftImageRightLabel *_likeNum;
    LeftImageRightLabel *_peopleNum;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:_coverImageView];
        
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(115);
        }];
        
        _flagImageView = [UIImageView new];
        
        [self.contentView addSubview:_flagImageView];
        
        [_flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        
        _timeLabel.font = [UIFont systemFontOfSize:11.0];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [_coverImageView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_coverImageView);
            make.top.equalTo(_coverImageView.mas_bottom).offset(5);
        }];
        
        _descLabel = [[UILabel alloc] init];
        
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_descLabel];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(2);
        }];
        
        _likeNum = [LeftImageRightLabel new];
        [self.contentView addSubview:_likeNum];
        _likeNum.label.textColor = [UIColor lightGrayColor];
        _likeNum.label.font = [UIFont systemFontOfSize:11.0];
        
        
        [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_descLabel);
            make.top.equalTo(_descLabel.mas_bottom).offset(0);
        }];
        
        _peopleNum = [LeftImageRightLabel new];
        _peopleNum.label.textColor = [UIColor lightGrayColor];
        _peopleNum.label.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_peopleNum];
        

        [_peopleNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_likeNum.mas_right).offset(5);
            make.top.equalTo(_likeNum);
        }];
    }
    return self;
}

- (void)setCourse:(CCCourse *)course {
    _course = course;
    
    [_coverImageView setImageWithURL:[NSURL URLWithString:_course.face] placeholderImage:[UIImage imageNamed:@"kaoqing_cover"]];
    _flagImageView.image = [UIImage imageNamed:@"weike"];
    
//    if (_course.format_resources.count > 0) {
//        FormatResource *formatResource = _course.format_resources[0];
//        _timeLabel.text = formatResource.format_time;
//    } else {
//        _timeLabel.text = @"未知";
//    }
//    
    // 课程集
    if (course.obj_type_id == 502) {
        _flagImageView.image = [UIImage imageNamed:@"icon_zhuji2"];
        _timeLabel.text = [NSString stringWithFormat:@"%d个课时", course.element_count];
    } else {
        _flagImageView.image = [UIImage imageNamed:@"weike"];
        
        if (_course.format_resources.count > 0) {
            FormatResource *formatResource = _course.format_resources[0];
            _timeLabel.text = formatResource.format_time;
        } else {
            _timeLabel.text = @"未知";
        }
    }
    
    _titleLabel.text = _course.name;
    
    _descLabel.text = _course.desc;
    [_likeNum initWithData:_course.agree_nr image:[UIImage imageNamed:@"icon_like"]];
    [_peopleNum initWithData:_course.visitor_nr image:[UIImage imageNamed:@"icon_people"]];
}

@end
