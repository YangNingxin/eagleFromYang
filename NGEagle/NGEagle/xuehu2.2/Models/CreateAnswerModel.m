//
//  CreateAnswerModel.m
//  NGEagle
//
//  Created by Liang on 16/5/15.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CreateAnswerModel.h"

@implementation CreateAnswerModel

@end

@implementation CreateAnswer

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"qid"
                                 }];
}

@end