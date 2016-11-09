//
//  NGWebView.m
//  NGEagle
//
//  Created by Liang on 15/7/30.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NGWebView.h"

@implementation NGWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self stringByEvaluatingJavaScriptFromString: @"document.documentElement.style.webkitUserSelect='none';"];
        
        [self stringByEvaluatingJavaScriptFromString:
         @"document.documentElement.style.webkitTouchCallout='none';"];

        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
        longPress.delegate = self; //记得在.h文件里加上<UIGestureRecognizerDelegate>委托
        longPress.minimumPressDuration = 0.3; //这里为什么要设置0.4，因为只要大于0.5就无效，我像大概是因为默认的跳出放大镜的手势的长按时间是0.5秒，
        //如果我们自定义的手势大于或小于0.5秒的话就来不及替换他的默认手势了，这是只是我的猜测。但是最好大于0.2
        //秒，因为有的pdf有一些书签跳转功能，这个值太小的话可能会使这些功能失效。
        [self addGestureRecognizer:longPress];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//接下来就是实现一个委托了
#pragma mark - GestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO; //这里一定要return NO,至于为什么大家去看看这个方法的文档吧。
    //还有就是这个委托在你长按的时候会被多次调用，大家可以用nslog输出gestureRecognizer和otherGestureRecognizer
    //看看都是些什么东西。
}

@end
