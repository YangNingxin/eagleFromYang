//
//  AudioView.h
//  NGEagle
//
//  Created by Liang on 16/4/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaResourceDelegate.h"

@interface AudioView : UIButton

@property (nonatomic, strong) UIImageView *backAudio;
@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, weak) id <MediaResourceDelegate> delegate;

/**
 *  控制语音的播放
 *
 *  @param status 0正常，1加载中，2正在播放
 */
- (void)handleView:(int)status;

@end
