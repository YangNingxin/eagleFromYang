//
//  UIImageUtil.m
//  BaiduLibrary
//
//  Created by Liang on 14/12/2.
//  Copyright (c) 2014年 zhuayi inc. All rights reserved.
//

#import "UIImageUtil.h"
/**
 *  图片最大KB数
 */
static CGFloat const MaxImageLength = 150.0f;
static CGFloat const MaxImageSize = 1024;

@implementation UIImageUtil

+ (UIImage *)getScreenImage:(UIView *)theView
{
   
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(theView.bounds.size.width, theView.bounds.size.height), NO, 0);

    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    return viewImage;

}

+ (UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage{
    
    
    CGSize imageSize = firstImage.size;
    UIGraphicsBeginImageContext(imageSize);
    
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(0, 0, secondImage.size.width, secondImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

//遍历图片像素，更改图片颜色
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

+ (UIImage *)imageBlackToTransparent:(UIImage*)image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        
//        else
//        {
//            // 改成下面的代码，会将图片转成想要的颜色
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[3] = 0; //0~255
//            ptr[2] = 0;
//            ptr[1] = 0;
//            
//        }
        
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}

+ (UIImage *)thumbnailWithImage:(UIImage *)image {
    
    CGFloat width = 0;
    CGFloat height = 0;
    if (image.size.width > MaxImageSize || image.size.height > MaxImageSize) {
        if (image.size.width > image.size.height) {
            width = MaxImageSize;
            height = image.size.height / (image.size.width / width);
        }else{
            height = MaxImageSize;
            width = image.size.width / (image.size.height / height);
        }
    }
    UIImage *thumbnail = image;
    if (width > 0 && height > 0) {
        thumbnail = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(width, height)];
    }
    return thumbnail;
}

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    if (!image) {
        return nil;
    }
    
    CGSize oldsize = image.size;
    CGRect rect;
    if (asize.width/asize.height > oldsize.width/oldsize.height) {
        rect.size.width = asize.height*oldsize.width/oldsize.height;
        rect.size.height = asize.height;
        rect.origin.x = (asize.width - rect.size.width)/2;
        rect.origin.y = 0;
    }
    else{
        rect.size.width = asize.width;
        rect.size.height = asize.width*oldsize.height/oldsize.width;
        rect.origin.x = 0;
        rect.origin.y = (asize.height - rect.size.height)/2;
    }
    UIGraphicsBeginImageContext(asize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
    [image drawInRect:rect];
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

+ (NSData *)thumbnailWithImageWithoutScale:(UIImage *)image {
    CGFloat width = 0;
    CGFloat height = 0;
    if (image.size.width > MaxImageSize || image.size.height > MaxImageSize) {
        if (image.size.width > image.size.height) {
            width = MaxImageSize;
            height = image.size.height / (image.size.width / width);
        }else{
            height = MaxImageSize;
            width = image.size.width / (image.size.height / height);
        }
    }
    UIImage *thumbnail = image;
    if (width > 0 && height > 0) {
        thumbnail = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(width, height)];
    }
    return [self imageToData:thumbnail];
}

/**
 *  UIImage 转换成 NSData
 *
 *  @param image UIImage
 *
 *  @return NSData
 */
+ (NSData *)imageToData:(UIImage*)image {
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSInteger length = data.length / 1024;
    if (length < MaxImageLength) { //如果图片大小低于150k，直接返回，不需要压缩
        return data;
    }else{
        if (length > MaxImageLength && length < 500) {
            data = UIImageJPEGRepresentation(image, 0.6);
        }else if (length > 500 && length < 1000) {
            data = UIImageJPEGRepresentation(image, 0.5);
        }else if (length > 1000 && length < 1500){
            data = UIImageJPEGRepresentation(image, 0.3);
        }else if (length > 1500 && length < 2000){
            data = UIImageJPEGRepresentation(image, 0.1);
        }
    }
    return data;
}

@end
