//
//  NSDataHelper.m
//  NGEagle
//
//  Created by Liang on 15/8/24.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NumberSchoolDataHelper.h"

@implementation NumberSchoolDataHelper

/**
 *  获取访问令牌
 *
 *  @param code          授权码
 *  @param client_id     注册APP时获得的应用标识号
 *  @param client_secret 注册APP时获得的密钥
 *  @param grant_type    固定为authorization_code；
 *  @param redirect_uri  必须与注册此APP时提交的redirect_uri一致
 *  @param state         任意字符串
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getNSAccessTokenByCode:(NSString *)code
                              client_id:(NSString *)client_id
                          client_secret:(NSString *)client_secret
                             grant_type:(NSString *)grant_type
                           redirect_uri:(NSString *)redirect_uri
                                  state:(NSString *)state
                              serverURL:(NSString *)serverURL
                                success:(BdRequestSuccess)successBlock
                                   fail:(BdRequestFail)failBlock {
    
    NSString *url = serverURL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    [parameters setObject:code forKey:@"code"];
    [parameters setObject:client_id forKey:@"client_id"];
    [parameters setObject:client_secret forKey:@"client_secret"];
    [parameters setObject:grant_type forKey:@"grant_type"];
    [parameters setObject:NS_Redirect_Uri forKey:@"redirect_uri"];
    [parameters setObject:state forKey:@"state"];
    
    NSOperation *operation = [BaseHttpRequest POST:url parameters:parameters fileParameters:nil success:^(id responseObject) {
        successBlock([self praseClassData:@"AccessToken"
                           responseObject:responseObject]);
    } failure:failBlock];
    return operation;
    
}

@end

@implementation AccessToken

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end