//
//  GroupButton.m
//  NGEagle
//
//  Created by Liang on 15/8/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "GroupButton.h"

@implementation GroupButton

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-10, 0, 20, 30)];
        self.iconImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.iconImageView];
        
        self.lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 20)];
        self.lblNumber.font = [UIFont systemFontOfSize:14.0];
        self.lblNumber.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblNumber];
        
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 20)];
        self.lblTitle.text = @"班级";
        self.lblTitle.font = [UIFont systemFontOfSize:14.0];
        self.lblTitle.textColor = [UIColor lightGrayColor];
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblTitle];
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
