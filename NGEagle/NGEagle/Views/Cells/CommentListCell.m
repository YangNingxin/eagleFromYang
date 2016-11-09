//
//  CommentListCell.m
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CommentListCell.h"
#import "UIImageView+AFNetworking.h"

@implementation CommentListCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.headImageView.image = [UIImage imageNamed:@"class_icon_user1"];
    self.headImageView.clipsToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 20.0;
    
    
    self.rateView = [[DYRateView alloc] initWithFrame:CGRectMake(120, 66, 107, 16)
                                             fullStar:[UIImage imageNamed:@"start_l"]
                                            emptyStar:[UIImage imageNamed:@"start_g"]];
    self.rateView.backgroundColor = [UIColor clearColor];
    self.rateView.alignment = RateViewAlignmentLeft;
    [self.rateView setRate:0.5];
    [self addSubview:self.rateView];
    
    self.tagLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.tagLabel.layer.borderWidth = 1.0;
    self.tagLabel.textColor = [UIColor lightGrayColor];
    
    self.tagLabel2.layer.borderColor = [UIColor grayColor].CGColor;
    self.tagLabel2.layer.borderWidth = 1.0;
    self.tagLabel2.textColor = [UIColor lightGrayColor];
    
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.schoolLabel.textColor = [UIColor lightGrayColor];
    self.scoreLabel.textColor = RGB(228, 152, 37);
    
    self.lineImageView.height = 0.5;
    // Initialization code
}

- (void)setComment:(Comment *)comment {
    _comment = comment;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:comment.user.logo]];
    self.nameLabel.text = comment.user.name;
    self.schoolLabel.text = [comment.user schoolToString];
    self.timeLabel.text = comment.format_ctime;
    
    self.contentLabel.text = comment.content;
    [self.contentLabel sizeToFit];
    self.contentLabel.width = SCREEN_WIDTH - 70;
    
    if (comment.tags.count >= 2) {
        
        Tag *tag = comment.tags[0];
        Tag *tag2 = comment.tags[1];
       
        self.tagLabel.text = tag.name;
        self.tagLabel2.text = tag2.name;

        self.tagLabel.hidden = NO;
        self.tagLabel2.hidden = NO;
        
    } else if (comment.tags.count == 1) {
        
        Tag *tag = comment.tags[0];
        self.tagLabel.text = tag.name;
        self.tagLabel2.text = @"";
        
        self.tagLabel.hidden = NO;
        self.tagLabel2.hidden = YES;

    } else {
        self.tagLabel.text = @"";
        self.tagLabel2.text = @"";
        
        self.tagLabel.hidden = YES;
        self.tagLabel2.hidden = YES;
    }
    
    [self.tagLabel sizeToFit];
    self.tagLabel.width = self.tagLabel.width + 10;
    self.tagLabel.top = self.contentLabel.bottom + 10;
    self.tagLabel.left = self.contentLabel.left;
    
    [self.tagLabel2 sizeToFit];
    self.tagLabel2.width = self.tagLabel2.width + 10;
    self.tagLabel2.top = self.contentLabel.bottom + 10;
    self.tagLabel2.left = self.tagLabel.right + 10;

    
    self.scoreLabel.text = [NSString stringWithFormat:@"%.0f分", comment.star];
    [self.scoreLabel sizeToFit];
    self.scoreLabel.top = self.tagLabel.bottom + 10;
    self.scoreLabel.right = SCREEN_WIDTH - 10;

    [self.rateView setRate:comment.star/5.0];
    self.rateView.top = self.tagLabel.bottom + 10;
    self.rateView.right = self.scoreLabel.left - 10;
    
    self.backImageView.height = self.scoreLabel.top + self.scoreLabel.height + 10;
    self.cellHeight = self.backImageView.height + 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
