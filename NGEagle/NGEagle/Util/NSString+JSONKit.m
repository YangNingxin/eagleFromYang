//
//  NSString+JSONKit.m
//  NGEagle
//
//  Created by Liang on 15/7/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NSString+JSONKit.h"

@implementation NSString (JSON)

- (id)jsonValue {
    
    NSError *error;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    return object;
}

- (NSString *)valueJson:(id)object {
    if (object == nil) {
        return @"";
    }else{
        if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
            NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        }
    }
    return @"";
}

@end
