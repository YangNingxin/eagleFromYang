//
//  CCDownLoad.m
//  Eagle
//
//  Created by 张伊辉 on 14-2-24.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import "DownLoadHelper.h"

@implementation DownLoadHelper

+ (NSOperation *)downLoadFileWithURL:(NSString *)strURL
                        saveFilePath:(NSString *)saveFilePath
                           backBlock:(NetworkDownFileCallBack)callBack {
    //下载附件
    NSURL *url = [[NSURL alloc] initWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:url];
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:saveFilePath append:NO];
    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        callBack(0);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callBack(-1);
    }];
    
    [operation start];
    return operation;
}

@end
