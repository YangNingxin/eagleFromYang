//
//  CCJsonKit.m
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CCJsonKit.h"

@implementation CCJsonKit

+(NSString *)getJsonFromDictOrMuArr:(id)dict{
        
    if (dict == nil) {
        return @"";
    }else{
        
        if ([dict isKindOfClass:[NSDictionary class]]||[dict isKindOfClass:[NSArray class]]) {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        }
    }
    return @"";
    
}

+(id)getObjectFromJsonString:(NSString *)strJson{
    
    
    
    NSError *error;
    NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    return object;
}

@end
