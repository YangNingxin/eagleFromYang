//
//  GlobalUtil.h
//  Hug
//
//  Created by Liang on 15/12/26.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^handleCamerAuthor)(BOOL isAccess);

@interface GlobalManager : NSObject

+ (GlobalManager *)shareManager;


/**
 *  用户是否允许语音
 *
 *  @return
 */
- (BOOL)isUserPermissionAudio;

/**
 *  获取自定义相机、相册权限
 *
 *  @param handleCamerBlock
 */
- (void)getUserAccessCamer:(handleCamerAuthor)handleCamerBlock;

- (void)showCamerError;
- (void)showAudioError;

@end
