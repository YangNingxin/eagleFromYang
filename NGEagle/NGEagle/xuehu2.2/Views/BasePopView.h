//
//  SelectDatePickerView.h
//  rehab
//
//  Created by zhaoxiaolu on 15/8/10.
//  Copyright (c) 2015年 renxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BasePopViewDelegate <NSObject>


@end

@interface BasePopView : UIView

@property (nonatomic, weak) id<BasePopViewDelegate>delegate;

/**
 *  遮罩
 */
@property (nonatomic, strong) UIView *alphaView;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *contentView;

- (void)initContentView;
- (void)show;
- (void)dismiss;

@end
