//
//  EGRecordAudio.h
//  Eagle
//
//  Created by 张伊辉 on 14-1-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^CompletionBlock)();

@interface EGRecordAudio : NSObject<AVAudioRecorderDelegate>
{

}
+(EGRecordAudio *)shareEGRecordAudio;

@property(nonatomic,strong) AVAudioRecorder *recorder;
@property(nonatomic,strong) NSString * recordPath;


-(void) startRecordWithPath:(NSString *)path;
-(void) stopRecord;
-(void) cancelled;
@end
