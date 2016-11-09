//
//  ResourceModel.m
//  NGEagle
//
//  Created by Liang on 15/7/25.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ResourceModel.h"

@implementation ResourceModel

@end

@implementation UpLoadResourceModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation Resource

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"rid",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end