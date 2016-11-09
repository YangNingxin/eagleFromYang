//
//  InputAudioView.m
//  NGEagle
//
//  Created by Liang on 16/4/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "InputAudioView.h"
#import "TimeUtil.h"
#import "GlobalManager.h"
#import "EGRecordAudio.h"
#import "FCFileManager.h"

@implementation InputAudioView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _statusImageView = [UIImageView new];
        _statusImageView.image = [UIImage imageNamed:@"voice_image"];
        [self addSubview:_statusImageView];
        
        [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(15);
        }];
        
        _timeLabel = [UILabel new];
        _timeLabel.text = @"00:00";
        _timeLabel.textColor = UIColorFromRGB(0x333333);
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_statusImageView);
        }];
        
        _statusLabel = [UILabel new];
        _statusLabel.text = @"按住说话";
        _statusLabel.textColor = UIColorFromRGB(0x333333);
        _statusLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(_timeLabel.mas_bottom).offset(10);
        }];
        
        _recordButton = [UIButton new];
        [_recordButton addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(touchUpinside) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(touchOutside) forControlEvents:UIControlEventTouchUpOutside];
        
        [_recordButton setImage:[UIImage imageNamed:@"audio_record"] forState:UIControlStateNormal];
        [self addSubview:_recordButton];
        
        [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(_statusLabel.mas_bottom).offset(10);
        }];
        
        _closeButton = [UIButton new];
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"blue_x"] forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(_recordButton.mas_bottom).offset(10);
        }];

        
    }
    return self;
    
}

// 开始录音
- (void)touchDown {
    NSLog(@"开始录音");
    if (![[GlobalManager shareManager] isUserPermissionAudio]) {
        [[GlobalManager shareManager] showAudioError];
        return;
    }
    _statusLabel.text = @"松开结束";
    NSString *filePath = [FCFileManager pathForCachesDirectoryWithPath:recordWavAudioName];
    [[EGRecordAudio shareEGRecordAudio] startRecordWithPath:filePath];
    _fileAudio = filePath;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                            selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction {
    _second ++;
    _timeLabel.text = [TimeUtil getMinWithSecond:_second];
}

- (void)touchUpinside {
    NSLog(@"松开结束");
    [self recordStop];
}

- (void)touchOutside {
    NSLog(@"outside");
    [self recordStop];
}

- (void)recordStop {
    
    double cTime = [EGRecordAudio shareEGRecordAudio].recorder.currentTime;
    [[EGRecordAudio shareEGRecordAudio] stopRecord];
    
    if (cTime < 0.5) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"录音时间太短！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        // 录音成功
        if (self.delegate) {
            [self.delegate finishRecord:_fileAudio audioSecond:cTime];
        }
    }

    _second = 0;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timeLabel.text = @"00:00";
    _statusLabel.text = @"按住说话";
}

- (void)closeAction {
    if (self.delegate) {
        [self.delegate closeInputview];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
