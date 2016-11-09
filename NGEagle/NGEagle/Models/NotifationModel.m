//
//  NotifationModel.m
//  NGEagle
//
//  Created by Liang on 15/9/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NotifationModel.h"

@implementation NotifationModel

@end


@implementation Notefation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"nid",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end