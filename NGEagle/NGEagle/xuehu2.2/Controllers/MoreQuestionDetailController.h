//
//  MyQuestionController.h
//  NGEagle
//
//  Created by Liang on 16/4/20.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

#import "BaseQuestionCell.h"
#import "AudioQuestionCell.h"
#import "ImageQuestionCell.h"
#import "VideoQuestionCell.h"
#import "MyPhotoBrowserController.h"

/**
 *  追问详情，类似聊天
 */
@interface MoreQuestionDetailController : BaseViewController <UITableViewDelegate, UITableViewDataSource,
ImageQuestionCellDelegate, AudioQuestionCellDelegate>
{
    UITableView *_tableView;
    AudioQuestionCell *_audioCell;
    ImageQuestionCell *_imageCell;
    VideoQuestionCell *_videoCell;
}

@property (nonatomic) int questionId;
@property (nonatomic) int answerId;
@property (nonatomic) BOOL isMyQuestion;

@end

