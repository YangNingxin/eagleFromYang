//
//  VerifyPassViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface VerifyPassViewController : BaseViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *passText1;
@property (weak, nonatomic) IBOutlet UITextField *passText2;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

- (IBAction)finishAction:(UIButton *)sender;

@end
