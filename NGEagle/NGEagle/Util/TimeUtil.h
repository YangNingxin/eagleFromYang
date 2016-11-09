//
//  TimeUtil.h
//  RecordCourse
//
//  Created by zhangyihui on 14-7-27.
//  Copyright (c) 2014年 qyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject
/**
 *  根据千毫秒数计算出分钟12:30格式
 *
 *  @param lasttime 千毫秒
 *
 *  @return string
 */
+ (NSString *)getMinWithThousandSecond:(int)lasttime;

+ (NSString *)getMinWithHundredSecond:(int)lasttime;

+ (NSString *)getMinWithSecond:(int)lasttime;
@end
