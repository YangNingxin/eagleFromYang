//
//  BaseHttpRequest.m
//  BaiduLibrary
//
//  Created by zhuayi on 14/10/21.
//  Copyright (c) 2014年 zhuayi inc. All rights reserved.
//

#import "BaseHttpRequest.h"
#import "BDDeviceUtil.h"
#import "Macro.h"

#define BD_LOGIC_COOKIE @"BdlogicCookie"

@implementation BaseHttpRequest

+ (NSMutableDictionary *)requestDeviceParameters
{
    NSMutableDictionary *deviceData = [NSMutableDictionary  dictionary];
    NSString *token = [Account shareManager].userModel.token;
    if (token) {
        [deviceData setObject:token forKey:@"token"];
    }
    if ([Account shareManager].userModel.user.uid) {
        [deviceData setObject:[Account shareManager].userModel.user.uid forKey:@"user_id"];
    }
    [deviceData setObject:APP_VERSION forKey:@"app_version"];
    [deviceData setObject:CurrentSystemVersion forKey:@"os_version"];
    [deviceData setObject:[BDDeviceUtil mainDevice].deviceUUID forKey:@"device_id"];
    return deviceData;
}

+ (NSOperation *)GET:(NSString *)url
          parameters:(NSDictionary *)parameters
             success:(BdRequestSuccess)success
             failure:(BdRequestFail)failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    NSMutableDictionary * data = [self requestDeviceParameters];
    if (parameters) {
        [data addEntriesFromDictionary:parameters];
    }
        
    AFHTTPRequestOperation *operation = [manager GET:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    NSLog(@"requestUrl === %@",operation.request.URL.absoluteString);
    return operation;
}

+ (NSOperation *)POST:(NSString *)url
           parameters:(NSDictionary *)parameters
       fileParameters:(NSDictionary *)fileParameters
              success:(BdRequestSuccess)success
              failure:(BdRequestFail)failure {
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];

    
    NSMutableDictionary * data = [self requestDeviceParameters];
    [data addEntriesFromDictionary:parameters];
    
    AFHTTPRequestOperation *operation = [manager POST:url parameters:data constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (fileParameters) {
            
            NSData *data = [fileParameters objectForKey:@"file"];
            NSString *fileName = @"";
            if (data) {
                if ([fileParameters objectForKey:@"fileName"]) {
                    fileName = [fileParameters objectForKey:@"fileName"];
                }
                [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"image/jpg/file"];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    return operation;
}

+ (NSOperation *)POST:(NSString *)url
           parameters:(NSDictionary *)parameters
            fileArray:(NSArray *)fileArray
              success:(BdRequestSuccess)success
              failure:(BdRequestFail)failure {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    
    NSMutableDictionary * data = [self requestDeviceParameters];
    [data addEntriesFromDictionary:parameters];
    
    AFHTTPRequestOperation *operation = [manager POST:url parameters:data constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (fileArray) {
            
            for (NSDictionary *fileParameters in fileArray) {
                NSData *data = [fileParameters objectForKey:@"file"];
                NSString *fileName = @"";
                if (data) {
                    if ([fileParameters objectForKey:@"fileName"]) {
                        fileName = [fileParameters objectForKey:@"fileName"];
                    }
                    [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"image/jpg/file"];
                }
            }            
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    return operation;
}

@end
