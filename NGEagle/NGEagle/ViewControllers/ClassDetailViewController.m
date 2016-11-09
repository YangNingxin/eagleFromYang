//
//  ClassDetailViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "AddCommentViewController.h"
#import "BdLocationViewController.h"
#import "ClassMemberViewController.h"

@interface ClassDetailViewController ()

@end

@implementation ClassDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _request = [DataHelper getClassAppointmentInfo:self.cid success:^(id responseObject) {
        
        ClassDetailModel *detailModel = responseObject;
        if (detailModel.error_code == 0 && detailModel.data) {
            _classDetail = detailModel.data;
            [self setContentUI];
        }
    } fail:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
}


- (void)configBaseUI {
    
    [super configBaseUI];
    
    [_rightButotn setTitle:@"退选" forState:UIControlStateNormal];

    self.bottomView.top = SCREEN_HEIGHT - 44;
    self.bottomView.backgroundColor = RGB(228, 228, 228);
    
    [self.view addSubview:self.bottomView];
    
    self.webview.height -= 44;
}

- (void)rightButtonAction {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退选吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [SVProgressHUD showWithStatus:@"正在退选..." maskType:SVProgressHUDMaskTypeClear];
        
        [DataHelper cancelCourseClassWithCourseId:_classDetail.opencourse_id
                                         class_id:_classDetail.cid
                                          success:^(id responseObject) {
                                              ErrorModel *model = responseObject;
                                              if (model.error_code == 0) {
                                                  
                                                  [SVProgressHUD showSuccessWithStatus:@"退选成功"];

                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  [SVProgressHUD showErrorWithStatus:@"操作失败，请重试"];

                                              }
                                          }
                                             fail:^(NSError *error) {
                                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请重试"];
                                             }];
    }
}

