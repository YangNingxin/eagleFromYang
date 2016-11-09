//
//  ImageModel.h
//  rehab
//
//  Created by Liang on 15/8/10.
//  Copyright (c) 2015年 renxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

/**
 *  图片id或者索引
 */
@property(nonatomic) int imageId;

@property(nonatomic, strong) UIImage *image;

/**
 *  url
 */
@property(nonatomic, strong) NSString *url;

/**
 *  图片宽度
 */
@property(nonatomic, assign) float width;

/**
 *  图片高度
 */
@property(nonatomic, assign) float height;

@end
