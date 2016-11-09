//
//  RecommendHeadView.m
//  NGEagle
//
//  Created by Liang on 16/4/6.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "RecommendHeadView.h"
#import "LeftImageRightLabel.h"
#import "CoverImageView.h"

@implementation RecommendHeadView
{
    LeftImageRightLabel *_titleLabel1;
    LeftImageRightLabel *_titleLabel2;
    UIScrollView *_scrollView;
    UIView *_lineView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel1 = [LeftImageRightLabel new];
        [self addSubview:_titleLabel1];
        _titleLabel1.label.textColor = UIColorFromRGB(0x666666);
        _titleLabel1.label.font = [UIFont systemFontOfSize:15.0];
        [_titleLabel1 initWithData:@"热课程推荐" image:[UIImage imageNamed:@"hot_course"]];
        
        [_titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
        
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(_titleLabel1.mas_bottom).offset(10);
            make.height.mas_equalTo(166);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(204, 204, 204);
        [self addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_scrollView);
            make.top.equalTo(_scrollView.mas_bottom).offset(10);
            make.height.mas_equalTo(0.5);
        }];
        
        _titleLabel2 = [LeftImageRightLabel new];
        [self addSubview:_titleLabel2];
        _titleLabel2.label.textColor = UIColorFromRGB(0x666666);
        _titleLabel2.label.font = [UIFont systemFontOfSize:15.0];
        [_titleLabel2 initWithData:@"最新课程" image:[UIImage imageNamed:@"new_course"]];
        
        [_titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lineView);
            make.top.equalTo(_lineView.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (void)setListModel:(CCCourseListModel *)listModel {
    _listModel = listModel;
    
    for (UIView *v in _scrollView.subviews) {
        [v removeFromSuperview];
    }
    [self addContent];
}

- (void)addContent {
    
    CoverImageView *lastView = nil;

    for (int i = 0; i < _listModel.data.count; i++) {
        
        CoverImageView *view = [CoverImageView new];
        view.tag = 100 + i;
        [_scrollView addSubview:view];
        
        view.course = _listModel.data[i];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [view addGestureRecognizer:tapGesture];
        
        if (!lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_scrollView);
                make.top.equalTo(_scrollView);
                make.size.equalTo(_scrollView);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right);
                make.top.equalTo(_scrollView);
                make.size.equalTo(_scrollView);
            }];
        }
        lastView = view;
    }
    
    [_scrollView setContentSize:CGSizeMake((SCREEN_WIDTH - 20) * 4, 166)];

}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    [self.delegate clickCourse:_listModel.data[tap.view.tag - 100]];
}

@end
