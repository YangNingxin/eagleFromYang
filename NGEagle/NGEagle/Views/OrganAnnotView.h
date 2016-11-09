//
//  OrganAnnotView.h
//  NGEagle
//
//  Created by Liang on 15/8/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <BaiduMapAPI/BMKAnnotationView.h>
#import <BaiduMapAPI/BMKPointAnnotation.h>

#import "OrganListModel.h"

@interface OrganAnnotView : BMKAnnotationView

@end


@interface OrganPointAnnot : BMKPointAnnotation
@property (nonatomic, strong) Organ *organ;
@end

@interface OrganView : UIView

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

// 关注人数icon
@property (nonatomic, strong) UIImageView *peopleImageView;

// 关注数量 32人关注
@property (nonatomic, strong) UILabel *followNumLabel;

@property (nonatomic, strong) Organ *organ;

@end