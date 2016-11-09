//
//  ErrorModel.h
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ErrorModel : JSONModel

@property (nonatomic, strong) NSString *error_msg;
@property (nonatomic, assign) int error_code;

@end
