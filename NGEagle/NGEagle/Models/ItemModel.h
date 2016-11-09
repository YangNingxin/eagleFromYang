//
//  ItemModel.h
//  NGEagle
//
//  Created by Liang on 15/7/26.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol Item

@end

@interface ItemModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<Item> *data;

@end


@interface Item : JSONModel
{
    BOOL _isSelect;
}
@property (nonatomic) int itemId; // "1",
@property (nonatomic, strong) NSString *name;// "自然环境"

- (BOOL)getSelect;
- (void)setSelect:(BOOL)isSelect;

@end