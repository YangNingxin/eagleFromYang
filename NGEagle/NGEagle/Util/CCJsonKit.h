//
//  CCJsonKit.h
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCJsonKit : NSObject

+(NSString *)getJsonFromDictOrMuArr:(id)dict;
+(id)getObjectFromJsonString:(NSString *)strJson;

@end
