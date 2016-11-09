//
//  BdTextView.m
//  skyeye
//
//  Created by Liang on 14/11/12.
//  Copyright (c) 2014年 zhuayi inc. All rights reserved.
//

#import "BdTextView.h"

@implementation BdTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        labeltext = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, frame.size.width-10, 15)];
        labeltext.backgroundColor = [UIColor clearColor];
        labeltext.textColor = [UIColor lightGrayColor];
        labeltext.numberOfLines = 0;
        labeltext.font = self.font;
        [self addSubview:labeltext];
        
        [self addObserver];
    }
    return self;
}
-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
}
-(void)removeobserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];    
}
- (void)textDidChange:(NSNotification*) notification
{
    
    if ([self.text isEqualToString:@""]) {
        
        labeltext.hidden = NO;
    }else {
        labeltext.hidden = YES;
    }

}
- (void)dealloc
{
    NSLog(@"BdTextView dealloc");
    [self removeobserver];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setPlaceholder:(NSString *)string
{
    labeltext.text = string;
    [labeltext sizeToFit];
}
- (void)setPlaceholderFont:(UIFont *)font
{
    labeltext.font = font;
    [labeltext sizeToFit];

}
- (void)setPlaceholderColor:(UIColor *)color
{
    labeltext.textColor = color;
}
- (void)setPlaceholderOriginX:(CGFloat)x originY:(CGFloat)y
{
    labeltext.frame = CGRectMake(x, y, labeltext.frame.size.width, labeltext.frame.size.height);
}
@end
