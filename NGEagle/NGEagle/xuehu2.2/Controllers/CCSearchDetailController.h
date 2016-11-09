//
//  CCSearchDetailController.h
//  NGEagle
//
//  Created by Liang on 16/4/19.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  搜索详情页
 */
@interface CCSearchDetailController : BaseViewController

/**
 *  0为校内，1为云课堂
 */
@property (nonatomic) int type;

/**
 *  0为课程，1为课程集，2为问答， -1 为all
 */
@property (nonatomic) int subType;

@end
