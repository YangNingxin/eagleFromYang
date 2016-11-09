//
//  NGMacro.h
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//
#import "BaseViewController.h"
#import "UIView+Util.h"
#import "NSNull+Safe.h"
#import "Config.h"
#import "Account.h"
#import "DataHelper.h"
#import "ChatDataHelper.h"
#import "UIView+Toast.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "EaseMob.h"
#import "CCJsonKit.h"

#import "NumberSchool.h"

//环信配置
#define HXAppKey @"zhihuijiaoyu#xuehu"

#if DEBUG
#define HXApnsCertName @"develop"
#else
#define HXApnsCertName @"product"
#endif

// 环信里面加好友，删除好友的系统逻辑
#define HXSystemAccount @"xuehu_admin"
#define HXDefaultPassword @"888888"

#define kCodeKey @"ZHXHEAGLE"

// 线上、下控制
#define IS_FORMAL 0

#if IS_FORMAL
#define API_SERVER @"http://m.snslearn.com"
#else
#define API_SERVER @"http://117.121.26.76"
#endif


/**
 *  友盟
 */
#define UMENG_APPKEY @"55a9c2a167e58e193e0034ff"

/**
 *  微信
 */
#define WX_APPID @"wx569d4a7f8a0328ca"
#define WX_APPSECRET @"5b3e36bd35d8e67206d5047d7f6f2e32"

/*
 *  QQ
 */
#define QQ_APPID @"1105251151"
#define QQ_APPSECRET @"kxir7IgfPRQeXkSb"
#define QQ_16APPID @"41E0CB4F"

#define WB_APPID @"1539890786"
#define WB_APPSECRET @"32703d2ec5d9ceef763fdf909f2c8b6b"

/*
 * 百度地图
 */
#define BaiduMap_appKey @"rE480Xv3DluDbOFH9mVQcbQv"
#define BaiduMap_secret @"uFv7U2QH2D6IqdMiak4tFUf4Gv17iWlw"


// 苹果地址
#define AppStoreURL @"https://itunes.apple.com/us/app/xue-hu/id866736486?l=zh&ls=1&mt=8"

// 登录成功之后的通知
#define kLoginNotification @"loginNotification"

//录音临时文件
#define recordWavAudioName @"eagle_dynamic_audio1.wav"
#define recordAmrAudioName @"eagle_dynamic_audio2.amr"
#define recordMp4VideoName @"eagle_dynamic_video2.mp4"

#define kNetWorkError @"请检查网络连接"




