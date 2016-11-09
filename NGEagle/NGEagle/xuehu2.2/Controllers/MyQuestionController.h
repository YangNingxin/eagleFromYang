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
@interface MyQuestionController : BaseViewController <UITableViewDelegate, UITableViewDataSource, ImageQuestionCellDelegate, AudioQuestionCellDelegate>
{
    UITableView *_tableView;
    AudioQuestionCell *_audioCell;
    ImageQuestionCell *_imageCell;
    VideoQuestionCell *_videoCell;
}
@end
