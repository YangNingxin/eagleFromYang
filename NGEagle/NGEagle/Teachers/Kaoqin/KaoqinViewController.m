//
//  KaoqinViewController.m
//  NGEagle
//
//  Created by Liang on 15/9/5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "KaoqinViewController.h"
#import "RegistarUserListModel.h"
#import "KaoqingCell.h"
#import "MemberListModel.h"
#import "NSDateUtil.h"
#import "RegistrationDataHelper.h"
#import "ResourceModel.h"
#import "Location.h"

@interface KaoqinViewController ()
{
    NSMutableArray *_userArray;
    UITextField *_nameTextField;
    UITextField *_timeTextField;
}
@end

@implementation KaoqinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _userArray = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KaoqingCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    
    if (self.groupInfo) {
        [self getGroupMembersFromServer];
    } else {
        [self getRegistrationUserList];
        [self.coverImageView setImageWithURL:[NSURL URLWithString:self.listModel.face]
                            placeholderImage:[UIImage imageNamed:@"kaoqing_cover"]];
    }
    // Do any additional setup after loading the view from its nib.
}

/**
 *  获取签到之后用户列表
 */
- (void)getRegistrationUserList {
    
    [RegistrationDataHelper getRegistrationUserListByRegID:self.listModel.rid success:^(id responseObject) {
        RegistarUserListModel *tempModel = responseObject;
        if (tempModel.error_code == 0) {
            
            [_userArray removeAllObjects];
            [_userArray addObjectsFromArray:tempModel.data];
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

/**
 *  获取需要签到的用户成员
 */
- (void)getGroupMembersFromServer {
    [DataHelper getGroupUserByGroupId:[self.groupInfo.gid intValue] success:^(id responseObject) {
       
        MemberListModel *tempModel = responseObject;
        if (tempModel.error_code == 0) {
           
            [_userArray removeAllObjects];
            
            [_userArray addObjectsFromArray:tempModel.users];
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)configBaseUI {
    [super configBaseUI];
    
    _titleLabel.text = @"点到";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setTitle:@"完成" forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    // 编辑状态
    if (self.listModel) {
        
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
        
        if (isSetCover) {
            [DataHelper uploadLogo:self.coverImageView.image success:^(id responseObject) {
                
                ResourceModel *model = responseObject;
                if (model.error_code == 0 && model.data.url) {
                    [self editFinishRegistrationWithImageURL:model.data.md];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"提交失败"];
                }
                
            } fail:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"提交失败，请重试"];
            }];
        } else {
            [self editFinishRegistrationWithImageURL:nil];
        }

        
    } else {
        // 创建
        if (_timeTextField.text.length == 0 || _nameTextField.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
        
        if (isSetCover) {
            [DataHelper uploadLogo:self.coverImageView.image success:^(id responseObject) {
                
                ResourceModel *model = responseObject;
                if (model.error_code == 0 && model.data.url) {
                    [self finishRegistrationWithImageURL:model.data.md];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"提交失败"];
                }
                
            } fail:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"提交失败，请重试"];
            }];
        } else {
            [self finishRegistrationWithImageURL:nil];
        }

    }
}

// 完成提交
- (void)finishRegistrationWithImageURL:(NSString *)url {

    float lat = [Location shareManager].location.latitude;
    float lon = [Location shareManager].location.longitude;
    
    [RegistrationDataHelper createOnceRegistrationWithName:_nameTextField.text type:0 type_id:[self.groupInfo.gid intValue] user_count:self.groupInfo.memberCount time:_timeTextField.text pic_md:url longitude:lat latitude:lon users:[self getUsersSignStatus] success:^(id responseObject) {
        
        ErrorModel *model = responseObject;
        if (model.error_code == 0) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            
            // 刷新考勤列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshKaoqingList" object:nil];
//            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:1];
//            [self.navigationController popToViewController:viewController animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:model.error_msg];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败，请重试"];
    }];
}

- (void)editFinishRegistrationWithImageURL:(NSString *)url {
    
    [RegistrationDataHelper editRegistrationWithID:self.listModel.rid users:[self getUsersSignStatus] pic_md:url success:^(id responseObject) {
        
        ErrorModel *model = responseObject;
        if (model.error_code == 0) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            
            // 刷新考勤列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshKaoqingList" object:nil];
            
        } else {
            [SVProgressHUD showErrorWithStatus:model.error_msg];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败，请重试"];
    }];
    

}

- (NSString *)getUsersSignStatus {
    
    NSMutableString *data = [NSMutableString string];
    
    for (User *user in _userArray) {
        [data appendFormat:@"%@-%d,", user.uid, user.sign_status];
    }
    if (data.length > 1) {
        data = (NSMutableString *)[data substringToIndex:data.length-1];
    }
    NSLog(@"data is %@", data);
    return data;
}

- (IBAction)tapCoverImageViewAction:(UITapGestureRecognizer *)sender {
    if (self.listModel) {
        return;
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return _userArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        NSString *idfa = [NSString stringWithFormat:@"cell%ld", indexPath.row];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfa];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfa];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
            textField.delegate = self;
            textField.tag = 10;
            [textField setReturnKeyType:UIReturnKeyDone];
            textField.font = [UIFont systemFontOfSize:15.0];
            [cell.contentView addSubview:textField];
        }
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:10];
        if (indexPath.row == 0) {
            _nameTextField = textField;
            textField.placeholder = @"请输入点到课时名字";
        } else {
            textField.placeholder = @"请设置点到时间";
            _timeTextField = textField;
        }
        if (self.listModel) {
            _nameTextField.text = self.listModel.name;
            _timeTextField.text = self.listModel.sign_time;
            [textField setEnabled:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        
        KaoqingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.user = _userArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _timeTextField) {
        [_nameTextField resignFirstResponder];
        
        // 修改出生日期
        if (!dateView) {
            
            dateView = [[[NSBundle mainBundle] loadNibNamed:@"DateView" owner:self options:nil] lastObject];
            dateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
            dateView.delegate = self;
            [dateView.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            [self.view addSubview:dateView];
            
            [self showDatePickerView];
        }
        
        return NO;
    } else {
        [self hideDatePickerView];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_nameTextField resignFirstResponder];
    
    if (self.listModel) {
        self.listModel.name = _nameTextField.text;
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_nameTextField resignFirstResponder];
    [self hideDatePickerView];
}

// 控制dateView是否显示隐藏
- (void)showDatePickerView {
    
    [UIView animateWithDuration:0.25 animations:^{
        dateView.top = SCREEN_HEIGHT - 260;
    }];
}

- (void)hideDatePickerView {
    
    [UIView animateWithDuration:0.25 animations:^{
        dateView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [dateView removeFromSuperview];
        dateView = nil;
    }];
}

- (void)sureAction {
    NSDate *date = dateView.datePicker.date;
    NSString *dateString = [NSDateUtil stringFromDate:date withFormat:DateFormatYMDHM];
    _timeTextField.text = dateString;
    
    self.listModel.sign_time = dateString;
    [self hideDatePickerView];
}

- (void)cancelAction {
    [self hideDatePickerView];
}

#pragma mark
#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) { //系统相册
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            [imagePicker setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    } else if (buttonIndex == 0) { //照相机
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            [imagePicker setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            imagePicker.allowsEditing = YES;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持拍照!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.coverImageView.image = image;
    isSetCover = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
