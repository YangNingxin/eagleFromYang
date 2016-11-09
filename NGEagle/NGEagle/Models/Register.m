//
//  Register.m
//  NGEagle
//
//  Created by Liang on 15/7/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "Register.h"

static Register *share = nil;

@implementation Register

+ (Register *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[Register alloc] init];
    });
    return share;
}

@end
