//
//  MarkCourseCell.m
//  NGEagle
//
//  Created by Liang on 16/5/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "MarkCourseCell.h"

@implementation MarkCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WS(weakSelf);
        
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 下划线
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(204, 204, 204);
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.height.mas_offset(0.5);
            make.bottom.mas_equalTo(0);
        }];
        
        _whiteView = [UIView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_whiteView];
        
        [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_offset(0);
            make.top.mas_offset(5);
            make.bottom.mas_offset(-5);
        }];
        
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.image = [UIImage imageNamed:@"kaoqing_cover"];
        [_whiteView addSubview:_coverImageView];
        
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.size.mas_offset(CGSizeMake(132, 80));
            make.centerY.equalTo(_whiteView);
        }];
        
        _flagImageView = [UIImageView new];
        _flagImageView.image = [UIImage imageNamed:@"weike"];
        [_coverImageView addSubview:_flagImageView];
        
        [_flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @" 22分30秒 ";
        _timeLabel.font = [UIFont systemFontOfSize:11.0];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [_coverImageView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"来一场数学的奇妙之旅吧";
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_whiteView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_coverImageView.mas_right).offset(10);
            make.right.mas_offset(-5);
            make.top.equalTo(_coverImageView.mas_top).offset(10);
        }];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"初中语文 一年级 测试";
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.font = [UIFont systemFontOfSize:11.0];
        [_whiteView addSubview:_descLabel];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        }];
        
        _likeNum = [LeftImageRightLabel new];
        [_whiteView addSubview:_likeNum];
        _likeNum.label.textColor = [UIColor lightGrayColor];
        _likeNum.label.font = [UIFont systemFontOfSize:11.0];
        [_likeNum initWithData:@"4000" image:[UIImage imageNamed:@"icon_like"]];
        
        [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_descLabel);
            make.top.equalTo(_descLabel.mas_bottom).offset(10);
        }];
        
        _peopleNum = [LeftImageRightLabel new];
        _peopleNum.label.textColor = [UIColor lightGrayColor];
        _peopleNum.label.font = [UIFont systemFontOfSize:11.0];
        [_whiteView addSubview:_peopleNum];
        [_peopleNum initWithData:@"2520" image:[UIImage imageNamed:@"icon_people"]];
        
        [_peopleNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_likeNum.mas_right).offset(10);
            make.top.equalTo(_likeNum);
        }];
    }
    return self;
}

- (void)setCourse:(CCCourse *)course {
    _course = course;
    
    [_coverImageView setImageWithURL:[NSURL URLWithString:_course.face] placeholderImage:[UIImage imageNamed:@"kaoqing_cover"]];
    
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
