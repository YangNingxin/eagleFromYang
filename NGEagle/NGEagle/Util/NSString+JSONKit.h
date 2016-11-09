//
//  NSString+JSONKit.h
//  NGEagle
//
//  Created by Liang on 15/7/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

- (id)jsonValue;
- (NSString *)valueJson:(id)object;

@end
