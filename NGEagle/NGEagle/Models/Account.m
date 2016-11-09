//
//  Account.m
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "Account.h"
#import "DBManager.h"
#import "TMCache.h"

static Account *share = nil;

@implementation Account

+ (Account *)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[Account alloc] init];
    });
    return share;
}
/*
- (void)setServer:(NSString *)server {
    if (!server) {
        _server = API_SERVER;
        return;
    }
    if ([server hasPrefix:@"http://"]) {
        _server = server;
    } else {
        _server = [NSString stringWithFormat:@"http://%@", server];
    }
}
*/

- (NSString *)server {
    if (_server) {
        return _server;
    }
    return [NSString stringWithFormat:@"http://%@", self.schoolInfo.domain];
}

- (int)identity {
    return self.userModel.user.type;
}

- (SchoolInfo *)schoolInfo {
    
    // 如果不存在，去获取缓存里的信息
    if (_schoolInfo == nil) {
        _schoolInfo = [[TMCache sharedCache] objectForKey:@"node"];
    }
    return _schoolInfo;
}

/**
 *  之所以加2.0，就是为了新版登录兼容
 *
 *  @param isLogined
 */
- (void)setIsLogined:(BOOL)isLogined {
    
    // 如果设置为NO，就是退出登录了，要清空一些数据
    if (isLogined == NO) {
        
        [DataHelper clearCookie];
        
        [Account shareManager].userModel = nil;
        
        [[DBManager shareManager].database close];
        [DBManager shareManager].database = nil;
        
        [[TMCache sharedCache] removeObjectForKey:@"userModel"];
    }
    _isLogined = isLogined;
    [[NSUserDefaults standardUserDefaults] setBool:isLogined forKey:@"isLogin2.0"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLogined {
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin2.0"];
    return login;
}

- (void)getUnReadMessageNumber {
    
    NSInteger number = [[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMessageNumber" object:[NSString stringWithFormat:@"%ld",number]];
}

- (void)getCourseMessageNumber {
    
    [DataHelper checkMessageWithToken:nil success:^(id responseObject) {
        self.messageNumber = responseObject;
        if (self.messageNumber.error_code == 0) {
            
            int total = self.messageNumber.course.countNumber + self.messageNumber.announcement.countNumber;
            NSString *msgNumber = [NSString stringWithFormat:@"%d", total];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showCourseMsgNumber" object:msgNumber];
        }
    } fail:^(NSError *error) {
        
    }];
}

@end



