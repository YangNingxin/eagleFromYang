//
//  KaoqingListCell.h
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationListModel.h"

@interface KaoqingListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *view;

/**
 *  封面
 */
@property (weak, nonatomic) IBOutlet UIImageView *cover;

/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 *  共多少人
 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

/**
 *  到多少人
 */
@property (weak, nonatomic) IBOutlet UILabel *arriveLabel;

/**
 *  迟到多少人
 */
@property (weak, nonatomic) IBOutlet UILabel *lateLabel;

/**
 *  未到多少人
 */
@property (weak, nonatomic) IBOutlet UILabel *unarriveLabel;

@property (nonatomic, strong) RegistrationList *registrationList;

@end
