//
//  EditUserInfoViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface EditUserInfoViewController : BaseViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    // 0-男 1-女
    int _sex;
    NSString *_date;
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *avatorButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@property (weak, nonatomic) IBOutlet UIButton *maleSelButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleSelButton;

@property (weak, nonatomic) IBOutlet UIButton *setDateButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView2;

- (IBAction)maleButtonAction:(UIButton *)sender;
- (IBAction)femaleButtonAction:(UIButton *)sender;
- (IBAction)avatorButtonAction:(UIButton *)sender;
- (IBAction)setDateButtonAction:(UIButton *)sender;
- (IBAction)finishButtonAction:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
- (IBAction)cancelAction:(UIButton *)sender;
- (IBAction)sureAction:(UIButton *)sender;

@end
