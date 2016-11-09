//
//  AddCommentSuccess.m
//  NGEagle
//
//  Created by Liang on 16/5/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AddCommentSuccess.h"

@implementation AddCommentSuccess

@end


@implementation AddComment

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper*)keyMapper {
    
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"cid"
                                 }];
}

@end