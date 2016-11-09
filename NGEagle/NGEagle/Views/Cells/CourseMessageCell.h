//
//  CourseMessageCell.h
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseMessageModel.h"

@interface CourseMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView1;

@property (nonatomic, strong) CourseMessage *coureseMessage;

- (IBAction)buttonAction:(UIButton *)sender;

@end
