//
//  TimeUtil.m
//  RecordCourse
//
//  Created by zhangyihui on 14-7-27.
//  Copyright (c) 2014年 qyer. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil

/**
 *  根据千毫秒数计算出分钟12:30格式
 *
 *  @param lasttime 千毫秒
 *
 *  @return string
 */

+ (NSString *)getMinWithThousandSecond:(int)lasttime
{
    
    lasttime = lasttime/1000;
    int min = lasttime/60;
    int second2 = lasttime%60;
    
    return [NSString stringWithFormat:@"%02d:%02d",min,second2];
    
}
+ (NSString *)getMinWithHundredSecond:(int)lasttime
{
    lasttime = lasttime/100;
    int min = lasttime/60;
    int second2 = lasttime%60;
    
    return [NSString stringWithFormat:@"%02d:%02d",min,second2];
}
+ (NSString *)getMinWithSecond:(int)lasttime
{
    int min = lasttime/60;
    int second2 = lasttime%60;
    
    return [NSString stringWithFormat:@"%02d:%02d",min,second2];
}
@end
