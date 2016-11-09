//
//  AppDelegate.h
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BootInitModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate>
{
    // 环信连接状态
    EMConnectionState _connectionState;
    
    /**
     *  是否处于后台
     */
    BOOL _isInBackGround;
}

@property (strong, nonatomic) UIWindow *window;

/**
 *  开机启动数据
 */
@property (nonatomic, strong) BootInitModel *bootModel;

@end

