//
//  VideoView.h
//  NGEagle
//
//  Created by Liang on 16/4/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaResourceDelegate.h"

@interface VideoView : UIButton

@property (nonatomic, strong) UIImageView *backVideo;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, weak) id <MediaResourceDelegate> delegate;

@end
