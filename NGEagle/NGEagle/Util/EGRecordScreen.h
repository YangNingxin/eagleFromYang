//
//  EGRecordScreen.h
//  GetVideo
//
//  Created by 张伊辉 on 14-1-20.
//  Copyright (c) 2014年 apple . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^CompletionBlock)();

@interface EGRecordScreen : NSObject
{
    
    
}
+ (EGRecordScreen *)sharedViewVideoHandler;

- (void) startScreenRecordingWithFilePath:(NSString *)filePath;
- (void) stopScreenRecordingWithCompletionBlock:(CompletionBlock)completion;

@property (nonatomic, strong) UIImage *currentScreen;

//video writing
@property (nonatomic, strong) AVAssetWriter *videoWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *avAdaptor;

@property (nonatomic, strong) NSString *videoPath;

//recording state
@property (nonatomic) BOOL isRecording;
@property (nonatomic, strong) NSDate *startedAt;
@property (nonatomic) void* bitmapData;
@end
