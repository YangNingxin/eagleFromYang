//
//  DynamicCommentCell.h
//  NGEagle
//
//  Created by Liang on 16/4/26.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "DynamicsCommentModel.h"
#import "LeftImageRightLabel.h"

@protocol DynamicCommentCellDelegate <NSObject>

- (void)clickReplay:(CommentObject *)comment toUser:(User *)user;

@end

@interface DynamicCommentCell : UITableViewCell
{
    UIView *_topView;
    
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    LeftImageRightLabel *_replayButton;
    
    UILabel *_contentLabel;
    
    UIView *_replayView;
}
@property (nonatomic, strong) CommentObject *comment;
@property (nonatomic, weak) id<DynamicCommentCellDelegate> delegate;

@end
