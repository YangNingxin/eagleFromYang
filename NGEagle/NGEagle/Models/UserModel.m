//
//  UserModel.m
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "UserModel.h"
#import "NSDateUtil.h"

@implementation UserModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end


@implementation User

- (NSString *)schoolToString {
    
    NSMutableString *ss = [NSMutableString string];
    
    for (int i = 0; i < self.schooles.count; i++) {
        School *school = self.schooles[i];
        if (i < self.schooles.count - 1) {
            [ss appendFormat:@"%@,", school.name];
        } else {
            [ss appendFormat:@"%@", school.name];
        }
    }
  
    return ss;
}

- (void)setInterest_subject:(NSArray<Subject> *)interest_subject {
    _interest_subject = interest_subject;
    
    NSMutableString *ss = [NSMutableString string];
    
    for (int i = 0; i < _interest_subject.count; i++) {
        Subject *subject = _interest_subject[i];
        if (i < _interest_subject.count - 1) {
            [ss appendFormat:@"%@、", subject.name];
        } else {
            [ss appendFormat:@"%@", subject.name];
        }
    }
    self.subjectToString = ss;
}

//- (NSString *)subjectToString {
//    
//    NSMutableString *ss = [NSMutableString string];
//    
//    for (int i = 0; i < self.interest_subject.count; i++) {
//        Subject *subject = self.interest_subject[i];
//        if (i < self.interest_subject.count - 1) {
//            [ss appendFormat:@"%@、", subject.name];
//        } else {
//            [ss appendFormat:@"%@", subject.name];
//        }
//    }
//    return ss;
//}

- (NSString *)sexName {
    if ([self.sex intValue] == 0) {
        return @"保密";
    } else if ([self.sex intValue] == 1) {
        return @"男";
    }
    return @"女";
}

- (NSString *)birthdayName {
    return [NSDateUtil getDateWithTimeInterval:[self.birthday intValue]];
}

- (void)setBirthdayName:(NSString *)birthdayName {
    
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"school": @"schooles",
                                 @"class": @"classes",
                                }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end


@implementation School

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"description": @"desc",
                                 @"id": @"sid",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end


@implementation NG_Class

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"description": @"desc",
                                 @"id": @"cid",
                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end


@implementation Project

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"description": @"desc",
                                 @"id": @"pid",
                                 }];
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation Subject

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"sid",
                                 }];
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
