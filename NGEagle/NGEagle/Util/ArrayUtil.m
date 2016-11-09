//
//  ArrayUtil.m
//  NGEagle
//
//  Created by Liang on 15/8/19.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ArrayUtil.h"

@implementation ArrayUtil

/**
 *  根据pinyin进行排序
 *
 *  @param arrToSort
 *
 *  @return
 */

+ (NSMutableArray *)sortArrayWithPinYin:(NSMutableArray *)arrToSort {
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nick_pinyin" ascending:YES]];
    [arrToSort sortUsingDescriptors:sortDescriptors];
    return arrToSort;
}

@end
