//
//  BdTextView.h
//  skyeye
//
//  Created by Liang on 14/11/12.
//  Copyright (c) 2014年 zhuayi inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BdTextView : UITextView
{
    UILabel *labeltext;
}

- (void)setPlaceholder:(NSString *)string;
- (void)setPlaceholderFont:(UIFont *)font;
- (void)setPlaceholderColor:(UIColor *)color;
- (void)setPlaceholderOriginX:(CGFloat)x originY:(CGFloat)y;

@end
