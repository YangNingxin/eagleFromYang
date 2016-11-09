//
//  WebViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/26.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "WebViewController.h"
#import "ClassListViewController.h"
#import "NSString+JSONKit.h"

@interface WebViewController ()

@end

@implementation WebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoLoginFinishNSNotification)
                                                 name:@"autoLoginFinishNSNotification"
                                               object:nil];
    
    // 加入UA
    NSDictionary *dictionary = [[NSDictionary alloc]
                                initWithObjectsAndKeys:@"XUEHU-IPHONE", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webview.opaque = NO;
    self.webview.backgroundColor = self.view.backgroundColor;
    self.webview.allowsInlineMediaPlayback = YES;

    _requestURL = [NSURL URLWithString:self.url];
    
    __weak typeof(self) weakSelf = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:_requestURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:7 * 3600 * 24];
    [self.webview.scrollView addLegendHeaderWithRefreshingBlock:^{
        [DataHelper setCookieWithURL:_requestURL.host];
        [weakSelf.webview loadRequest:request];
    }];

    [self.webview.scrollView.header beginRefreshing];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)autoLoginFinishNSNotification {
    [DataHelper setCookieWithURL:_requestURL.host];
    [self.webview loadRequest:[NSURLRequest requestWithURL:_requestURL]];
}

- (void)configBaseUI {
    
    [super configBaseUI];
    _titleLabel.text = self.webTitle;
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    self.bottomView.backgroundColor = RGB(225, 230, 230);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    NSArray *array = [url.query componentsSeparatedByString:@"params="];
    if (array.count >= 2) {
        NSString *json = array[1];
        json = [json stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"json is %@",json);
        NSDictionary *resultDict = [json jsonValue];
        int type = [resultDict[@"type"] intValue];
        [self praseDict:resultDict type:type];
        
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [self.webview.scrollView.header endRefreshing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [self.webview.scrollView.header endRefreshing];
}

- (IBAction)contentButtonAction:(UIButton *)button {
    
}

/**
 *  解析webview
 *
 *  @param dict
 */

- (void)praseDict:(NSDictionary *)dict type:(int)type {
    NSLog(@"type is %d", type);
    NSLog(@"dict is %@", dict);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
