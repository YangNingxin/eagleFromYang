//
//  EGPlayAudio.h
//  Eagle
//
//  Created by 张伊辉 on 14-1-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef void(^EGPlayAudioEndBlock)(void);
@interface EGPlayAudio : NSObject<AVAudioPlayerDelegate>
{

    EGPlayAudioEndBlock _block;
}

+(EGPlayAudio *)shareEGPlayAudio;
@property(nonatomic,strong)AVAudioPlayer *player;



-(void)playAudioWithPath:(NSString *)audioPath endPlay:(EGPlayAudioEndBlock)block;
-(void)setAudioPlayFinish:(EGPlayAudioEndBlock)block;


-(void)stopPlay;
-(void)pausePlay;


-(BOOL)isNowPlay;
@end
