//
//  NSDataHelper.h
//  NGEagle
//
//  Created by Liang on 15/8/24.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "DataHelper.h"

/**
 *  数字学校接口请求
 */
@interface NumberSchoolDataHelper : DataHelper

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
                                   fail:(BdRequestFail)failBlock;


@end


@interface AccessToken : JSONModel
/**
 *  token
 */
@property (nonatomic, strong) NSString *access_token;

/**
 *  过期时间
 */
@property (nonatomic, strong) NSString *expires_in;

/**
 *  用户ID
 */
@property (nonatomic, strong) NSString *userid;

@end