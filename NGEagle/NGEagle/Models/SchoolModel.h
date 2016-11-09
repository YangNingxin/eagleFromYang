//
//  SchoolModel.h
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorModel.h"


@protocol SchoolInfo

@end


@interface SchoolModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<SchoolInfo>* data;

@end

@interface SchoolInfo : JSONModel


@property (nonatomic, copy) NSString *streamin;

@property (nonatomic, copy) NSString *sso;

@property (nonatomic, copy) NSString *city_id;

@property (nonatomic, copy) NSString *district_id;

@property (nonatomic, copy) NSString *ctime;

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, copy) NSString *cert_key;

@property (nonatomic, copy) NSString *logo_md;

@property (nonatomic, copy) NSString *province_id;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *school_id;

@property (nonatomic, copy) NSString *admin_id;

@property (nonatomic, copy) NSString *mtime;

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *sync_info;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *school_name;

@property (nonatomic, copy) NSString *domain;

@property (nonatomic, copy) NSString *node_id;

@property (nonatomic, copy) NSString *auth_type;

@property (nonatomic, copy) NSString *port;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *streamout;

@property (nonatomic, copy) NSString *exserver;

@property (nonatomic, copy) NSString *star;

@property (nonatomic, copy) NSString *copyleft;
@property (nonatomic, strong) NSString *logo;

@property (nonatomic, strong) NSString *server;

@end

