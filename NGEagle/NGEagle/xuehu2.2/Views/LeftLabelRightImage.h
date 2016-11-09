//
//  LeftLabelRightImage.h
//  Hug
//
//  Created by zhaoxiaolu on 15/12/27.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftLabelRightImage : UIView

@property (nonatomic ,strong) UILabel *label;
@property (nonatomic ,strong) UIImageView *imageView;

- (void)initWithData:(NSString *)text image:(UIImage *)image;

@end
