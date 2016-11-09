//
//  TaskAnserCell.m
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "TaskAnserCell.h"
#import "NSDateUtil.h"
#import "TaskDetailViewController.h"

@implementation TaskAnserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.supportButton = [[UIButton alloc] init];
        self.supportButton.userInteractionEnabled = NO;
        [self.supportButton setImage:[UIImage imageNamed:@"icon_support"] forState:UIControlStateNormal];
        [self.supportButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.supportButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.supportButton];
        
        self.commentButton = [[UIButton alloc] init];
        self.commentButton.userInteractionEnabled = NO;
        [self.commentButton setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [self.commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.commentButton];
    }
    return self;
}

/**
 *  重写set数据
 *
 *  @param taskAnswer 任务答案
 */
- (void)setTaskAnswer:(TaskAnswer *)taskAnswer {
    _taskAnswer = taskAnswer;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:_taskAnswer.author.logo]
                       placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.nameLabel.text = _taskAnswer.author.nick;
    self.schoolLabel.text = _taskAnswer.author.schoolToString;
    self.timeLabel.text = [NSDateUtil formatDate:[NSDate dateWithTimeIntervalSince1970:_taskAnswer.ctime]];
    
    self.contentLabel.text = _taskAnswer.content;
    self.imageArray = _taskAnswer.resource;
    [self.collectionView reloadData];
    
    [self.supportButton setTitle:[NSString stringWithFormat:@"赞 %d", _taskAnswer.agree_nr] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"评论 %d", _taskAnswer.disagree_nr] forState:UIControlStateNormal];

    [self reLayoutSubviews];
}

/**
 *  重新根据数据进行布局
 */
- (void)reLayoutSubviews {
    
    self.contentLabel.width = kContentWidth;
    [self.contentLabel sizeToFit];
    
    self.collectionView.top = self.contentLabel.bottom + 10;
    self.collectionView.height = [self getCollectionViewHeightWithImageArray:self.imageArray];
    if (self.imageArray.count == 1) {
        self.collectionView.width = kOneImageWidth;
    } else {
        self.collectionView.width = kContentWidth;
    }
    
    [self.supportButton sizeToFit];
    [self.commentButton sizeToFit];
    
    self.supportButton.top = self.collectionView.bottom + 10;
    self.commentButton.top = self.collectionView.bottom + 10;
    
    self.commentButton.right = SCREEN_WIDTH - 10;
    self.supportButton.right = self.commentButton.left - 20;
    
    _taskAnswer.height = self.commentButton.bottom + 10;
}

- (void)tapCollectionViewAction {
    if (self.viewController) {
        
        TaskDetailViewController *taskDetailVc = [[TaskDetailViewController alloc] initWithNibName:@"TaskDetailViewController" bundle:nil];
        taskDetailVc.taskAnswer = self.taskAnswer;
        [self.viewController.navigationController pushViewController:taskDetailVc animated:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
