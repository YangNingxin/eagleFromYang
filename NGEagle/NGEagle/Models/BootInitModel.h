//
//  BootInitModel.h
//  NGEagle
//
//  Created by Liang on 15/8/25.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ErrorModel.h"

@class Upgrade;

@protocol OtherLogin
@end

@interface BootInitModel : ErrorModel

@property (nonatomic, strong) Upgrade *upgrade;
@property (nonatomic, strong) NSArray *cover_images;
@property (nonatomic, strong) NSArray<OtherLogin> *other_login;

@end


@interface Upgrade : JSONModel

@property (nonatomic, strong) NSString *package_url;
@property (nonatomic) BOOL type;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *upmsg;

@end


@interface OtherLogin : JSONModel

@property (nonatomic, strong) NSString *channel;    //"shuzixuexiao",
@property (nonatomic, strong) NSString *name;       //"北京市数字学校",
@property (nonatomic, strong) NSString *node_id;    //"102",
@property (nonatomic, strong) NSString *client_id;  //"10000012",
@property (nonatomic, strong) NSString *client_secret;//"0a56a5cffdcf11e494cd0050568c7628",
@property (nonatomic, strong) NSString *auth_url;   //"http://api.idgrow.com/ajt/oauth/Auth.a",
@property (nonatomic, strong) NSString *token_url;  //"http://api.idgrow.com/ajt/oauth/Token.a",
@property (nonatomic, strong) NSString *scope;      //"user_get_info|student_get_info"

@end