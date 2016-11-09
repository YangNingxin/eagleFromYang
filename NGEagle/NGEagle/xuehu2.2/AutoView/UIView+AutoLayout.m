//
//  UIView+PefAuto.m
//  AutoView
//
//  Created by Liang on 15/11/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "UIView+AutoLayout.h"
#import <objc/runtime.h>
#import "AutoManager.h"
static char *isAutoKey = "isAutoKey";
static char *isScaledKey = "isScaledKey";

@interface UIView ()

/**
 *  存储自动布局值
 */
@property (nonatomic, strong) id autoLayoutValue;

/**
 *  是否已经放大过，保证一次放大
 */
@property (nonatomic, strong) NSNumber *isScaled;

@end

@implementation UIView (AutoLayout)

@dynamic isAutoLayout;

- (void)setIsAutoLayout:(BOOL)isAutoLayout {

    if (isAutoLayout == NO) {
        self.autoLayoutValue = @"frame"; // frame
    } else {
        self.autoLayoutValue = @"layout"; // layout
    }
}

// 是否自动
- (void)setAutoLayoutValue:(id)autoLayoutValue {
    objc_setAssociatedObject(self, &isAutoKey, autoLayoutValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)autoLayoutValue {
    id value = objc_getAssociatedObject(self, &isAutoKey);
    if ([value isEqualToString:@"frame"]) {
        return @"0";
    }
    return @"1";
}

// 保证缩放一次
- (void)setIsScaled:(NSNumber *)isScaled {
    objc_setAssociatedObject(self, &isScaledKey, isScaled, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)isScaled {
    NSNumber *value = objc_getAssociatedObject(self, &isScaledKey);
    return value;
}

// 更新约束
- (void)updateContentConstraints {
    
    for (UIView *v in self.subviews) {
        if ([v.autoLayoutValue boolValue]) {
            [self updateContentConstraints:v];
        }
    }
}

/**
 *  更新本身视图约束
 */
- (void)updateSelfConstraints {
    if ([self.autoLayoutValue boolValue]) {
        [self update:self];
    }
}

// 更新某个视图约束
- (void)updateContentConstraints:(UIView *)view {
    
    if (view.subviews.count > 0 && ![self isSystemMultipleView:view]) {
        
        // 判断视图是否需要放大
        if ([view.autoLayoutValue boolValue]) {
            // 更新视图本身约束
            [self update:view];
        }
        // 更新子类
        for (UIView *subView in view.subviews) {
            if ([subView.autoLayoutValue boolValue]) {
                [self updateContentConstraints:subView];
            }
        }
    } else {
        // 判断视图是否需要放大
        if ([view.autoLayoutValue boolValue]) {
            [self update:view];
        }
    }
}

/**
 *  是否是系统控件，并且是自带子视图
 *
 *  @param view，目前只限制了TextView、UIWebView
 *
 *  @return
 */
- (BOOL)isSystemMultipleView:(UIView *)view {
    if ([view isKindOfClass:[UITextView class]]
        || [view isKindOfClass:[UIWebView class]]
        || [view isKindOfClass:[UISwitch class]]
        || [view isKindOfClass:[UISlider class]]) {
        return YES;
    }
    return NO;
}

// 更新
- (void)update:(UIView *)view {
    
    if (!view.isScaled.boolValue) {
        if ([view isKindOfClass:[UILabel class]] ||
            [view isKindOfClass:[UITextField class]] ||
            [view isKindOfClass:[UITextView class]]) {
            
            [self updateText:(UILabel *)view];
        } else if ([view isKindOfClass:[UIButton class]]) {
            [self updateButton:(UIButton *)view];
        }
        
        view.layer.cornerRadius = view.layer.cornerRadius * kAutoScale;
        NSArray* constrainsArray = view.constraints;
        
        float screenWidth = ([UIScreen mainScreen].bounds.size.width);
        float screenHeight = ([UIScreen mainScreen].bounds.size.height);

        for (NSLayoutConstraint* constraint in constrainsArray) {
            if (constraint.constant != screenWidth && constraint.constant != screenHeight) {
                constraint.constant = constraint.constant * kAutoScale;
            }
        }
        [view updateConstraintsIfNeeded];
    }
    
    // 放大之后标记为YES
    view.isScaled = [NSNumber numberWithBool:YES];
}

// 更新按钮
- (void)updateButton:(UIButton *)button {
    UILabel *label = button.titleLabel;
    if (!label.isScaled.boolValue) {
        NSString *fontName = label.font.fontName;
        CGFloat fontSize = label.font.pointSize;
        button.titleLabel.font = [UIFont fontWithName:fontName size:fontSize * kAutoScale];
    }
    label.isScaled = [NSNumber numberWithBool:YES];
}

// 更新文本
- (void)updateText:(UILabel *)label {
    
    NSString *fontName = label.font.fontName;
    CGFloat fontSize = label.font.pointSize;
    label.font = [UIFont fontWithName:fontName size:fontSize * kAutoScale];
}

@end
