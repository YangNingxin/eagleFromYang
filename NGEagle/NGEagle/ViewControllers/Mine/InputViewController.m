//
//  InputViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()
{
    GroupView *groupView;
    UITextField *textField;
    UITextView *textView;
}
@end

@implementation InputViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initView];
    
    if (self.type == 0 || self.type == 3) {
        textField.hidden = NO;
        textField.text = self.content;
        textView.font = [UIFont systemFontOfSize:15.0];
        
    } else {
        textView.hidden = NO;
        textView.text = self.content;
        textView.font = [UIFont systemFontOfSize:15.0];
        
        groupView.frame = CGRectMake(0, 70, SCREEN_WIDTH, 120);
        textView.frame = CGRectMake(5, 2, SCREEN_WIDTH-10, 120-4);
        [groupView setNeedsDisplay];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.type == 0) {
        [textField becomeFirstResponder];
    } else {
        [textView becomeFirstResponder];
    }
}

- (void)initView {
    groupView = [[GroupView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 44)];
    [self.view addSubview:groupView];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH-10, 40)];
    textView.hidden = YES;
    [groupView addSubview:textView];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH-10, 40)];
    textField.hidden = YES;
    [groupView addSubview:textField];
    

}

- (void)configBaseUI {
    [super configBaseUI];
    
    if (self.type == 0) {
        _titleLabel.text = @"修改姓名";
    } else if (self.type == 1) {
        _titleLabel.text = @"兴趣爱好";
    } else if (self.type == 2) {
        _titleLabel.text = @"个人简介";
    } else if (self.type == 3) {
        _titleLabel.text = @"真实姓名";
    }

    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setTitle:@"完成" forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    
    if (self.type == 0) {
        
        if (textField.text.length == 0) {
            [self.view makeToast:@"不能为空" duration:0.5 position:@"center"];
            return;
        } else if (textField.text.length > 20) {
            [self.view makeToast:@"不能超过20个字" duration:0.5 position:@"center"];
            return;
        }
        _block(textField.text);

    } else if (self.type == 1) {
        
        if (textView.text.length == 0) {
            [self.view makeToast:@"不能为空" duration:0.5 position:@"center"];
            return;
        } else if (textView.text.length > 64) {
            [self.view makeToast:@"不能超过64个字" duration:0.5 position:@"center"];
            return;
        }
        
        _block(textView.text);

    } else if (self.type == 2) {
       
        if (textView.text.length == 0) {
            [self.view makeToast:@"不能为空" duration:0.5 position:@"center"];
            return;
        } else if (textView.text.length > 300) {
            [self.view makeToast:@"不能超过300个字" duration:0.5 position:@"center"];
            return;
        }
        _block(textView.text);

    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFinishBlock:(FinishBlock)block {
    _block = block;
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
