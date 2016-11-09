
//
//  BaseQuestionCell.m
//  NGEagle
//
//  Created by Liang on 16/4/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseQuestionCell.h"
#import "NSDateUtil.h"

@implementation BaseQuestionCell
{
    /**
     *  0-问题，1-搜索，2-动态
     */
    int _cellTypeStyle;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
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
        _nameLabel.text = @"张三丰";
        _nameLabel.textColor = UIColorFromRGB(0x333333);
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_right).offset(5);
            make.top.equalTo(_headImageView.mas_top).offset(5);
        }];
        
        _timeLabel = [UILabel new];
        _timeLabel.text = @"2016-02-22 17:00";
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_right).offset(5);
            make.bottom.equalTo(_headImageView.mas_bottom).offset(-5);
        }];
        
        // 追问标志符
        _appendView = [AppendView new];
        [self.contentView addSubview:_appendView];
        
        [_appendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(40, 24));
        }];
        
        _myContentView = [UIImageView new];
        _myContentView.userInteractionEnabled = YES;
        _myContentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_myContentView];
        
        [_myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(_headImageView.mas_bottom).offset(0);
            make.bottom.mas_equalTo(-10);
        }];
        
        _contentLabel = [UILabel new];
        _contentLabel.text = @"sdf";
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 10;
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
        _contentLabel.textColor = UIColorFromRGB(0x888888);
        [_myContentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(5);
        }];
        
        _resourceView = [UIView new];
        _resourceView.backgroundColor = [UIColor clearColor];
        [_myContentView addSubview:_resourceView];
        
        [_resourceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentLabel);
            make.top.equalTo(_contentLabel.mas_bottom).offset(5);
//            make.bottom.mas_equalTo(-10);
        }];
        
        _bottomView = [UIView new];
        [_myContentView addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentLabel);
            make.top.equalTo(_resourceView.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(-10);
        }];
        
        _descLabel = [UILabel new];
        _descLabel.font = [UIFont systemFontOfSize:14.0];
        _descLabel.textColor = [UIColor lightGrayColor];
        [_bottomView addSubview:_descLabel];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(5);
        }];
        
        _supportButton = [LeftImageRightLabel new];
        _supportButton.label.text = @"赞";
        _supportButton.tag = 110;
        _supportButton.label.textColor = [UIColor lightGrayColor];
        _supportButton.imageView.image = [UIImage imageNamed:@"gray_like"];
        [_bottomView addSubview:_supportButton];
        
        [_supportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-5);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAction:)];
        [_supportButton addGestureRecognizer:tap];
        
        _supportButton.hidden = YES;
        
        UIView *tempView = nil;
        for (int i = 0; i < 3; i++) {
            LeftImageRightLabel *handleButton = [LeftImageRightLabel new];
            handleButton.tag = 10 + i;
            handleButton.label.textColor = [UIColor lightGrayColor];
            [_bottomView addSubview:handleButton];
            
            switch (i) {
                case 0:
                    handleButton.label.text = @"采纳";
                    handleButton.imageView.image = [UIImage imageNamed:@"support2"];
                    break;
                case 1:
                    handleButton.label.text = @"赞";
                    handleButton.imageView.image = [UIImage imageNamed:@"gray_like"];
                    break;
                case 2:
                    handleButton.label.text = @"追问";
                    handleButton.imageView.image = [UIImage imageNamed:@"zhuiwen"];
                    break;
  
                default:
                    break;
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAction:)];
            [handleButton addGestureRecognizer:tap];

            if (!tempView) {
                [handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-5);
                }];
            } else {
                [handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.right.equalTo(tempView.mas_left).offset(-10);
                }];
            }
            tempView = handleButton;
        }
    }
    return self;
}

- (void)handleAction:(UITapGestureRecognizer *)tap {
    
    LeftImageRightLabel *temp = (LeftImageRightLabel *)tap.view;
    if (_cellTypeStyle == 2) {
        [self.handleDelegate handelAction:(int)temp.tag - 10 dataSource:self.dynamic];
    } else {
        [self.handleDelegate handelAction:(int)temp.tag - 10 dataSource:self.question];
    }
}

