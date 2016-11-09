//
//  CourseAnnotView.h
//  NGEagle
//
//  Created by Liang on 15/8/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <BaiduMapAPI/BMKAnnotationView.h>
#import <BaiduMapAPI/BMKPointAnnotation.h>
#import "CourseModel.h"

@interface CourseAnnotView : BMKAnnotationView

@end


@interface CoursePointAnnot : BMKPointAnnotation

@property (nonatomic, strong) Course *course;

@end


@interface CourseView : UIView

// logo
@property (nonatomic, strong) UIImageView *headImageView;

// 名字
@property (nonatomic, strong) UILabel *nameLabel;

// 课程数量 课程234个
@property (nonatomic, strong) UILabel *courseNumLabel;

// 位置icon
@property (nonatomic, strong) UIImageView *locationImageView;

// 距离
@property (nonatomic, strong) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) Course *course;

@end