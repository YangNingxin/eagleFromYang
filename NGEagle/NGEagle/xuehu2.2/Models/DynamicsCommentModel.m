//
//  DynamicsCommentModel.m
//  NGEagle
//
//  Created by Liang on 16/4/25.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "DynamicsCommentModel.h"

@implementation DynamicsCommentModel

@end

@implementation CommentObject

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"cid",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation CommentReply

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