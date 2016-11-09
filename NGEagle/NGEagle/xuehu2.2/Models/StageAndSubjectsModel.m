//
//  StageAndSubjectsModel.m
//  NGEagle
//
//  Created by Liang on 16/5/2.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "StageAndSubjectsModel.h"

@implementation StageAndSubjectsModel

@end

@implementation StageAndSubjects
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"sid"
                                 }];
}
@end

@implementation SubjectModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"sid"
                                 }];
}

@end
