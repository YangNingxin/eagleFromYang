//
//  QuestionDetailController.h
//  NGEagle
//
//  Created by Liang on 16/4/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseQuestionCell.h"
#import "AudioQuestionCell.h"
#import "ImageQuestionCell.h"
#import "VideoQuestionCell.h"
#import "MyPhotoBrowserController.h"

/**
 *  问题详情
 */
@interface DynamicViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
ImageQuestionCellDelegate, AudioQuestionCellDelegate>
{
    UITableView *_tableView;
    AudioQuestionCell *_audioCell;
    ImageQuestionCell *_imageCell;
    VideoQuestionCell *_videoCell;
}
@end
