//
//  Config.m
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "Config.h"
#import "BDDeviceUtil.h"
#import "KeychainItemWrapper.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import <BaiduMapAPI/BMapKit.h>
#import "UMSocialSinaSSOHandler.h"

@implementation Config

/**
 *  配置设备唯一标记
 */
+ (void)configDeviceUUID
{
    /**
     *  得到设备唯一的标示符
     */
    KeychainItemWrapper *keyItem = [[KeychainItemWrapper alloc]
                                    initWithIdentifier:@"COM.EAGLE.XUEHU" accessGroup:NULL];
    
    NSString *str = [keyItem objectForKey:(__bridge id)(kSecAttrAccount)];
    if (str && ![str isEqualToString:@""] && [str length]>0) {
        [BDDeviceUtil mainDevice].deviceUUID = str;
    }else{
        NSString *uuid = [BDDeviceUtil generatUUID];
        [keyItem setObject:uuid forKey:(__bridge id)(kSecAttrAccount)];
        [BDDeviceUtil mainDevice].deviceUUID = uuid;
    }
    NSLog(@"测试是否是唯一标示：%@",[BDDeviceUtil mainDevice].deviceUUID);
    
}

+ (void)umengTrack {
    
    // 启动微信
    [WXApi registerApp:WX_APPID];
    
    // 把分享平台加入友盟列表
//    [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_APPSECRET url:@"http://www.snslearn.com"];
//    [UMSocialQQHandler setQQWithAppId:QQ_APPID appKey:QQ_APPSECRET url:@"http://www.snslearn.com"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WB_APPID
                                              secret:WB_APPSECRET
                                         RedirectURL:@"http://www.snslearn.com"];
    
    [UMSocialData setAppKey:UMENG_APPKEY];

    
    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) BATCH channelId:@"App Store"];
}

+ (void)configBaiduMap {
    BMKMapManager *_mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiduMap_appKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}


@end
