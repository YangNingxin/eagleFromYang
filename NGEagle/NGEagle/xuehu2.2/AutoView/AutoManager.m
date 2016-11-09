//
//  AutoManager.m
//  AutoView
//
//  Created by Liang on 15/11/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "AutoManager.h"
#import <UIKit/UIKit.h>


static AutoManager *shareManager = nil;

@implementation AutoManager

+ (AutoManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[AutoManager alloc] init];
    });
    return shareManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _scale = [self autoSizeScale];
    }
    return self;
}

// 计算自动布局比例
- (float)autoSizeScale {
    
    float scale;
    
    float screenWidth = ([UIScreen mainScreen].bounds.size.width);
    float screenHeight = ([UIScreen mainScreen].bounds.size.height);
    
    float stdWidth = 320;
    float stdHeight = 568;
    
    if (screenWidth <= stdWidth && screenHeight <= stdHeight) {
        
        scale = 1.0;
        
    } else if (screenWidth / stdWidth > screenHeight / stdHeight) {
        
        scale = screenHeight / stdHeight;
        
    } else {
        
        scale = screenWidth / stdWidth;
    }
    return scale;
}

@end
