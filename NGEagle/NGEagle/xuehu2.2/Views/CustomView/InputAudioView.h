//
//  InputAudioView.h
//  NGEagle
//
//  Created by Liang on 16/4/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputAudioViewDelegate <NSObject>

- (void)finishRecord:(NSString *)filePath audioSecond:(int)audioSecond;
- (void)closeInputview;

@end

@interface InputAudioView : UIView
{
    UILabel *_statusLabel;
    
    UIImageView *_statusImageView;
    UILabel *_timeLabel;
    
    UIButton *_recordButton;
    UIButton *_closeButton;
    NSTimer *_timer;
    int _second;
    
    NSString *_fileAudio;
}

@property (nonatomic, weak) id <InputAudioViewDelegate> delegate;

@end
