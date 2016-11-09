//
//  UIView+PefAuto.h
//  AutoView
//
//  Created by Liang on 15/11/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

/**
 *  是否开启自动适配, 默认为YES
 */
@property (nonatomic) BOOL isAutoLayout;

/**
 *  更新子视图约束
 */
- (void)updateContentConstraints;

/**
 *  更新本身视图约束
 */
- (void)updateSelfConstraints;
@end