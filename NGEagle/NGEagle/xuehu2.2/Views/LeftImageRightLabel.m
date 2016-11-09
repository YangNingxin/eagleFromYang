//
//  LeftImageRightLabel.m
//  NGEagle
//
//  Created by Liang on 16/4/6.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "LeftImageRightLabel.h"

@implementation LeftImageRightLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.label = [UILabel new];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:14.0];
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeCenter ;
        
        [self addSubview:self.label];
        [self addSubview:self.imageView];

        WS(weakSelf);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_right).offset(5);
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf);
        }];
    }
    
    return self;
}

- (void)initWithData:(NSString *)text image:(UIImage *)image {
    self.label.text = text;
    self.imageView.image = image;
}

- (void)dealloc {
    
    self.imageView = nil;
    self.label = nil;
    
    NSLog(@"%s", __func__);
}

@end
