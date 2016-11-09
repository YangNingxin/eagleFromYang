//
//  EGMergeVideoAndAudio.h
//  Eagle
//
//  Created by 张伊辉 on 14-1-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>


typedef void (^CompletionBlock)();

@interface EGMergeVideoAndAudio : NSObject
//混合音频
+ (void)mergeVideo:(NSString *)videoPath andAudio:(NSString *)audioPath output:(NSString *)outPutPath comBlock:(CompletionBlock)completion;

//压缩视频
+ (void)compressionVideoWithOriginURL:(NSURL *)sourceURL newURL:(NSURL *)outputURL comBlock:(CompletionBlock)completion;
@end
