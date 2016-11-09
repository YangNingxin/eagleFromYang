//
//  CCCourseListModel.m
//  NGEagle
//
//  Created by Liang on 16/4/30.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCCourseListModel.h"

@implementation CCCourseListModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation CCCourse

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"cid",
                                 @"description": @"desc"
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation FormatResource

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"fid",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end