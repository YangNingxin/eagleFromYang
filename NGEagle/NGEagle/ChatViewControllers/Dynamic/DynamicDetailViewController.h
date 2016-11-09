//
//  DynamicDetailViewController.h
//  NGEagle
//
//  Created by Liang on 16/4/26.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "DynamicsListModel.h"
#import "AudioQuestionCell.h"
#import "ImageQuestionCell.h"
#import "VideoQuestionCell.h"
#import "MyPhotoBrowserController.h"

@interface DynamicDetailViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,
ImageQuestionCellDelegate, AudioQuestionCellDelegate>
{
    UITableView *_tableView;
    AudioQuestionCell *_audioCell;
    ImageQuestionCell *_imageCell;
    VideoQuestionCell *_videoCell;
}
@property (nonatomic, strong) Dynamics *dynamics;

@end
