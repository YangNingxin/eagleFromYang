//
//  InputViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupView.h"

typedef void(^FinishBlock)(NSString *content);

@interface InputViewController : BaseViewController
{
    FinishBlock _block;
}

/**
 *  type=0和3，为修改用户名和昵称，其他为长文本
 */
@property (nonatomic) int type;
@property (nonatomic, strong) NSString *content;

- (void)setFinishBlock:(FinishBlock)block;

@end
