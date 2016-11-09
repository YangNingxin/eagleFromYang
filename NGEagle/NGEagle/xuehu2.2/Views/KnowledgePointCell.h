//
//  KnowledgePointCell.h
//  NGEagle
//
//  Created by Liang on 16/4/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImageRightLabel.h"
#import "UserTagSubscribeModel.h"
/**
 *  知识点cell
 */
@interface KnowledgePointCell : UITableViewCell
{
    UIImageView *_backView;
    UIImageView *_iconView;
    UILabel *_titleLabel;
    LeftImageRightLabel *_numberLbl;
}
@property (nonatomic, strong) UserTagSubscribe *userTagSubscribe;
@end
