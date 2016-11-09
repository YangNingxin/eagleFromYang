//
//  IntSubjectModel.m
//  NGEagle
//
//  Created by Liang on 15/9/3.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "IntSubjectModel.h"

@implementation IntSubjectModel

@end

@implementation IntSubject

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"intId",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end