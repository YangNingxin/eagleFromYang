//
//  GroupButton.h
//  NGEagle
//
//  Created by Liang on 15/8/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupButton : UIButton

// 标题
@property (nonatomic, strong) UILabel *lblTitle;

// 图片
@property (nonatomic, strong) UIImageView *iconImageView;

// 个数
@property (nonatomic, strong) UILabel *lblNumber;

@end
