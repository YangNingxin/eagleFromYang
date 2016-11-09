//
//  RecommendCell.m
//  NGEagle
//
//  Created by Liang on 16/4/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "RecommendCell.h"
#import "CourseHelper.h"

@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
                
        UIView *topView = [UIView new];
        [self.contentView addSubview:topView];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_offset(0);
            make.height.mas_offset(40);
        }];
        
        _titleLabel = [LeftImageRightLabel new];
        _titleLabel.label.textColor = [UIColor lightGrayColor];
        [topView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.centerY.equalTo(topView);
        }];
        
        _button = [UIButton new];
        [_button setImage:[UIImage imageNamed:@"huanyihuan"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(takeHuanYiHuan) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:_button];
        
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.equalTo(topView);
        }];
        
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.top.equalTo(topView.mas_bottom).offset(0);
            make.bottom.mas_offset(0);
        }];
        [self addContent];
    }
    return self;
}

- (void)setSubscribeTag:(SubscribeTag *)subscribeTag {
    _subscribeTag = subscribeTag;
    [_titleLabel initWithData:_subscribeTag.name image:[UIImage imageNamed:@"fire"]];

    @try {
        for (int i = 0; i < 3; i++) {
            
            CCCourse *course = _subscribeTag.courses[i];
            
            CoverImageView *view = [_scrollView viewWithTag:100 + i];
            view.course = course;
            
            UIView *bottomView = [_scrollView viewWithTag:200 + i];
            
            LeftImageRightLabel *_teacher = [bottomView viewWithTag:1];
            LeftImageRightLabel *_peopleNum = [bottomView viewWithTag:2];
            LeftImageRightLabel *_likeNum = [bottomView viewWithTag:3];
            
            [_teacher initWithData:course.user.name image:[UIImage imageNamed:@"small_people"]];
            [_peopleNum initWithData:course.visitor_nr image:[UIImage imageNamed:@"icon_people"]];
            [_likeNum initWithData:course.agree_nr image:[UIImage imageNamed:@"icon_like"]];
        }
    } @catch (NSException *exception) {
        
    }
    
}

- (void)addContent {
    
    CoverImageView *lastView = nil;
    
    for (int i = 0; i < 3; i++) {
        CoverImageView *view = [CoverImageView new];
        view.tag = 100 + i;
        [_scrollView addSubview:view];
        
        UIView *bottomView = [UIView new];
        bottomView.tag = 200 + i;
        [_scrollView addSubview:bottomView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCourse:)];
        [view addGestureRecognizer:tap];
        
        if (!lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_scrollView);
                make.top.equalTo(_scrollView);
                make.width.equalTo(_scrollView);
                make.height.mas_offset(186);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right);
                make.top.equalTo(_scrollView);
                make.width.equalTo(_scrollView);
                make.height.mas_offset(186);
            }];
        }
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.width.equalTo(_scrollView);
            make.top.equalTo(view.mas_bottom);
            make.height.mas_offset(35);
        }];
        
        [self addsubViewToBottomView:bottomView];
        
        lastView = view;
    }
    
    [_scrollView setContentSize:CGSizeMake((SCREEN_WIDTH - 20) * 3, 186+35)];
    
}

- (void)clickCourse:(UITapGestureRecognizer *)tap {
    CCCourse *course = _subscribeTag.courses[tap.view.tag - 100];
    [self.delegate clickCourse:course];
}

- (void)addsubViewToBottomView:(UIView *)bottomView {
    
    LeftImageRightLabel *_teacher;
    LeftImageRightLabel *_peopleNum;
    LeftImageRightLabel *_likeNum;
    
    _teacher = [LeftImageRightLabel new];
    _teacher.tag = 1;
    [bottomView addSubview:_teacher];
    _teacher.label.textColor = [UIColor lightGrayColor];
    _teacher.label.font = [UIFont systemFontOfSize:11.0];
    
    
    [_teacher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.equalTo(bottomView);
    }];
    
    
    _peopleNum = [LeftImageRightLabel new];
    _peopleNum.tag = 2;
    _peopleNum.label.textColor = [UIColor lightGrayColor];
    _peopleNum.label.font = [UIFont systemFontOfSize:11.0];
    [bottomView addSubview:_peopleNum];
    
    
    [_peopleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.equalTo(bottomView);
    }];
    
    _likeNum = [LeftImageRightLabel new];
    _likeNum.tag = 3;
    [bottomView addSubview:_likeNum];
    _likeNum.label.textColor = [UIColor lightGrayColor];
    _likeNum.label.font = [UIFont systemFontOfSize:11.0];
    
    [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_peopleNum.mas_left).offset(-10);
        make.centerY.equalTo(bottomView);
    }];

}
/**
 *  换一换
 */
- (void)takeHuanYiHuan {
    int cur_id;
    CCCourse *course = _subscribeTag.courses.lastObject;
    if (course) {
        cur_id = course.cid;
    }
    
    WS(weakself);
    [CourseHelper changeSubscribeTagCourses:2 target_id:[_subscribeTag.sid intValue] cur_id:cur_id success:^(id responseObject) {
        CCCourseListModel *model = responseObject;
        if (model.error_code == 0) {
            _subscribeTag.courses = model.data;
            [weakself setSubscribeTag:_subscribeTag];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
