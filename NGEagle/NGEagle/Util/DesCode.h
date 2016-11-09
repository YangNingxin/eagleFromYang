//
//  DesCode.h
//  NGEagle
//
//  Created by Liang on 15/8/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesCode : NSObject

+ (NSString *)desEncryptWithString:(NSString *)string;

+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

@end
