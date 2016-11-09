//
//  CCBaseWebController.h
//  NGEagle
//
//  Created by Liang on 16/4/7.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGWebView.h"

@interface CCBaseWebController : BaseViewController <UIWebViewDelegate>
{
    
}
@property (nonatomic, strong) NGWebView *webview;
/**
 *  url地址
 */
@property (nonatomic, strong) NSString *url;
- (void)praseDict:(NSDictionary *)dict type:(int)type;
@end
