//
//  CoverImageView.m
//  NGEagle
//
//  Created by Liang on 16/4/7.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CoverImageView.h"

@implementation CoverImageView
{
    UIImageView *_coverImageView;
    UIImageView *_flagImageView;
    UIView *_bottomView;
    UILabel *_titleLabel;
    UILabel *_timeLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        [self addSubview:_coverImageView];
        
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        _flagImageView = [UIImageView new];
        [self addSubview:_flagImageView];
        
        [_flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
        }];
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.equalTo(_bottomView);
        }];
        
        _timeLabel = [UILabel new];
        
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.centerY.equalTo(_bottomView);
        }];
    }
    return self;
}

- (void)setCourse:(CCCourse *)course {
    _course = course;
    [_coverImageView setImageWithURL:[NSURL URLWithString:_course.face] placeholderImage:[UIImage imageNamed:@"kaoqing_cover"]];
    _flagImageView.image = [UIImage imageNamed:@"weike"];

    _titleLabel.text = _course.name;
    
    
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
    
//    if (_course.format_resources.count > 0) {
//        FormatResource *formatResource = _course.format_resources[0];
//        _timeLabel.text = formatResource.format_time;
//    } else {
//        _timeLabel.text = @"未知";
//    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
