//
//  DateView.h
//  NGEagle
//
//  Created by Liang on 15/8/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewDelegate <NSObject>

- (void)cancelAction;
- (void)sureAction;

@end

@interface DateView : UIView

@property (nonatomic, weak) id<DateViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView2;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

- (IBAction)cancelAction:(UIButton *)sender;
- (IBAction)sureAction:(UIButton *)sender;

@end
