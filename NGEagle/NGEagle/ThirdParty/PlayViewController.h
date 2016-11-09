//
//  PlayViewController.h
//  Eagle
//
//  Created by 张伊辉 on 14-2-24.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface PlayViewController : UIViewController
{
}

// 本地资源选择得到的URL
@property (nonatomic, strong) NSURL *fileURL;
// 网络视频的URL
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) MPMoviePlayerController *player;

@end
