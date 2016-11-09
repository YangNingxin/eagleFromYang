//
//  BootInitModel.m
//  NGEagle
//
//  Created by Liang on 15/8/25.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BootInitModel.h"

@implementation BootInitModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation Upgrade

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end


@implementation OtherLogin

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end