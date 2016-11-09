//
//  EGRecordScreen.m
//  GetVideo
//
//  Created by 张伊辉 on 14-1-20.
//  Copyright (c) 2014年 apple . All rights reserved.
//

#import "EGRecordScreen.h"


#import <QuartzCore/QuartzCore.h>

@interface EGRecordScreen(Private)
- (void) writeVideoFrameAtTimeThread;
@end

@implementation EGRecordScreen

static EGRecordScreen *_sharedViewVideoHandler = nil;


- (UIImage*)screenImage {
    //Get Image Context *not checked on retina devices but i think it works..
    if([[UIScreen mainScreen]scale] > 1.5) {
        UIGraphicsBeginImageContextWithOptions([[UIApplication sharedApplication]keyWindow].bounds.size, NO, 1.0);
    } else {
        UIGraphicsBeginImageContext([[UIApplication sharedApplication]keyWindow].bounds.size);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[[UIApplication sharedApplication]keyWindow].layer renderInContext:context];
    
   
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshotImage;
}

+ (EGRecordScreen *)sharedViewVideoHandler {
    
    
    static EGRecordScreen *shareViewVideo = nil;
    
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        shareViewVideo = [[self alloc] init];
    });
    
    return shareViewVideo;
}

- (void) initialize {
    
    self.currentScreen = nil;
	self.isRecording = NO;
	self.videoWriter = nil;
	self.videoWriterInput = nil;
	self.avAdaptor = nil;
	self.startedAt = nil;
	self.bitmapData = NULL;
}

- (id) init {
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

// get screenshot images afterDelay:0.5(change afterDelay time as your requirement currently it capture 2 screenshot each second) and write it to video (writeVideoFrameAtTimeThread)
- (void) makeVideoFrame {
    if (self.isRecording) {
        UIImage *screenShotImg = [self screenImage];
        self.currentScreen = screenShotImg;
        
        dispatch_queue_t backgroundMethod = dispatch_queue_create("backgroundMethod", NULL);
        dispatch_sync(backgroundMethod, ^(void) {
            [self writeVideoFrameAtTimeThread];
            [self performSelector:@selector(makeVideoFrame) withObject:nil afterDelay:0.1];
        });
    }
}

- (void) cleanupWriter {
	self.avAdaptor = nil;
	self.videoWriterInput = nil;
	self.videoWriter = nil;
	self.startedAt = nil;
	if (self.bitmapData != NULL) {
		free(self.bitmapData);
		self.bitmapData = NULL;
	}
}

// temp file path/URL for video write and storage
- (NSURL*) tempFileURL {
    
    
    

	NSURL* videoURL = [[NSURL alloc] initFileURLWithPath:self.videoPath];
    
	NSFileManager* fileManager = [NSFileManager defaultManager];
    
	if ([fileManager fileExistsAtPath:self.videoPath]) {
        
		NSError* error;
        if ([fileManager isDeletableFileAtPath:self.videoPath]) {
            //delete video if already exit at videoPath
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:&error];
            if (!success) {
                NSLog(@"Could not delete old recording file at path:  %@", self.videoPath);
            }
        }
	}
	return videoURL;
}

- (BOOL) setUpWriter {
    
    
	NSError *error = nil;
	self.videoWriter = [[AVAssetWriter alloc] initWithURL:[self tempFileURL] fileType:AVFileTypeQuickTimeMovie error:&error];
	NSParameterAssert(self.videoWriter);
	
	//Configure video
	NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1024.0*1024.0], AVVideoAverageBitRateKey,nil ];
    
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
								   AVVideoCodecH264, AVVideoCodecKey,
								   [NSNumber numberWithInt:[[UIApplication sharedApplication] keyWindow].bounds.size.width], AVVideoWidthKey,
								   [NSNumber numberWithInt:[[UIApplication sharedApplication] keyWindow].bounds.size.height], AVVideoHeightKey,
								   videoCompressionProps, AVVideoCompressionPropertiesKey,
								   nil];
	
	self.videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
	
	NSParameterAssert(self.videoWriterInput);
	self.videoWriterInput.expectsMediaDataInRealTime = YES;
	NSDictionary* bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey, nil];
	
	self.avAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.videoWriterInput sourcePixelBufferAttributes:bufferAttributes];
	
    
	//add input
	[self.videoWriter addInput:self.videoWriterInput];
    
    
	[self.videoWriter startWriting];
	[self.videoWriter startSessionAtSourceTime:CMTimeMake(0, 1000)];
	return YES;
}



- (void) startScreenRecordingWithFilePath:(NSString *)filePath{
    bool result = NO;
    
    if (!self.isRecording) {
        
        self.videoPath = filePath;
        result = [self setUpWriter];
        
        self.startedAt = [NSDate date];
        self.isRecording = YES;
        [self makeVideoFrame];
    }
   
}


- (void) stopScreenRecordingWithCompletionBlock:(CompletionBlock)completion {
    
    if (self.isRecording) {
        self.isRecording = NO;

        [self.videoWriterInput markAsFinished];
        // Wait for the video
        int status = self.videoWriter.status;
        while (status == AVAssetWriterStatusUnknown) {
            [NSThread sleepForTimeInterval:0.5f];
            status = self.videoWriter.status;
        }
        @synchronized(self) {
            
            [self.videoWriter finishWritingWithCompletionHandler:^{
                
                dispatch_async(dispatch_get_main_queue(), completion);
                
                [self cleanupWriter];
            }];
           
        }
    }
    
   
}

//write video
- (void) writeVideoFrameAtTimeThread {
    
    float millisElapsed = [[NSDate date] timeIntervalSinceDate:self.startedAt] * 1000.0;
    
    CMTime time = CMTimeMake((int)millisElapsed, 1000);
    
	if (![self.videoWriterInput isReadyForMoreMediaData]) {
		NSLog(@"Not ready for video data");
	} else {
		@synchronized (self) {
            
			UIImage *newFrame = self.currentScreen;
			CVPixelBufferRef pixelBuffer = NULL;
			CGImageRef cgImage = CGImageCreateCopy([newFrame CGImage]);
			CFDataRef image = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
			
			int status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, self.avAdaptor.pixelBufferPool, &pixelBuffer);
			if(status != 0){
				//could not get a buffer from the pool
				NSLog(@"Error creating pixel buffer:  status=%d", status);
			}
			// set image data into pixel buffer
			CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
			uint8_t* destPixels = CVPixelBufferGetBaseAddress(pixelBuffer);
			CFDataGetBytes(image, CFRangeMake(0, CFDataGetLength(image)), destPixels);  //  will work if the pixel buffer is contiguous and has the same bytesPerRow as the input data
			if(status == 0){
				BOOL success = [self.avAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:time];
				if (!success)
					NSLog(@"Warning:  Unable to write buffer to video");
			}
			//clean up
			CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
			CVPixelBufferRelease( pixelBuffer );
			CFRelease(image);
			CGImageRelease(cgImage);
		}
	}
}

@end

