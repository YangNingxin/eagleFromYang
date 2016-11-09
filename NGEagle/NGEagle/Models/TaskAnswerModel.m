//
//  TaskAnswerModel.m
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "TaskAnswerModel.h"

@implementation TaskAnswerModel

@end

@implementation TaskAnswer

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"answerId",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end