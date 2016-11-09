//
//  UIImageUtil.h
//  BaiduLibrary
//
//  Created by Liang on 14/12/2.
//  Copyright (c) 2014年 zhuayi inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageUtil : NSObject

//获取屏幕截图
+ (UIImage *)getScreenImage:(UIView *)theView;

+ (UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage;

+ (UIImage *)imageBlackToTransparent:(UIImage*)image;


+ (UIImage *)thumbnailWithImage:(UIImage *)image;
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

+ (NSData *)thumbnailWithImageWithoutScale:(UIImage *)image;
+ (NSData *)imageToData:(UIImage*)image;

@end
