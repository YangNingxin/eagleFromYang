//
//  UploadTaskViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/11.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface UploadTaskViewController : BaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *fileDict;
/**
 *  任务ID
 */
@property (nonatomic) int taskId;

/**
 *  所上班次ID
 */
@property (nonatomic) int openclass_id;

/**
 *  textView
 */
@property (nonatomic, weak) IBOutlet UITextView *textView;

/**
 *  内容
 */
@property (nonatomic, weak) IBOutlet UIView *contentView;

/**
 *  添加按钮
 */
@property (nonatomic, weak) IBOutlet UIButton *addButton;

- (IBAction)addButtonAction:(UIButton *)button;

@end
