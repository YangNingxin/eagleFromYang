//
//  SelectDatePickerView.m
//  rehab
//
//  Created by zhaoxiaolu on 15/8/10.
//  Copyright (c) 2015年 renxin. All rights reserved.
//

#import "BasePopView.h"

@implementation BasePopView {

}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 遮罩视图
        self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.alphaView.backgroundColor = [UIColor blackColor];
        self.alphaView.alpha = 0;
        [self addSubview:self.alphaView];
        
        // 内容视图
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        [self initContentView];
    }
    return self;
}

/**
 *  初始化内容视图
 */
- (void)initContentView {
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.tag = 10 + i;
        switch (i) {
            case 0:
                [button setTitle:@"取消" forState:UIControlStateNormal];
                button.frame = CGRectMake(0, 0, 60, 40);
                break;
            case 1:
                [button setTitle:@"完成" forState:UIControlStateNormal];
                button.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40);
                
                break;
            default:
                break;
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        UIImageView *lineImageView = [[UIImageView alloc] init];
        lineImageView.frame = CGRectMake(0, i * 40, SCREEN_WIDTH, 0.5);
        lineImageView.backgroundColor = RGB(200, 200, 200);
        [self.contentView addSubview:lineImageView];
    }
    
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 11) {

    }
    [self dismiss];
}

- (void)show {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alphaView.alpha = 0.5;
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 260);
    } completion:^(BOOL finished) {

    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alphaView.alpha = 0;
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self dismiss];
}

@end