- (void)setContentUI {
    
    self.contentLabel.text = _classDetail.tip;
    [self.contentButton setTitle:_classDetail.button_info forState:UIControlStateNormal];
    
    if ([Account shareManager].userModel.user.type == 1) {
        
        // 设置老师UI
        _rightButotn.hidden = YES;
        [self setTeacherUIByStatus:_classDetail.status];
    } else {
        
        // 设置学生UI
        if (_classDetail.is_cancel_appointment) {
            _rightButotn.hidden = YES;
        } else {
            _rightButotn.hidden = NO;
        }
        
        if (_classDetail.status == 1 || _classDetail.status == 7) {
            
            [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_course"] forState:UIControlStateNormal];
            self.contentButton.enabled = YES;
        } else {
            
            [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_no"] forState:UIControlStateNormal];
            self.contentButton.enabled = NO;
        }
    }
}

/**
 *  设置老师端UI
 *
 *  @param status 
 *  11--课程处于初始化状态，显示两个按钮：取消开课，确定开课
 *  12--已确定开课，班次还未开始上，按钮不可点击
 *  13--已确定开课，班次进行中，按钮不可点击
 *  14--已确定开课，班次已结束，按钮可点击，结束班次
 *  15--班次课程已取消，不显示按钮
 *  16--班次课程已结束，不显示按钮
 */
- (void)setTeacherUIByStatus:(int)status {

    switch (status) {
        case 11:
            [self showCourseActionView];
            break;
        case 12:
            [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_no"] forState:UIControlStateNormal];
            self.contentButton.enabled = NO;
            break;
            
        case 13:
            [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_no"] forState:UIControlStateNormal];
            self.contentButton.enabled = NO;
            break;
            
        case 14:
            [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
            self.contentButton.enabled = YES;
            break;
            
        case 15:
            self.contentButton.hidden = YES;
            break;
            
        case 16:
            self.contentButton.hidden = YES;
            break;
        default:
            self.contentButton.hidden = YES;
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contentButtonAction:(UIButton *)button {
    
    if (_classDetail) {
        
        if ([Account shareManager].userModel.user.type == 1) {
            if (_classDetail.status == 14) {
                
                // 结束课程
                [self modifyOpenclasssStatusByOpencourseId:2];
            }
        } else {
            
            // 学生端处理情况
            if (_classDetail.status == 1) {
                
                [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
                
                [DataHelper appointCourseClassWithCourseId:_classDetail.opencourse_id class_id:_classDetail.cid success:^(id responseObject) {
                    
                    ErrorModel *model = responseObject;
                    if (model && model.error_code == 0) {
                        
                        // 预约成功
                        [SVProgressHUD showSuccessWithStatus:@"预约成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } else {
                        [SVProgressHUD showErrorWithStatus:model.error_msg];
                    }
                } fail:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"预约失败"];
                }];
                
            } else {
                
                // 到评价页面
                AddCommentViewController *addVc = [[AddCommentViewController alloc] initWithNibName:@"AddCommentViewController" bundle:nil];
                addVc.cid = _classDetail.cid;
                [self.navigationController pushViewController:addVc animated:YES];
            }
        }
    }
}

- (void)praseDict:(NSDictionary *)dict type:(int)type {
    [super praseDict:dict type:type];
    
    /*
     班级详情页, 跳转到地图显示授课地点, params为经纬度, 班级名称
     *          9-- params: {"type":9,"longitude":112.12,"latitude":39.102,"name":"一班"}
     *          10--班级详情页, 跳转到班级成员列表, params为班级id, 群组id, 群组类型
     *              params: {"type":10,"class_id":1,"group_id":10,"group_type":1}

     */
    if (type == 9) {
        
        BdLocationViewController *locationVc = [[BdLocationViewController alloc] init];
        locationVc.name = dict[@"name"];
        float lat = [dict[@"latitude"] floatValue];
        float lon = [dict[@"longitude"] floatValue];
        locationVc.cooridinate = CLLocationCoordinate2DMake(lat, lon);
        [self.navigationController pushViewController:locationVc animated:YES];
        
    } else if (type == 10) {
        
        int class_id = [dict[@"class_id"] intValue];
        int group_id = [dict[@"group_id"] intValue];
        int group_type = [dict[@"group_type"] intValue];
        ClassMemberViewController *classVc =
        [[ClassMemberViewController alloc] initWithNibName:@"ClassMemberViewController" bundle:nil];
        classVc.class_id = class_id;
        classVc.group_id = group_id;
        classVc.group_type = group_type;
        classVc.huanxin_id = _classDetail.huanxin_id;
        if (_classDetail.status == 6 || _classDetail.status == 7 || _classDetail.status == 8) {
            classVc.isCanChat = YES;
        }
        classVc.name = _classDetail.name;
        [self.navigationController pushViewController:classVc animated:YES];
    }
}

/**
 *  老师端，显示操作按钮
 */
- (void)showCourseActionView {
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, SCREEN_HEIGHT-44, SCREEN_WIDTH/2, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        switch (i) {
            case 0:
                button.backgroundColor = UIColorFromRGB(0xee6267);
                [button setTitle:@"取消班次开课" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_btn_close"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_btn_close"] forState:UIControlStateHighlighted];
                
                break;
            case 1:
                button.backgroundColor = UIColorFromRGB(0x50c0bb);
                [button setImage:[UIImage imageNamed:@"icon_btn_sure"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_btn_sure"] forState:UIControlStateHighlighted];
                [button setTitle:@"确定班次开课" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 100) {
        [self modifyOpenclasssStatusByOpencourseId:3];
    } else {
        [self modifyOpenclasssStatusByOpencourseId:1];
    }
}

/**
 *  修改班次状态
 *
 *  @param type 1--已开课, 2--已结束, 3--取消开课
 */
- (void)modifyOpenclasssStatusByOpencourseId:(int)type {
    
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
    
    [DataHelper modifyOpenclasssStatusByOpencourseId:_classDetail.opencourse_id openclass_id:_classDetail.cid status:type success:^(id responseObject) {
        ErrorModel *model = responseObject;
        if (model.error_code == 0) {
            
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [SVProgressHUD showErrorWithStatus:model.error_msg];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"操作失败，请重试"];
    }];
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
