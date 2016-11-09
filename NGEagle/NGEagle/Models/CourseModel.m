//
//  CourseModel.m
//  NGEagle
//
//  Created by Liang on 15/7/25.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel

@end

@implementation Course

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"cid",
                                 @"description": @"desc",
                                 }];
}

- (NSString *)objectStudent {
    
    NSMutableString *string = [NSMutableString stringWithString:@"本课程适用于 "];
    for (Grade *grade in self.grades) {
        [string appendFormat:@"%@ ", grade.name];
    }
    return string;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation Grade

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"gid",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end