//
//  WebViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/26.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "NGWebView.h"

typedef enum {
    
    // 课程详情
    COURSE_DETAIL = 0,
    
    // 班次详情
    CLASS_DETAIL = 1,
    
}WebType;

@interface WebViewController : BaseViewController<UIWebViewDelegate>
{
    NSOperation *_request;
    NSURL *_requestURL;
}

@property (nonatomic) int cid;

@property (nonatomic, weak) IBOutlet NGWebView *webview;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) WebType webType;
@property (nonatomic, strong) NSString *webTitle;

@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIButton *contentButton;

- (IBAction)contentButtonAction:(UIButton *)button;

- (void)praseDict:(NSDictionary *)dict type:(int)type;

@end
