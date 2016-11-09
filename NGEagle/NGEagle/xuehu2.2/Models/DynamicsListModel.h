//
//  DynamicsListModel.h
//  NGEagle
//
//  Created by Liang on 16/4/24.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "ResourceModel.h"
#import "UserModel.h"

@protocol Dynamics <NSObject>
@end

/**
 *  动态列表
 */
@interface DynamicsListModel : ErrorModel

@property (nonatomic, strong) NSArray<Dynamics> *dynamics;

@end

@interface Dynamics : JSONModel

@property (nonatomic, strong) NSString *dynamicId;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *publish_time;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray<Resource> *resource;

@property (nonatomic) int dynamic_type;
@property (nonatomic) int comments_num;
@property (nonatomic) int support_num;
@property (nonatomic) int forward_num;
@property (nonatomic, strong) NSArray<User> *support_user;
@property (nonatomic) BOOL is_supported_flag;
@property (nonatomic, strong) NSString *at_ids;

/**
 *  0表示没有资源，1表示图片，2表示视频，3表示音频
 */
@property (nonatomic) int type;
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 *  0正常，1下载中&&转码中，2播放中
 */
@property (nonatomic) int status;

@end