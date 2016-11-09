//
//  BaseViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlurImageView.h"

@interface BaseViewController : UIViewController {
    
    SlurImageView *_barImageView;
    UIButton *_leftButton;
    UIButton *_rightButotn;
    UILabel *_titleLabel;
    UIImageView *_shadowView;
}

- (void)leftButtonAction;
- (void)rightButtonAction;
- (void)configBaseUI;

@end
