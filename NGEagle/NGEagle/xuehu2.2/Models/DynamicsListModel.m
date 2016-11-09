//
//  DynamicsListModel.m
//  NGEagle
//
//  Created by Liang on 16/4/24.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "DynamicsListModel.h"

@implementation DynamicsListModel

@end

@implementation Dynamics

- (int)type {
    if (self.resource.count == 0) {
        return 1;
    } else {
        Resource *resource = self.resource[0];
        return resource.type;
    }
    return 1;
}

- (NSMutableArray *)imageArray {
    
    if (_imageArray) {
        return _imageArray;
    }
    NSMutableArray *tempArray = [NSMutableArray new];
    for (int i = 0; i < self.resource.count; i++) {
        Resource *resource = self.resource[i];
        [tempArray addObject:resource.url];
    }
    return tempArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"dynamicId",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end