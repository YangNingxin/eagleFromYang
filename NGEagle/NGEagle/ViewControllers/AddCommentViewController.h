//
//  AddCommentViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "TagsModel.h"

@interface AddCommentViewController : BaseViewController

/**
 *  选中标签个数
 */
@property (nonatomic) int number;
@property (nonatomic) int cid;
@property (nonatomic, strong) TagsModel *tagsModel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end
