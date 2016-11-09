//
//  ContactViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.opaque = NO;
    self.webView.backgroundColor = self.view.backgroundColor;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:API_SERVER]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"联系我们";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

#pragma mark
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    
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
