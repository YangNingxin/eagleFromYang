//
//  CCBaseWebController.m
//  NGEagle
//
//  Created by Liang on 16/4/7.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCBaseWebController.h"
#import "NSString+JSONKit.h"
#import "CCCourseDetailController.h"

@interface CCBaseWebController ()
{
    NSURL *_requestURL;
}
@end

@implementation CCBaseWebController

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
    
    
    self.webview = [NGWebView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webview.opaque = NO;
    self.webview.delegate = self;
    self.webview.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.webview];
    
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    
    self.webview.allowsInlineMediaPlayback = YES;

    _requestURL = [NSURL URLWithString:self.url];
    
    __weak typeof(self) weakSelf = self;
    __weak NSURL *url = _requestURL;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_requestURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:7 * 3600 * 24];
    
    [self.webview.scrollView addLegendHeaderWithRefreshingBlock:^{
        [DataHelper setCookieWithURL:url.host];
        [weakSelf.webview loadRequest:request];
    }];

    [self.webview.scrollView.header beginRefreshing];
    
//    [DataHelper setCookieWithURL:url.host];
//    [weakSelf.webview loadRequest:request];
    
//    [self.webview.scrollView.header beginRefreshing];
    
    // Do any additional setup after loading the view.
}
- (void)autoLoginFinishNSNotification {
    [DataHelper setCookieWithURL:_requestURL.host];
    [self.webview loadRequest:[NSURLRequest requestWithURL:_requestURL]];
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

/**
 *  解析webview
 *
 *  @param dict
 */

- (void)praseDict:(NSDictionary *)dict type:(int)type {
    NSLog(@"type is %d", type);
    NSLog(@"dict is %@", dict);
    if (type == 0) {
        // 打开一个h5
        /*
         target_type: 打开页面的类型, 对于各类详情页有效. 
         501/505--微课详情页, 502--课程集 701--问答
         target_id: 打开类型的对应id
         */
        int target_type = [dict[@"target_type"] intValue];
        int target_id = [dict[@"target_id"] intValue];
        NSString *title = dict[@"title"];
        NSString *url = dict[@"url"];
        
        if (target_type == 501 || target_type == 502 || target_type == 505) {
            CCCourseDetailController *detailVc = [[CCCourseDetailController alloc] init];
            detailVc.courseId = target_id;
            detailVc.obj_type_id = target_type;
            detailVc.url = url;
            detailVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVc animated:YES];
        } else if (target_type == 701) {
            
        }
        
    }
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
