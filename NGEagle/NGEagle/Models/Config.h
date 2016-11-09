//
//  Config.h
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
/**
 *  配置设备唯一标记
 */
+ (void)configDeviceUUID;

+ (void)umengTrack;

+ (void)configBaiduMap;
@end
