//
//  OrganAnnotView.m
//  NGEagle
//
//  Created by Liang on 15/8/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "OrganAnnotView.h"
#import "UIImageView+AFNetworking.h"

@implementation OrganAnnotView

- (id)initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation OrganPointAnnot

@end


@implementation OrganView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBounds:CGRectMake(0.f, 0.f, 156.0f, 75.f)];
        
        
        UIImage *image = [[UIImage imageNamed:@"pop"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = image;
        [self addSubview:imageView];
        
        [self setBackgroundColor:[UIColor clearColor]];

        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 40, 40)];
        self.headImageView.image = [UIImage imageNamed:@"organization"];
        [self addSubview:self.headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10,110, 14)];
        self.nameLabel.font = [UIFont systemFontOfSize:12.0];
        self.nameLabel.text = @"北京智慧教育科技馆";
        [self addSubview:self.nameLabel];
        
        self.courseNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 26, 80, 14)];
        self.courseNumLabel.font = [UIFont systemFontOfSize:10.0];
        self.courseNumLabel.text = @"课程234个";
        [self addSubview:self.courseNumLabel];
        
        self.locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 40, 14, 14)];
        self.locationImageView.image = [UIImage imageNamed:@"icon_location_sm"];
        self.locationImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.locationImageView];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.locationImageView.right, 43, 30, 9)];
        self.distanceLabel.text = @"3.5km";
        self.distanceLabel.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:self.distanceLabel];
        
        self.peopleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.distanceLabel.right, 40, 14, 14)];
        self.peopleImageView.contentMode = UIViewContentModeCenter;
        self.peopleImageView.image = [UIImage imageNamed:@"icon_people"];
        [self addSubview:self.peopleImageView];
        
        self.followNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.peopleImageView.right, 43, 40, 9)];
        self.followNumLabel.text = @"32人关注";
        self.followNumLabel.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:self.followNumLabel];
    }
    return self;
}


- (void)setOrgan:(Organ *)organ {
    _organ = organ;
    self.nameLabel.text = _organ.name;
    [self.headImageView setImageWithURL:[NSURL URLWithString:_organ.logo_url]];
    self.courseNumLabel.text = [NSString stringWithFormat:@"课程%@个", _organ.course_count];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km", @"1.1"];
    self.followNumLabel.text = [NSString stringWithFormat:@"%@人关注", _organ.follow_nr];
    
    
}
@end

























