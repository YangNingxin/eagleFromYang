//
//  ClassCell.m
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ClassCell.h"

@implementation ClassCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setClassList:(ClassList *)classList {
    _classList = classList;
    
    self.className.text = [NSString stringWithFormat:@"%@_", classList.name];
    self.hour.text = [NSString stringWithFormat:@"共%d课时", classList.lesson_nr];
    
    self.locationLabel.text = classList.address;
    self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",
                           classList.start_time, classList.end_time];
    
    self.selectedLabel.text = [NSString stringWithFormat:@"已报名%d人", classList.student_nr];
    self.unSelectedLabel.text = [NSString stringWithFormat:@"剩余%d人", classList.surplus_nr];
    
    if (classList.price == 0) {
        self.priceLabel.text = @"免费";
    } else {
       self.priceLabel.text = [NSString stringWithFormat:@"￥%.0f", classList.price]; 
    }
    
    self.bookButton.userInteractionEnabled = NO;

    [self reloadUIByUserType:[Account shareManager].userModel.user.type];
    
    [self.className sizeToFit];
    [self.hour sizeToFit];
    
    self.hour.left = self.className.right;
}

- (void)reloadUIByUserType:(int)type {
    if (type == 1) {
        
        switch (_classList.status) {
            case 0:
                [self.bookButton setTitle:@"未开课" forState:UIControlStateNormal];
                [self.bookButton setBackgroundImage:[UIImage imageNamed:@"button_no"] forState:UIControlStateNormal];

                break;
            case 1:
                [self.bookButton setTitle:@"已开课" forState:UIControlStateNormal];
                [self.bookButton setBackgroundImage:[UIImage imageNamed:@"button_course"] forState:UIControlStateNormal];

                break;
            case 2:
                [self.bookButton setTitle:@"已结束" forState:UIControlStateNormal];
                [self.bookButton setBackgroundImage:[UIImage imageNamed:@"button_no"] forState:UIControlStateNormal];

                break;
            case 3:
                [self.bookButton setTitle:@"取消开班" forState:UIControlStateNormal];
                [self.bookButton setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];

                break;
            default:
                break;
        }
        self.stateImageView.hidden = YES;
        self.priceLabel.hidden = YES;
        
    } else {
        
        if (_classList.class_status == 1) { // 可以预约
            [self.bookButton setBackgroundImage:[UIImage imageNamed:@"button_class"] forState:UIControlStateNormal];
        } else {
            [self.bookButton setBackgroundImage:[UIImage imageNamed:@"button_no"] forState:UIControlStateNormal];
        }
        NSString *imageName = [NSString stringWithFormat:@"statue-%d", _classList.class_status];
        self.stateImageView.image = [UIImage imageNamed:imageName];
    }
}

- (IBAction)bookButtonAction:(UIButton *)sender {
    [self.delegate bookCourse:self.indexPath];
}

@end
