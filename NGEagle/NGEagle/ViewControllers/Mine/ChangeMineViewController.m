//
//  ChangeMineViewController.m
//  NGEagle
//
//  Created by ZhangXiaoZhuo on 15/8/13.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ChangeMineViewController.h"
#import "InputViewController.h"
#import "SexSelectViewController.h"
#import "StringSizeUtil.h"
#import "ResourceModel.h"
#import "VerifyMyPassController.h"
#import "SubjectViewController.h"

@interface ChangeMineViewController ()
{
    UIImageView *iconImg;
    NSString *_subjectIds;
}
@end

@implementation ChangeMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    tempUser = [[Account shareManager].userModel.user copy];
    
    myTable = [[UITableView alloc]initWithFrame:
               CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT)
                                          style:UITableViewStyleGrouped];
    myTable.delegate = self;
    myTable.dataSource = self;
    [self.view addSubview:myTable];
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"个人资料编辑";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setTitle:@"完成" forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    
    [self upLoadLogo];
}

- (void)upLoadLogo {
    
    [SVProgressHUD showWithStatus:@"提交..." maskType:SVProgressHUDMaskTypeClear];

    [DataHelper uploadLogo:iconImg.image success:^(id responseObject) {
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
    [dict setObject:tempUser.birthdayName forKey:@"birthday"];
    [dict setObject:tempUser.sex forKey:@"gender"];
    [dict setObject:tempUser.nick forKey:@"nick"];
    [dict setObject:tempUser.intro forKey:@"intro"];
    [dict setObject:tempUser.interesting forKey:@"interesting"];
    
    if (_subjectIds.length > 0) {
        [dict setObject:_subjectIds forKey:@"interest_subject"];
    }
    
    [DataHelper changeUserInfoWithDictParams:dict success:^(id responseObject) {
        ErrorModel *model = responseObject;
        // 成功
        if (model.error_code == 0) {
            [Account shareManager].userModel.user = [tempUser copy];
            tempUser = nil;
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"修改失败，请重试"];

        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"修改失败，请重试"];

    }];
}


#pragma mark
#pragma mark table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if ([Account shareManager].userModel.user.type == 1) {
        return 5;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 4;
    } else if (section == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 90.0f;
    } else if (indexPath.section == 3 || indexPath.section == 4) {
        
        NSString *content;
        if (indexPath.section == 3) {
            content = tempUser.intro;
        } else {
            content = tempUser.subjectToString;
        }
       CGFloat height = [StringSizeUtil
                        getContentSizeHeight:content
                        font:[UIFont systemFontOfSize:15.0]
                        width:SCREEN_WIDTH-140];
        if (height <= 20) {
            return 45;
        }
        return height + 30;
        
    } else {
        return 45.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellStyleValue1;
        
        if (indexPath.section == 0) {
            
            iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(11, 5, 80, 80)];
            iconImg.layer.cornerRadius = 40.0;
            iconImg.layer.masksToBounds = YES;
            [iconImg setImageWithURL:[NSURL URLWithString:tempUser.logo]];
            [cell.contentView addSubview:iconImg];
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+12, 31, 150, 18)];
            titleLab.textColor = [UIColor grayColor];
            titleLab.font = [UIFont systemFontOfSize:15];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.text = @"点击修改头像";
            [cell.contentView addSubview:titleLab];
            
        } else if (indexPath.section == 3 || indexPath.section == 4) {
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 80, 18)];
            titleLab.textColor = [UIColor grayColor];
            titleLab.font = [UIFont systemFontOfSize:15];
            titleLab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:titleLab];
            
            UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.right+20, 15, SCREEN_WIDTH-140, 18)];
            detailLab.textColor = [UIColor grayColor];
            detailLab.backgroundColor = [UIColor clearColor];
            detailLab.font = [UIFont systemFontOfSize:15];
            detailLab.textAlignment = NSTextAlignmentLeft;
            detailLab.numberOfLines = 0;
            detailLab.tag = 999;
            [cell.contentView addSubview:detailLab];
            
            if (indexPath.section == 3) {
                titleLab.text = @"个人简介";
            } else if (indexPath.section == 4) {
                titleLab.text = @"擅长学科";
            }
            
        } else {
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 80, 15)];
            titleLab.textColor = [UIColor grayColor];
            titleLab.font = [UIFont systemFontOfSize:15];
            titleLab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:titleLab];
            
            UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.right+20, 15, 150, 15)];
            detailLab.textColor = [UIColor grayColor];
            detailLab.font = [UIFont systemFontOfSize:14];
            detailLab.textAlignment = NSTextAlignmentLeft;
            detailLab.tag = 999;
            [cell.contentView addSubview:detailLab];
            
            if (indexPath.section == 1) { // 分区1
                
                if (indexPath.row == 0) {
                    titleLab.text = @"用户名";
                } else if (indexPath.row == 1) {
                    titleLab.text = @"真实姓名";
                } else if (indexPath.row == 2) {
                    titleLab.text = @"性别";
                } else if (indexPath.row == 3) {
                    titleLab.text = @"出生日期";
                }
            } else if (indexPath.section == 2) { // 分区2
                
                if (indexPath.row == 0) {
                    titleLab.text = @"兴趣爱好";
                } else if (indexPath.row == 1) {
                    titleLab.text = @"绑定手机";
                }
            }
        }
        
    }
    
    UILabel *tempLab = (UILabel *)[cell.contentView viewWithTag:999];
    if (indexPath.section == 1) {   // 分区1
        
        if (indexPath.row == 0) {
            tempLab.text = tempUser.nick;
        } else if (indexPath.row == 1) {
            tempLab.text = tempUser.name;
        } else if (indexPath.row == 2) {
            tempLab.text = tempUser.sexName;
        } else if (indexPath.row == 3) {
            tempLab.text = tempUser.birthdayName;
        }
        
    } else if (indexPath.section == 2) {  // 分区2
        
        if (indexPath.row == 0) {
            tempLab.text = tempUser.interesting;
        } else if (indexPath.row == 1) {
            tempLab.text = tempUser.telephone;
        }
    } else if (indexPath.section == 3) {  // 分区3
        tempLab.width = SCREEN_WIDTH-140;
        tempLab.text = tempUser.intro;
        [tempLab sizeToFit];
        
    } else if (indexPath.section == 4) {  // 分区 4
        
        tempLab.width = SCREEN_WIDTH-140;
        tempLab.text = tempUser.subjectToString;
        [tempLab sizeToFit];
    }

    // Config your cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [sheet showInView:self.view];
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            // 修改姓名
            [self gotoInputViewController:0 content:tempUser.nick];
            
        } else if (indexPath.row == 1) {
            
            if ([Account shareManager].userModel.user.name.length > 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"真实姓名不能修改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            [self gotoInputViewController:3 content:tempUser.name];

        } else if (indexPath.row == 2) {
            
            // 修改性别
            SexSelectViewController *selectVc = [[SexSelectViewController alloc] initWithNibName:@"SelectViewController" bundle:nil];
            selectVc.index = [tempUser.sex intValue];
            [selectVc setFinishSelectBlock:^(id itemSelect) {

                tempUser.sex = [NSString stringWithFormat:@"%@", itemSelect];
                [myTable reloadData];
            }];
            [self.navigationController pushViewController:selectVc animated:YES];
            
        } else if (indexPath.row == 3) {
            
            // 修改出生日期
            if (!dateView) {
                
                dateView = [[[NSBundle mainBundle] loadNibNamed:@"DateView" owner:self options:nil] lastObject];
                dateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
                dateView.delegate = self;
                [self.view addSubview:dateView];
                
                [self showDatePickerView];
            }
            
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            [self gotoInputViewController:1 content:tempUser.interesting];
        } else { // 绑定手机
            VerifyMyPassController *verifyVc = [[VerifyMyPassController alloc] initWithNibName:@"VerifyPassViewController" bundle:nil];
            [self.navigationController pushViewController:verifyVc animated:YES];
        }
    } else if (indexPath.section == 3) {
        
        [self gotoInputViewController:2 content:tempUser.intro];
        
    } else if (indexPath.section == 4) {
        
        SubjectViewController *subjectVc = [[SubjectViewController alloc] init];
        [subjectVc setCompletion:^(NSString *subjectIds, NSString *subjectNames) {
            tempUser.subjectToString = subjectNames;
            _subjectIds = subjectIds;
            [myTable reloadData];
        }];
        [self.navigationController pushViewController:subjectVc animated:YES];
    }
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

// 输入控制器
- (void)gotoInputViewController:(int)type content:(NSString *)content {
    InputViewController *inputVc = [[InputViewController alloc] initWithNibName:@"InputViewController" bundle:nil];
    inputVc.type = type;
    inputVc.content = content;
    [inputVc setFinishBlock:^(NSString *content) {
        switch (type) {
            case 0:
                tempUser.nick = content;
                break;
            case 1:
                tempUser.interesting = content;
                break;
            case 2:
                tempUser.intro = content;
                break;
            case 3:
                tempUser.name = content;
                break;
            default:
                break;
        }
        [myTable reloadData];
    }];
    [self.navigationController pushViewController:inputVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    } else if (buttonIndex == 0){ //照相机
        
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

    UIImage *image = info[UIImagePickerControllerEditedImage];
    iconImg.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideDatePickerView];
}

#pragma mark
#pragma mark DateViewDelegate

- (void)cancelAction {
    [self hideDatePickerView];

}

- (void)sureAction {
    NSDate *date = dateView.datePicker.date;
    int time = [date timeIntervalSince1970];
    NSString *birthday = [NSString stringWithFormat:@"%d", time];
    tempUser.birthday = birthday;
    
    [myTable reloadData];
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

@end
