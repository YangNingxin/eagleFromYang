//
//  ContactViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface ContactViewController : BaseViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end
