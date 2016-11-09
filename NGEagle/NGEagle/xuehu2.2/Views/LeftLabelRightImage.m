//
//  LeftLabelRightImage.m
//  Hug
//
//  Created by zhaoxiaolu on 15/12/27.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "LeftLabelRightImage.h"

@implementation LeftLabelRightImage

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.label = [UILabel new];
        self.label.textColor = [UIColor whiteColor];
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeCenter ;
        
        [self addSubview:self.label];
        [self addSubview:self.imageView];
        
        WS(weakSelf);

        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_label.mas_right).offset(5);
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf);
        }];
        
    }
    
    [self updateContentConstraints];
    
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
