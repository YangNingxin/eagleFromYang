//
//  TransactionCell.h
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface TransactionCell : UITableViewCell

/**
 *  标签
 */
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

/**
 *  付款记录，退款记录
 */
@property (weak, nonatomic) IBOutlet UILabel *label;

/**
 *  课程logo
 */
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 学分
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

// 适用年级
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView2;

// 实际交易多少钱
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) Order *order;

@end
