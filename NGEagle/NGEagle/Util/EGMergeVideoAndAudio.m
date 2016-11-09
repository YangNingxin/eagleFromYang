//
//  EGMergeVideoAndAudio.m
//  Eagle
//
//  Created by 张伊辉 on 14-1-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import "EGMergeVideoAndAudio.h"

@implementation EGMergeVideoAndAudio

+ (void)mergeVideo:(NSString *)videoPath andAudio:(NSString *)audioPath output:(NSString *)outPutPath comBlock:(CompletionBlock)completion{
    
    
    NSURL *audioUrl=[NSURL fileURLWithPath:audioPath];
	NSURL *videoUrl=[NSURL fileURLWithPath:videoPath];
	
	AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
	AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
	
	//混合音乐
	AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
	AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
																						preferredTrackID:kCMPersistentTrackID_Invalid];
	[compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
										ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
										 atTime:kCMTimeZero error:nil];
	
	
	//混合视频
	AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
																				   preferredTrackID:kCMPersistentTrackID_Invalid];
	[compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
								   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
									atTime:kCMTimeZero error:nil];
	AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
																		  presetName:AVAssetExportPresetPassthrough];
	
    
	//保存混合后的文件的过程
	
    
	NSURL *exportUrl = [NSURL fileURLWithPath:outPutPath];
	
    
	_assetExport.outputFileType = @"com.apple.quicktime-movie";
	NSLog(@"file type %@",_assetExport.outputFileType);
	_assetExport.outputURL = exportUrl;
	_assetExport.shouldOptimizeForNetworkUse = YES;
	
	[_assetExport exportAsynchronouslyWithCompletionHandler:
	 ^(void )
     {
         dispatch_async(dispatch_get_main_queue(), completion);
        
     }];
    
}

+(void)compressionVideoWithOriginURL:(NSURL *)sourceURL newURL:(NSURL *)outputURL comBlock:(CompletionBlock)completion{
    
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSLog(@"compatiblePresets is %@",compatiblePresets);
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        
        
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusCompleted:
                     
                     dispatch_async(dispatch_get_main_queue(), completion);

                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
             }
         }];
    }
}
@end
