//
//  CourseFilterListModel.m
//  NGEagle
//
//  Created by Liang on 16/5/1.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CourseFilterListModel.h"

static CourseFilterListModel *share = nil;

@implementation CourseFilterListModel

+ (CourseFilterListModel *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[CourseFilterListModel alloc] init];
    });
    return share;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation CourseFilterList

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation DomainItem

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"did"
                                 }];
}

@end

@implementation KnowledgeType

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"kid"
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation FilterItem

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"fid"
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (BOOL)getSelect {
    return _isSelect;
}
- (void)setSelect:(BOOL)isSelect {
    _isSelect = isSelect;
}

@end
