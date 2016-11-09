//
//  AddNoteViewController.h
//  NGEagle
//
//  Created by Liang on 16/5/3.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCPublishViewController.h"
#import "AddNoteSuccess.h"

typedef void(^AddNoteSuccessBlock)(AddNoteSuccess *model);

@interface AddNoteViewController : CCPublishViewController

/**
 *  创建笔记的对象类型，1--微课，2--课程集的课时
 */
@property (nonatomic) int type;
@property (nonatomic) int target_id;
@property (nonatomic) int mark_at;

- (void)setAddNoteSuccessBlock:(AddNoteSuccessBlock)block;

@end
