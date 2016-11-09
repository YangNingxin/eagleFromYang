//
//  CreateQuestionModel.m
//  NGEagle
//
//  Created by Liang on 16/5/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CreateQuestionModel.h"

@implementation CreateQuestionModel

@end


@implementation CreateQuestion

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