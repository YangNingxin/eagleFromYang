//
//  GlobalUtil.m
//  Hug
//
//  Created by Liang on 15/12/26.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "GlobalManager.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static GlobalManager *shareManager = nil;

@implementation GlobalManager

+ (GlobalManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[GlobalManager alloc] init];
    });
    return shareManager;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)isUserPermissionAudio {
    
    __block BOOL flag = NO;
    dispatch_semaphore_t sema =  dispatch_semaphore_create(0);
    //这个方法只有ios7才有
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            flag = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    } else {
        flag = YES;
    }
    return flag;
}

- (void)getUserAccessCamer:(handleCamerAuthor)handleCamerBlock {
    
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
    if(authStatus == AVAuthorizationStatusRestricted) {
        NSLog(@"Restricted");
    } else if (authStatus == AVAuthorizationStatusDenied) {
        // The user has explicitly denied permission for media capture.
        NSLog(@"Denied");
        [self showCamerError];

    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        //允许访问
        // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
        NSLog(@"Authorized");
        handleCamerBlock(YES);
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined) {
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
                handleCamerBlock(YES);
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
                [self showCamerError];
                handleCamerBlock(NO);
            }
        }];
    }

}

- (void)showCamerError {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //应该是这个，如果不允许的话
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的“设置-隐私-相机”中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    });
}

- (void)showAudioError {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设备的“设置-隐私-麦克风”选项中，允许访问麦克风。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
