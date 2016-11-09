//
//  ItemModel.m
//  NGEagle
//
//  Created by Liang on 15/7/26.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

@end


@implementation Item

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"itemId",
                                 }];
}

- (BOOL)getSelect {
    return _isSelect;
}
- (void)setSelect:(BOOL)isSelect {
    _isSelect = isSelect;
}

@end