//
//  NotifationUserModel.h
//  NGEagle
//
//  Created by Liang on 15/9/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@interface NotifationUserModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<User> *data;

@end
