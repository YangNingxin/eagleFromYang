//
//  UserTagSubscribeModel.m
//  NGEagle
//
//  Created by Liang on 16/5/2.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "UserTagSubscribeModel.h"

@implementation UserTagSubscribeModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation UserTagSubscribe

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"sid"
                                 }];
}
@end