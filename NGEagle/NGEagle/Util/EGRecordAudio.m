//
//  EGRecordAudio.m
//  Eagle
//
//  Created by 张伊辉 on 14-1-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import "EGRecordAudio.h"

@implementation EGRecordAudio


#pragma mark - Publick Function
+(EGRecordAudio *)shareEGRecordAudio{
    
    static EGRecordAudio *shareRecord = nil;
    
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        shareRecord = [[EGRecordAudio alloc] init];
    });
    
    return shareRecord;
}



- (id)init
{
    self = [super init];
    if (self) {
        
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
//        [[AVAudioSession sharedInstance] setActive: YES error: nil];
//        UInt32 doChangeDefault = 1;
//        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
    }
    return self;
}


-(void)destroyRecord{
    

    
    [self.recorder stop];
    self.recorder = nil;
    self.recordPath = nil;
}

-(void)startRecordWithPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *fileError = nil;
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:&fileError];
    }
    if (fileError) {
        NSLog(@"fileErro %@", fileError);
    }
    
    NSError * err = nil;
    
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    


    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:8000],AVSampleRateKey,
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   nil];


    
    if(self.recorder){
        self.recordPath = nil;
        [self.recorder stop];
        self.recorder = nil;
    }
    self.recordPath = path;
	NSURL * url = [NSURL fileURLWithPath:self.recordPath];

	err = nil;
	self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    
	if(!_recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        return;
	}
	
	[_recorder setDelegate:self];
    [_recorder peakPowerForChannel:0];
	_recorder.meteringEnabled = YES;
    
    if ([_recorder prepareToRecord]) {
        
        [_recorder record];
    }
}


-(void) stopRecord{
    
    [self.recorder stop];
    self.recorder = nil;

}




#pragma mark audioDelegate

@end
