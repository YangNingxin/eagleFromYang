//
//  LeftImageRightLabel.h
//  NGEagle
//
//  Created by Liang on 16/4/6.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftImageRightLabel : UIView
@property (nonatomic ,strong) UILabel *label;
@property (nonatomic ,strong) UIImageView *imageView;

- (void)initWithData:(NSString *)text image:(UIImage *)image;
@end
