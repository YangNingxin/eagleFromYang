//
//  ResourceModel.h
//  NGEagle
//
//  Created by Liang on 15/7/25.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "JSONModel.h"

@class Resource;

@protocol Resource
@end

@interface ResourceModel : ErrorModel

@property (nonatomic, strong) Resource *data;

@end

@interface UpLoadResourceModel : ErrorModel

@property (nonatomic, strong) NSArray<Resource> *data;

@end

@interface Resource : JSONModel

/**
 *  资源ID
 */
@property (nonatomic, assign) int rid;

/**
 *  md5地址
 */
@property (nonatomic, strong) NSString *md;

/**
 *  1表示图片，2表示视频，3表示音频
 */
@property (nonatomic, assign) int type;

/**
 *  资源URL
 */
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *url_150_200;
@property (nonatomic, strong) NSString *url_200_150;
@property (nonatomic, strong) NSString *url_200_200;
@property (nonatomic) int width;
@property (nonatomic) int height;
@end
