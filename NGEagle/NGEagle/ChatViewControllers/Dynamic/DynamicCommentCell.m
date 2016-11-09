//
//  DynamicCommentCell.m
//  NGEagle
//
//  Created by Liang on 16/4/26.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "DynamicCommentCell.h"
#import "NSDateUtil.h"

@implementation DynamicCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        
        _topView = [UIView new];
        [self.contentView addSubview:_topView];
        
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(60);
        }];
        
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 25.0;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"default_head"];
        [self.contentView addSubview:_headImageView];
        
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = UIColorFromRGB(0x333333);
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_right).offset(5);
            make.top.equalTo(_headImageView.mas_top).offset(5);
        }];
        
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_right).offset(5);
            make.bottom.equalTo(_headImageView.mas_bottom).offset(-5);
        }];
        
        _replayButton = [LeftImageRightLabel new];
        [_replayButton initWithData:@"回复" image:[UIImage imageNamed:@"icon_replay"]];
        _replayButton.label.textColor = kThemeColor;
        _replayButton.label.font = [UIFont systemFontOfSize:12.0];
        [_topView addSubview:_replayButton];
        
        [_replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.right.mas_offset(-5);
        }];
        
        UITapGestureRecognizer *tapReplay = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(replayAction)];
        [_replayButton addGestureRecognizer:tapReplay];
        
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 70;
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
        _contentLabel.textColor = UIColorFromRGB(0x888888);
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.right.mas_equalTo(-10);
            make.top.equalTo(_topView.mas_bottom).offset(0);
        }];
        
        _replayView = [UIView new];
        [self.contentView addSubview:_replayView];
        
        [_replayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentLabel);
            make.bottom.mas_offset(0);
            make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        }];
    }
    return self;
}

- (void)replayAction {
    [self.delegate clickReplay:self.comment toUser:self.comment.user];
}

- (void)replayUser:(UITapGestureRecognizer *)tap {
    int index = (int)tap.view.tag - 100;
    CommentReply *replay = self.comment.reply[index];
    [self.delegate clickReplay:self.comment toUser:replay.user];
}

- (void)setComment:(CommentObject *)comment {
    _comment = comment;
    _nameLabel.text = comment.user.name;
    [_headImageView setImageWithURL:[NSURL URLWithString:comment.user.logo]
                   placeholderImage:[UIImage imageNamed:@"default_head"]];
    _timeLabel.text = [NSDateUtil getTimeDiffString:[comment.publish_time intValue]];
    _contentLabel.text = comment.content;
    for (UIView * v in _replayView.subviews) {
        [v removeFromSuperview];
    }
    
    UIView *tempView;
    for (int i = 0; i < comment.reply.count; i++) {
        
        CommentReply *replay = comment.reply[i];
        NSString *name1 = replay.user.name;
        NSString *name2 = replay.puser.name;
        
        NSString *result = [NSString stringWithFormat:@"%@回复%@：%@", name1, name2, replay.content];
        
        TTTAttributedLabel *hintLabel1 = [[TTTAttributedLabel alloc] init];
        [hintLabel1 setNumberOfLines:0];
        hintLabel1.tag = 100 + i;
        hintLabel1.userInteractionEnabled = YES;
        [hintLabel1 setFont:[UIFont systemFontOfSize:13.0f]];
        [hintLabel1 setBackgroundColor:[UIColor clearColor]];
        [hintLabel1 setTextAlignment:NSTextAlignmentLeft];
        [hintLabel1 setLineBreakMode:NSLineBreakByWordWrapping];
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:result];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kThemeColor CGColor]
                            range:NSMakeRange(0, name1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kThemeColor CGColor]
                            range:NSMakeRange(name1.length + 2, name2.length)];
        [hintLabel1 setText:hintString1];
        [_replayView addSubview:hintLabel1];
        
        UITapGestureRecognizer *tapReplay = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(replayUser:)];
        [hintLabel1 addGestureRecognizer:tapReplay];
        
        if (!tempView) {
            [hintLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_offset(0);
                make.top.mas_offset(0);
            }];
        } else {
            [hintLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_offset(0);
                make.top.equalTo(tempView.mas_bottom).offset(5);
            }];
        }
        tempView = hintLabel1;
    }
    if (tempView) {
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
        }];
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
