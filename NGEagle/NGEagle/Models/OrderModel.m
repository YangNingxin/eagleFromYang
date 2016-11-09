//
//  OrderModel.m
//  NGEagle
//
//  Created by Liang on 15/8/14.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

@end


@implementation Order



@end



@implementation Goods

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

@end