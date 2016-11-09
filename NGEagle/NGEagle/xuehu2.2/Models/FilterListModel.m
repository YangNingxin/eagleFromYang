//
//  FilterListModel.m
//  NGEagle
//
//  Created by Liang on 16/5/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "FilterListModel.h"

@implementation FilterListModel

@end


@implementation FilterList

@end


@implementation Filter

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper*)keyMapper {
    
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"fid"
                                 }];
}

@end