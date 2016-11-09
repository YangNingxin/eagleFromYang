//
//  CCDownLoad.h
//  Eagle
//
//  Created by 张伊辉 on 14-2-24.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

/**
 *  下载网络文件
 *
 *  @param status 状态0：OK 1：Fail
 */
typedef void (^NetworkDownFileCallBack)(int status);

@interface DownLoadHelper : NSObject

+ (NSOperation *)downLoadFileWithURL:(NSString *)strURL
                        saveFilePath:(NSString *)saveFilePath
                           backBlock:(NetworkDownFileCallBack)callBack;

@end
