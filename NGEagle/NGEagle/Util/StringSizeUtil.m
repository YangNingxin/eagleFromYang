//
//  StringSizeUtil.m
//  PlanHelper
//
//  Created by zhangyihui on 14-7-22.
//  Copyright (c) 2014年 qyer. All rights reserved.
//

#import "StringSizeUtil.h"


@implementation StringSizeUtil


+(CGFloat)getContentSizeHeight:(NSString *)content font:(UIFont *)pFont width:(CGFloat)pWidth
{
    
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(pWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:pFont,NSFontAttributeName, nil] context:nil].size;
   
    return contentSize.height;
}

+(CGFloat)getContentSizeWidth:(NSString *)content font:(UIFont *)pFont height:(CGFloat)pHeight
{
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, pHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:pFont,NSFontAttributeName, nil] context:nil].size;
    return contentSize.width;
}

+ (CGFloat)getLineHeightWithFont:(UIFont *)font
{
    CGFloat lineHeight= [@"样本" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]].height;
    return lineHeight;
}

+ (BOOL)isStringContainChinese:(NSString *)string {
    
    for(int i=0; i< [string length];i++){
        
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end
