//
//  RegistarUserListModel.h
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"


@interface RegistarUserListModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<User> *data;

@end