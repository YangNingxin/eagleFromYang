//
//  AddNoteViewController.m
//  NGEagle
//
//  Created by Liang on 16/5/3.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AddNoteViewController.h"
#import "CourseHelper.h"

@interface AddNoteViewController ()
{
    AddNoteSuccessBlock _block;
}
@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = @"添加笔记";
    
    // 去掉工具栏和选择项
    _itemView1.hidden = YES;
    _toolBarView.hidden = YES;
   
    // Do any additional setup after loading the view.
}

- (void)setAddNoteSuccessBlock:(AddNoteSuccessBlock)block {
    _block = block;
}

- (void)rightButtonAction {
    
    if (_textView.text.length == 0) {
        [self.view makeToast:@"内容不能为空" duration:1.0 position:@"bottom"];
        return;
    }
    [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在提交..." animated:YES];
    
    [CourseHelper addNote:self.type target_id:self.target_id content:_textView.text mark_at:self.mark_at success:^(id responseObject) {
        AddNoteSuccess *model = responseObject;
        if (model.error_code == 0) {
            model.data.content = _textView.text;
            _block(model);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:model.error_msg duration:1.0 position:@"bottom"];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } fail:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
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