- (void)changeStyleToSearchView {
    
    _cellTypeStyle = 1;

    if (_bottomView) {
        [_bottomView removeFromSuperview];
        _bottomView = nil;
    }
    if (_appendView) {
        [_appendView removeFromSuperview];
        _appendView = nil;
    }
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    [_resourceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
}

- (void)changeStyleToDynamic  {
    _cellTypeStyle = 2;
    
    for (int i = 0; i < 3; i++) {
        LeftImageRightLabel *handleButton = [_bottomView viewWithTag:10 + i];
        handleButton.userInteractionEnabled = NO;
        switch (i) {
            case 0:
                handleButton.label.text = [NSString stringWithFormat:@"赞(%d)", self.dynamic.support_num];
                handleButton.imageView.image = [UIImage imageNamed:@"gray_like"];
                break;
            case 1:
                handleButton.label.text = [NSString stringWithFormat:@"评论(%d)", self.dynamic.comments_num];
                handleButton.imageView.image = [UIImage imageNamed:@"zhuiwen"];
                break;
            case 2:
                handleButton.hidden = YES;
                break;
            default:
                break;
        }
    }
}

- (void)setDynamic:(Dynamics *)dynamic {
    _dynamic = dynamic;
    _nameLabel.text = dynamic.user.name;
    [_headImageView setImageWithURL:[NSURL URLWithString:_dynamic.user.logo] placeholderImage:[UIImage imageNamed:@"default_head"]];
    _timeLabel.text = [NSDateUtil getTimeDiffString:[dynamic.publish_time intValue]];
    _contentLabel.text = _dynamic.content;
    
    _appendView.hidden = YES;
    _descLabel.hidden = YES;
}

- (void)setQuestion:(CCQuestion *)question {
    _question = question;
    
    _descLabel.text =  [NSString stringWithFormat:@"%d人回答", question.answer_nr];

    _nameLabel.text = question.user.name;
    [_headImageView setImageWithURL:[NSURL URLWithString:question.user.logo] placeholderImage:[UIImage imageNamed:@"default_head"]];
    _timeLabel.text = question.format_ctime;
    //[NSDateUtil getTimeDiffString:[question.publish_time intValue]];
    _contentLabel.text = question.content;
    
    
    // 10 采纳 -- 11 赞 -- 12 追问
    LeftImageRightLabel *handleButton = [_bottomView viewWithTag:10];
    LeftImageRightLabel *handleButton1 = [_bottomView viewWithTag:11];
    LeftImageRightLabel *handleButton2 = [_bottomView viewWithTag:12];
    
    if (!self.isAnswerUI || _question.isQustionUI) {
        handleButton.hidden = YES;
        handleButton1.hidden = YES;
        handleButton2.hidden = YES;
        
        NSString *status = @"未采纳";
        if (_question.status) {
            status = @"已采纳";
        }
        _descLabel.text =  [NSString stringWithFormat:@"%d人回答  %@", question.answer_nr, status];
        _appendView.hidden = YES;
    } else {
        _appendView.hidden = NO;
        _appendView.numberLabel.text = [NSString stringWithFormat:@"%d", question.closely_question_nr];
        _descLabel.text =  [NSString stringWithFormat:@"%d人觉得很赞", question.agree_nr];

        // 如果问题是自己的
        if (self.isMyQuestion) {
            
            // 是答案的UI
            if (_question.acception) {
                [handleButton initWithData:@"已采纳" image:[UIImage imageNamed:@"support2_clicked"]];
                handleButton.label.textColor = kThemeColor;
            } else {
                [handleButton initWithData:@"采纳" image:[UIImage imageNamed:@"support2"]];
                handleButton.label.textColor = [UIColor lightGrayColor];
            }
            if (_question.is_agree) {
                [handleButton1 initWithData:@"赞" image:[UIImage imageNamed:@"red_like"]];
            } else {
                [handleButton1 initWithData:@"赞" image:[UIImage imageNamed:@"gray_like"]];
            }
        } else {
            _supportButton.hidden = NO;
            if (_question.is_agree) {
                [_supportButton initWithData:@"赞" image:[UIImage imageNamed:@"red_like"]];
            } else {
                [_supportButton initWithData:@"赞" image:[UIImage imageNamed:@"gray_like"]];
            }

            handleButton.hidden = YES;
            handleButton1.hidden = YES;
            handleButton2.hidden = YES;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithChatStyle:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 25.0;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"default_head"];
        [self.contentView addSubview:_headImageView];
    
        _myContentView = [UIImageView new];
        _myContentView.backgroundColor = [UIColor clearColor];
        _myContentView.userInteractionEnabled = YES;
        [self.contentView addSubview:_myContentView];
    
        _contentLabel = [UILabel new];
        _contentLabel.text = @"测试数据使用的CAS方式，和教委原来的方式相同，已经和对方商务沟通过了，需要他找开发配合一起完成使用的CAS方式，和教委原来的方式相同，已经和对方商务沟通过了，需要他找开发配合一起完成使用的CAS方式，和教委原来的方式相同，已经和对方商务沟通过了，需要他找开发配合一起完成使用的CAS方式，和教委原来的方式相同，已经和对方商务沟通过了，需要他找开发配合一起完成使用的CAS方式，和教委原来的方式相同，已经和对方商务沟通过了，需要他找开发配合一起完成使用的CAS方式，和教委原来的方式相同，已经和对方商务沟通过了，需要他找开发配合一起完成";
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 135;
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
        _contentLabel.textColor = UIColorFromRGB(0x888888);
        [_myContentView addSubview:_contentLabel];
               
        _resourceView = [UIView new];
        _resourceView.backgroundColor = [UIColor clearColor];
        [_myContentView addSubview:_resourceView];
        
        [self setLeft];
    }
    return self;
}

- (void)setLeft {
    [_headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_myContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.top.equalTo(_headImageView).offset(15);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-50);
    }];
    
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
    }];
    
    [_resourceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentLabel);
        make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(-10);
    }];
    
    _myContentView.image = [[UIImage imageNamed:@"chat_msg_back1"] stretchableImageWithLeftCapWidth:15 topCapHeight:20];
}
- (void)setRight {
    
    [_headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

    [_myContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-60);
        make.left.mas_equalTo(50);
        make.top.equalTo(_headImageView).offset(5);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(5);
    }];
    
    [_resourceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentLabel);
        make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(-10);
    }];

    _myContentView.image = [[UIImage imageNamed:@"chat_msg_back2"] stretchableImageWithLeftCapWidth:15 topCapHeight:20];

}
@end
