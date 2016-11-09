//
//  EGPlayAudio.m
//  Eagle
//
//  Created by 张伊辉 on 14-1-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import "EGPlayAudio.h"

@implementation EGPlayAudio


+(EGPlayAudio *)shareEGPlayAudio{
    
    
    static EGPlayAudio *_sharedClass = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedClass = [[EGPlayAudio alloc] init];
    });
    
    return _sharedClass;
    
}
- (id)init
{
    self = [super init];
    if (self) {
        
        
        //初始化播放器的时候如下设置
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(sessionCategory),
                                &sessionCategory);
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                 sizeof (audioRouteOverride),
                                 &audioRouteOverride);
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
       // audioSession = nil;
        
       
    }
    return self;
}

-(void)setAudioPlayFinish:(EGPlayAudioEndBlock)block{
    
    _block = block;
}
//播放之前，先判断，是否存在视频正在播放，如果是的话，stop并且销毁对象self.player
-(void)playAudioWithPath:(NSString *)audioPath endPlay:(EGPlayAudioEndBlock)block{

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应

    _block = block;
    NSLog(@"audioPath1 is %@",audioPath);
    if (self.player) {
        
        [self.player stop];
        self.player = nil;
    }
    NSLog(@"audioPath2 is %@",audioPath);

    NSError *errror;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:&errror];
    self.player.delegate = self;
    NSLog(@"audioPath3 is %@",audioPath);
    [self.player setVolume:1];

    [self.player prepareToPlay];
    [self.player play];
    
    NSLog(@"audioPath4 is %@",errror);

}
-(void)stopPlay{
    
    [self.player stop];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
}
-(void)pausePlay{
    
    [self.player pause];
}


-(BOOL)isNowPlay{
    
    return [self.player isPlaying];
}


#pragma mark audioDelegate
//音频播放完成之后需调用的方法。
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    _block();
}
@end
