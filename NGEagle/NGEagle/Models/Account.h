//
//  Account.h
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "CourseMessageModel.h"
#import "SchoolModel.h"

@interface Account : NSObject {
    BOOL _isLogined;
}

@property (nonatomic, strong) UserModel *userModel;

/**
 *  1、老师 2、学生 3、家长
 */
@property (nonatomic) int identity;

/**
 *  选择节点的信息
 */
@property (nonatomic, strong) SchoolInfo *schoolInfo;

/**
 *  加一个server地址
 */
@property (nonatomic, strong) NSString *server;

- (void)setIsLogined:(BOOL)isLogined;
- (BOOL)isLogined;

+ (Account *)shareManager;

/**
 *  课程消息数量
 */
@property (nonatomic, strong) CourseMessageNumber *messageNumber;

/**
 *  得到消息总数
 */
- (void)getUnReadMessageNumber;

/**
 *  获取课程未读消息数
 */
- (void)getCourseMessageNumber;

@end




