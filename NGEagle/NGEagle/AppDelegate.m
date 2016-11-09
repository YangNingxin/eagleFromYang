//
//  AppDelegate.m
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import "CLoginViewController.h"
#import "DataHelper.h"
#import "NGTabBarViewController.h"
#import "EditUserInfoViewController.h"
#import "TMCache.h"
#import "UMSocialSnsService.h"
#import "BindPhoneViewController.h"
#import "AppDelegate+EaseMob.h"
#import "LeftMenuViewController.h"
#import "WTAZoomNavigationController.h"
#import "IQKeyboardManager.h"

@interface AppDelegate () <UIAlertViewDelegate>
{
    CLoginViewController *homeVc;
    UINavigationController *nav;
    LeftMenuViewController *leftMenuVc;
    WTAZoomNavigationController *zoomNavigationController;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 启动开机接口
    [self bootRequestFromServer];
    [self customizeAppearance];

    //1. 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 如果没有登录
    if (![Account shareManager].isLogined) {
        [self setRootToLoginViewController];
        
    } else {
        
        UserModel *userModel = [[TMCache sharedCache] objectForKey:@"userModel"];
        if (userModel) {
            [Account shareManager].userModel = userModel;
//            [DataHelper setCookie];
            
            // 开启用户自动登录
            [self startAutoLogin];
            [self setRootToTabBarController];
            
        } else {
            
            // 这种情况就是异常，用户通过其他渠道，把加密的文件给删除了，那就只能重新登录了
            [self setRootToLoginViewController];
        }
    }
    
    
    // 配置唯一ID
    [Config configDeviceUUID];
    
    // 开启友盟检测
    [Config umengTrack];
    
    // 百度地图
    [Config configBaiduMap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginActionWithType:) name:kLoginNotification object:nil];
    
    [self.window makeKeyAndVisible];

    // Override point for customization after application launch.
    return YES;
}

- (void)loginActionWithType:(NSNotification *)aNote {
    
    /**
     *  type=0登录成功，type=1退出登录，type=2注册成功，type=3登录失败
     */
    int type = [[aNote object] intValue];
    
    if (type == 0) {
        @autoreleasepool {
            nav = nil;
            self.window.rootViewController = nil;
        }
        [self setRootToTabBarController];
        
    } else if (type == 1) {
        
        @autoreleasepool {
            zoomNavigationController = nil;
            self.window.rootViewController = nil;
        }
        [self setRootToLoginViewController];
        
        // 设置退出登录
        [[Account shareManager] setIsLogined:NO];
        
    } else if (type == 2){
        [self setRootToTabBarController];
        
        EditUserInfoViewController *editVc = [[EditUserInfoViewController alloc] initWithNibName:@"EditUserInfoViewController" bundle:nil];
        [self.window.rootViewController presentViewController:editVc animated:YES completion:nil];
        
    } else {
        
    }
}

// 设置登录为root
- (void)setRootToLoginViewController {
    if (!homeVc) {
        homeVc = [[CLoginViewController alloc] initWithNibName:@"CLoginViewController" bundle:nil];
        nav = [[UINavigationController alloc] initWithRootViewController:homeVc];
        nav.navigationBarHidden = YES;
    }
    self.window.rootViewController = nav;
}

// 设置tabbar为root
- (void)setRootToTabBarController {
    if (!leftMenuVc) {
        
        leftMenuVc = [[LeftMenuViewController  alloc] init];
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:leftMenuVc];
        nav2.navigationBarHidden = YES;
        zoomNavigationController = [[WTAZoomNavigationController alloc] init];
        [zoomNavigationController setSpringAnimationOn:NO];
        [zoomNavigationController setLeftViewController:nav2];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_jpg@2x.jpg"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        [zoomNavigationController setBackgroundView:imageView];

    }
    self.window.rootViewController = zoomNavigationController;
}


// 配置nav
- (void)customizeAppearance{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
      NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:17.0],
      NSFontAttributeName, nil]];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

//    [[UIBarButtonItem appearance] setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor whiteColor],NSForegroundColorAttributeName,
//      nil]forState:UIControlStateNormal];
    
}

/**
 *  开启自动登录
 */
- (void)startAutoLogin {
    
    int markTimeInterval = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"timeIntervalForLogin"];
    int timeInterval = [[NSDate date] timeIntervalSince1970];
    
    if (markTimeInterval != 0) {

        if ((timeInterval - markTimeInterval) / 3600 <= 1) {
            return;
        }
    }
    
    User *currentUser = [Account shareManager].userModel.user;
    
    [DataHelper loginByNode:currentUser.node_id
                   username:currentUser.username
                   password:currentUser.password
                         ey:NO
                    success:^(id responseObject) {
                        [self loginSuccess:responseObject];
                        
                    } fail:^(NSError *error) {
                        
                    }];
    
    [[NSUserDefaults standardUserDefaults] setInteger:timeInterval forKey:@"timeIntervalForLogin"];
}

- (void)loginSuccess:(UserModel *)responseObject {
    
    NSLog(@"autoLogin *************** %@", responseObject);
    
    // 要退出重新登录的
    if (responseObject && responseObject.error_code == 10001) {
        
        // 退出环信
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (!error) {
                
            }
        } onQueue:nil];
        
        // 退出账号
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(1)];

        // 提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"由于账号可能存在风险，需要重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    if (responseObject && responseObject.error_code == 0 && responseObject.user && responseObject.user.uid.length > 0) {
        
        // 通过Account账号单例，存储登录信息
        [Account shareManager].userModel.token = responseObject.token;
        
        // 缓存登录信息到本地，加密过的
        [[TMCache sharedCache] setObject:[Account shareManager].userModel forKey:@"userModel"];
        
    }
}

/**
 *  开机接口
 */
- (void)bootRequestFromServer {
   
    [DataHelper getBootData:^(id responseObject) {
        BootInitModel *model = responseObject;
        if (model.error_code == 0) {
            self.bootModel = model;
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)setBootModel:(BootInitModel *)bootModel {
    _bootModel = bootModel;
    if (_bootModel.upgrade.type == 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:_bootModel.upgrade.upmsg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if (APPDELEGATE.bootModel.other_login.count > 0) {
        OtherLogin *otherLogin = APPDELEGATE.bootModel.other_login[0];
        if ([otherLogin.channel isEqualToString:NS_Channel]) {
            
            if (homeVc) {
                [homeVc showShuzixuexiaoLoginButton:YES];
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    _isInBackGround = YES;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    _isInBackGround = NO;
    
    [self bootRequestFromServer];
    [self startAutoLogin];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([Account shareManager].isLogined) {
        [[Account shareManager] getCourseMessageNumber];
        [[Account shareManager] getUnReadMessageNumber];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.bootModel.upgrade.package_url]];
}

@end
