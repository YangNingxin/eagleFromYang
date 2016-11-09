//
//  AddDynamicViewController.m
//  NGEagle
//
//  Created by Liang on 16/4/25.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AddDynamicViewController.h"

@interface AddDynamicViewController () <UIActionSheetDelegate>
{
    /**
     *  0-所有人可见 1-好友可见 2-私密
     */
    int _permissionType;
}
@end

@implementation AddDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.text = @"发布动态";
    [_itemView1.leftLabel initWithData:@"谁可以看" image:[UIImage imageNamed:@"add_button"]];
    _itemView1.numberLabel.text = @"所有人可见";

    // Do any additional setup after loading the view.
}

- (void)rightButtonAction {
    if (_textView.text.length == 0) {
        [self.view makeToast:@"内容不能为空" duration:1.0 position:@"bottom"];
        return;
    }
    [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在提交..." animated:YES];

    [ChatDataHelper publishDynamicWithContent:_textView.text
                                         type:self.groupType
                                     resource:self.fileDict
                                   permission:_permissionType
                                          gid:self.groupId
                                          pid:nil at_ids:nil success:^(id responseObject) {
                                              ErrorModel *model = responseObject;
                                              if (model.error_code == 0) {
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  [self.view makeToast:model.error_msg duration:1.0 position:@"bottom"];
                                              }
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                                          } fail:^(NSError *error) {
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          }];
}

- (void)selectItem:(ItemView *)itemView {

    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"所有人可见", @"好友可见", @"私密", nil];
    [sheetView showInView:self.view];
}

- (void)selectPermission {
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"所有人可见", @"好友可见", @"私密", nil];
    [sheetView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex is %ld", buttonIndex);
    if (buttonIndex  != 3) {
        _permissionType = (int)buttonIndex;
        switch (_permissionType) {
            case 0:
                 _itemView1.numberLabel.text = @"所有人可见";
                break;
            case 1:
                _itemView1.numberLabel.text = @"好友可见";
                break;
            case 2:
                _itemView1.numberLabel.text = @"私密";
                break;
            default:
                break;
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
