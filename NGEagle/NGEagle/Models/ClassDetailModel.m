//
//  ClassDetailModel.m
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ClassDetailModel.h"

@implementation ClassDetailModel

@end

@implementation ClassDetail

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"cid",
                                 @"description": @"desc",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end