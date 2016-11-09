//
//  CreateRegistarModel.h
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "RegistrationListModel.h"

@interface CreateRegistarModel : ErrorModel

@property (nonatomic, strong) RegistrationList *data;

@end
