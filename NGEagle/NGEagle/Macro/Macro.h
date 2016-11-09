//
//  Macro.h
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NGMacro.h"
#import "NGApiMacro.h"

// 屏蔽NSLog
#ifdef DEBUG
#define  NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#define NavigationBar_HEIGHT 64

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0

// ios系统版本
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

// 项目版本号
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

/**
 *  block引用
 */
#if !__has_feature(objc_arc)
#define BlockWeakObject(obj, wobj) __block __typeof__((__typeof__(obj))obj) wobj = obj
#define BlockStrongObject(obj, sobj) __typeof__((__typeof__(obj))obj) sobj = [[obj retain] autorelease]
#else // !__has_feature(objc_arc)
#define BlockWeakObject(obj, wobj) __weak __typeof__((__typeof__(obj))obj) wobj = obj
#define BlockStrongObject(obj, sobj) __typeof__((__typeof__(obj))obj) sobj = obj
#endif // !__has_feature(objc_arc)

#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication]delegate])

//  判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//定义iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//定义iphone6+
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6PlusScale ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

//根据不同的设备，定义不同的大小
#define AutoSizeScale (iPhone6PlusScale ? (1.17) : iPhone6Plus ? (1.29375) : (iPhone6 ? (1.17) : 1))
#define AutoSize(size) AutoSizeScale*size

// 弱引用
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

#define kThemeColor UIColorFromRGB(0x04afff)