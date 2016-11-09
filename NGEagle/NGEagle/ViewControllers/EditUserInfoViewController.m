//
//  EditUserInfoViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "ResourceModel.h"

@interface EditUserInfoViewController ()

@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
    [self.view addSubview:self.dateView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    
    _titleLabel.text = @"完善信息(3/3)";
    [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [self.nameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTextField setValue:[UIFont systemFontOfSize:14.0]
              forKeyPath:@"_placeholderLabel.font"];
    
    self.avatorButton.layer.cornerRadius = self.avatorButton.width / 2;
    self.avatorButton.layer.masksToBounds = YES;
    
    self.finishButton.backgroundColor = kThemeColor;
    self.finishButton.layer.cornerRadius = 4.0;
    
    self.lineImageView.backgroundColor = self.lineImageView2.backgroundColor = self.view.backgroundColor;
}

- (void)leftButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nameTextField resignFirstResponder];
    [self hideDatePickerView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)maleButtonAction:(UIButton *)sender {
    _sex = 0;
    [self.maleSelButton setImage:[UIImage imageNamed:@"sex_sel"] forState:UIControlStateNormal];
    [self.femaleButton setImage:[UIImage imageNamed:@"sex_un_sel"] forState:UIControlStateNormal];
}

- (IBAction)femaleButtonAction:(UIButton *)sender {
    _sex = 1;
    [self.femaleButton setImage:[UIImage imageNamed:@"sex_sel"] forState:UIControlStateNormal];
    [self.maleSelButton setImage:[UIImage imageNamed:@"sex_un_sel"] forState:UIControlStateNormal];

}

- (IBAction)avatorButtonAction:(UIButton *)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片", @"相机", nil];
    [sheet showInView:self.view];
}

- (IBAction)setDateButtonAction:(UIButton *)sender {
    [self showDatePickerView];
}

- (IBAction)finishButtonAction:(UIButton *)sender {
    if (self.nameTextField.text && self.nameTextField.text > 0
        && _date) {
        
        [self upLoadLogo];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不全面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)upLoadLogo {
    
    [SVProgressHUD showWithStatus:@"提交..." maskType:SVProgressHUDMaskTypeClear];
    
    [DataHelper uploadLogo:self.avatorButton.imageView.image success:^(id responseObject) {
        ResourceModel *model = responseObject;
        if (model.error_code == 0 && model.data.url) {
            [self changeUserInfoWithLogo:model.data.url];
        } else {
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];

    }];

    
}

- (void)changeUserInfoWithLogo:(NSString *)url {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:url forKey:@"logo"];
    [dict setObject:_date forKey:@"birthday"];
    [dict setObject:@(_sex + 1) forKey:@"gender"];
    [dict setObject:self.nameTextField.text forKey:@"nick"];

    [DataHelper changeUserInfoWithDictParams:dict success:^(id responseObject) {
        ErrorModel *model = responseObject;
        
        // 成功
        if (model.error_code == 0) {
            
            // 如果成功了，更新掉用户信息
            [Account shareManager].userModel.user.logo = dict[@"url"];
            [Account shareManager].userModel.user.nick = dict[@"nick"];
            [Account shareManager].userModel.user.sex = dict[@"gender"];
            [Account shareManager].userModel.user.birthday = dict[@"birthday"];
            
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];

    }];

}


- (IBAction)cancelAction:(UIButton *)sender {
    [self hideDatePickerView];

}

- (IBAction)sureAction:(UIButton *)sender {
    
    [self hideDatePickerView];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _date = [dateFormatter stringFromDate:self.datePicker.date];
    
    [self.setDateButton setTitle:_date forState:UIControlStateNormal];
    
    NSLog(@"%@", self.datePicker.date);
}

#pragma mark
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    } else if (buttonIndex == 1) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self hideDatePickerView];
    
    return YES;
}

#pragma mark
#pragma mark UIDatePickerView

- (void)showDatePickerView {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.dateView.top = SCREEN_HEIGHT - 260;
    }];
}

- (void)hideDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.dateView.top = SCREEN_HEIGHT;
    }];
}

#pragma mark
#pragma mark UIImageViewPickerDelegate



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *editImage = info[UIImagePickerControllerEditedImage];
    [self.avatorButton setImage:editImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
