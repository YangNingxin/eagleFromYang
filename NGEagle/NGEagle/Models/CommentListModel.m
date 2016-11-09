//
//  CommentListModel.m
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CommentListModel.h"

@implementation CommentListModel

@end

@implementation Comment

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"cid",
                                 }];
}


@end

@implementation Tag

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"tid",
                                 }];
}


@end