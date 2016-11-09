//
//  ArrayUtil.h
//  NGEagle
//
//  Created by Liang on 15/8/19.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayUtil : NSObject

/**
 *  根据pinyin进行排序
 *
 *  @param arrToSort
 *
 *  @return
 */
+ (NSMutableArray *)sortArrayWithPinYin:(NSMutableArray *)arrToSort;

@end
