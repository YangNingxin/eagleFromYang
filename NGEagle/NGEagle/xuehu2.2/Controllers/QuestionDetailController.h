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
 *  我的问答
 */
@interface QuestionDetailController : BaseViewController <UITableViewDelegate, UITableViewDataSource,
ImageQuestionCellDelegate, AudioQuestionCellDelegate, BaseQuestionCellDelegate>
{
    UITableView *_tableView;
    AudioQuestionCell *_audioCell;
    ImageQuestionCell *_imageCell;
    VideoQuestionCell *_videoCell;
}

@property (nonatomic) int questionId;

@end
