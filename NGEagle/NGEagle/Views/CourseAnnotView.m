//
//  CourseAnnotView.m
//  NGEagle
//
//  Created by Liang on 15/8/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CourseAnnotView.h"
#import "UIImageView+AFNetworking.h"

@implementation CourseAnnotView

- (id)initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
       
        
    }
    return self;
}
@end


@implementation CoursePointAnnot

@end


@implementation CourseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *image = [[UIImage imageNamed:@"pop"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = image;
        [self addSubview:imageView];
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 50, 35)];
        self.headImageView.image = [UIImage imageNamed:@"organization"];
        [self addSubview:self.headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5,90, 30)];
        self.nameLabel.font = [UIFont systemFontOfSize:12.0];
        self.nameLabel.numberOfLines = 2;
        self.nameLabel.text = @"课程名称课程名称课程名称课程名称课程名称课程名称";
        [self addSubview:self.nameLabel];
        
        self.courseNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 34, 90, 14)];
        self.courseNumLabel.font = [UIFont systemFontOfSize:10.0];
        self.courseNumLabel.text = @"班次23个，可选4个";
        [self addSubview:self.courseNumLabel];
        
        self.locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 48, 14, 14)];
        self.locationImageView.image = [UIImage imageNamed:@"icon_location_sm"];
        self.locationImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.locationImageView];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.locationImageView.right, 50, 30, 9)];
        self.distanceLabel.text = @"3.5km";
        self.distanceLabel.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:self.distanceLabel];
        
        self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.distanceLabel.right + 10, 50, 30, 9)];
        self.scoreLabel.text = @"5分";
        self.scoreLabel.textColor = [UIColor orangeColor];
        self.scoreLabel.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:self.scoreLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.scoreLabel.right, 50, 30, 9)];
        self.priceLabel.textColor = [UIColor redColor];
        self.priceLabel.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:self.priceLabel];
        
        self.hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.priceLabel.right, 50, 30, 9)];
        self.hourLabel.text = @"5课时";
        self.hourLabel.textColor = RGB(80, 192, 187);
        self.hourLabel.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:self.hourLabel];
        
    }
    return self;
}

- (void)setCourse:(Course *)course {
    _course = course;
    [self.headImageView setImageWithURL:[NSURL URLWithString:_course.face]];
    
    self.nameLabel.text = _course.name;
    
    if (_course.price.floatValue == 0) {
        self.priceLabel.text = @"免费";

    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", _course.price];

    }
    self.hourLabel.text = [NSString stringWithFormat:@"%@课时", _course.openlesson_nr];
    self.courseNumLabel.text = [NSString stringWithFormat:@"班次%d个，可选%d个", _course.openclass_count, _course.openclass_appointment_count];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", _course.distance];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分", _course.score];
}

@end