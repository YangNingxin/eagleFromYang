//
//  CourseMessageModel.m
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CourseMessageModel.h"

@implementation CourseMessageModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end


@implementation CourseMessage

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"mid",
                                 }];
}


+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end




@implementation CourseMessageNumber

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation CourseNumber

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"count": @"countNumber",
                                 }];
}

@end